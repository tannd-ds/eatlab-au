from pathlib import Path
from typing import List, Dict, Any, AsyncGenerator, Tuple
from ultralytics import YOLO
import cv2
import numpy as np
import mlflow
import os
import json
import asyncio
import base64
import time
from shapely.geometry import Point, Polygon

# --- Globals ---
mlflow.set_tracking_uri(os.environ.get("MLFLOW_TRACKING_URI", "http://localhost:5000"))

class DispatcherTracker:
    """
    An intelligent tracker
    """
    DEFAULT_MODEL_PATH = Path("models/dispatch_tracker/weights/best.pt")

    def __init__(self, 
                 weights: str | Path | None = None, 
                 device: str | None = None,
                 zones: Dict[str, List[Tuple[int, int]]] | None = None):
        if weights:
            model_path = weights
            print(f"Loading specified model: {model_path}")
        elif self.DEFAULT_MODEL_PATH.exists():
            model_path = self.DEFAULT_MODEL_PATH
            print(f"Loading custom model from: {model_path}")
        else:
            model_path = "yolov8n.pt"
            print(f"Custom model not found. Loading default YOLOv8n: {model_path}")

        self.model = YOLO(model_path)
        if device:
            self.model.to(device)

        self.tracked_objects: Dict[int, Dict[str, Any]] = {}
        self.zones: Dict[str, Polygon] = {}

        if zones:
            self.set_zones(zones)

    def set_zones(self, zones: Dict[str, List[Tuple[int, int]]]):
        """Defines polygonal zones for monitoring."""
        self.zones = {name: Polygon(points) for name, points in zones.items()}
        print(f"Zones set: {list(self.zones.keys())}")

    def _update_object_state(self, 
                             track_id: int, 
                             centroid: Point, 
                             current_time: float, 
                             event_type: str) -> Dict[str, Any] | None:
        """Update the state of a tracked object and generate an event if the state changes."""

        current_zone = None
        for name, poly in self.zones.items():
            if poly.contains(centroid):
                current_zone = name
                break

        previous_state = self.tracked_objects.get(track_id)


        if not previous_state:
            if current_zone:
                self.tracked_objects[track_id] = {
                    "zone": current_zone,
                    "dwell_start": current_time,
                    "history": [current_zone]
                }
                return {
                    "event": f"item_{event_type}",
                    "track_id": track_id,
                    "to_zone": current_zone,
                }
        else:
            self.tracked_objects[track_id]["centroid"] = (int(centroid.x), int(centroid.y))
            previous_zone = previous_state["zone"]
            if current_zone != previous_zone:
                dwell_time = round(current_time - previous_state["dwell_start"], 2)
                
                event_data = {
                    "event": f"item_{event_type}",
                    "track_id": track_id,
                    "from_zone": previous_zone,
                    "to_zone": current_zone,
                    "dwell_time": dwell_time,
                }
                
                if not current_zone:
                    del self.tracked_objects[track_id]
                else:
                    previous_state["zone"] = current_zone
                    previous_state["dwell_start"] = current_time
                    previous_state["history"].append(current_zone)
                
                return event_data
        
        return None

    async def track_video_stream(self, source) -> AsyncGenerator[str, None]:
        cap = cv2.VideoCapture(int(source) if str(source).isdigit() else str(source))
        if not cap.isOpened():
            raise IOError(f"Cannot open video source: {source}")

        try:
            while cap.isOpened():
                success, frame = cap.read()
                if not success:
                    break

                current_time = time.time()
                
                current_frame_events = []
                frame_detections = []

                for name, poly in self.zones.items():
                    pts = np.array(poly.exterior.coords, dtype=np.int32)
                    cv2.polylines(frame, [pts], isClosed=True, color=(0, 255, 255), thickness=2)
                    cv2.putText(frame, name, (pts[0][0], pts[0][1] - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 255), 2)

                    frame_to_track = frame[pts[0][1]:pts[2][1], pts[0][0]:pts[2][0]]
                    offset_x = pts[0][0]
                    offset_y = pts[0][1]

                    results = self.model.track(frame_to_track, stream=False, persist=True, verbose=False)
                    if results:
                        results = results[0]

                    for box in results.boxes:
                        x1, y1, x2, y2 = map(int, box.xyxy[0].tolist())
                        x1, y1, x2, y2 = x1 + offset_x, y1 + offset_y, x2 + offset_x, y2 + offset_y
                        x1, y1, x2, y2 = int(x1), int(y1), int(x2), int(y2)
                        
                        track_id = int(box.id.item())
                        centroid = Point((x1 + x2) / 2, (y1 + y2) / 2)
                        
                        event = self._update_object_state(track_id, centroid, current_time, "detected")
                        if event:
                            current_frame_events.append(event)

                        frame_detections.append({
                            "bbox": [x1, y1, x2, y2],
                            "confidence": float(box.conf.item()),
                            "label": self.model.names[int(box.cls.item())],
                            "track_id": track_id,
                        })

                # update state for other objects
                for track_id, data in self.tracked_objects.items():
                    if track_id not in [box.id.item() for box in results.boxes]:
                        print(f"[DEBUG] {data} not in results")
                        event = self._update_object_state(track_id, Point(data["centroid"]), current_time, "lost")
                        if event:
                            current_frame_events.append(event)

                _, buffer = cv2.imencode('.jpg', frame)
                frame_b64 = base64.b64encode(buffer).decode('utf-8')

                active_objects = {
                    tid: {**data, "dwell_time": round(current_time - data["dwell_start"], 2)}
                    for tid, data in self.tracked_objects.items()
                }

                data_to_stream = {
                    "detections": frame_detections,
                    "active_objects": active_objects,
                    "events": current_frame_events,
                    "image_b64": frame_b64,
                }
                yield f"{json.dumps(data_to_stream)}\n\n"
                await asyncio.sleep(1/30)
        finally:
            cap.release()

    def infer(self, image: np.ndarray) -> List[Dict[str, Any]]:
        """Run object detection on a single BGR image.

        Returns a list of dicts {bbox, confidence, class_id, label}.
        """
        results = self.model(image, verbose=False)[0]
        output: List[Dict[str, Any]] = []
        for box in results.boxes:
            x1, y1, x2, y2 = box.xyxy[0].tolist()
            output.append({
                "bbox": [x1, y1, x2, y2],
                "confidence": float(box.conf.item()),
                "class_id": int(box.cls.item()),
                "label": self.model.names[int(box.cls.item())],
            })
        return output

    def track_video(self, source: str | Path, save_path: str | Path | None = None) -> List[Dict[str, Any]]:
        """Just a placeholder"""
        all_frames: List[Dict[str, Any]] = []

        # write to disk as JSON (not required)
        if save_path:
            os.makedirs(Path(save_path).parent, exist_ok=True)
            Path(save_path).write_text(json.dumps(all_frames))

        return all_frames 