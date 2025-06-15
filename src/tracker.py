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

mlflow.set_tracking_uri(os.environ.get("MLFLOW_TRACKING_URI"))

model_uri = "mlflow-artifacts:/1/f705565f4b2d42bb8ae252d7418395b9/artifacts/weights/last.pt"
model_path = mlflow.artifacts.download_artifacts(model_uri, dst_path="/app")

class DispatcherTracker:
    """Wrapper around YOLOv8 + simple centroid tracking.

    In production you may swap in DeepSORT or ByteTrack; this class
    supplies a common interface used by the API layer.
    """

    DEFAULT_MODEL_PATH = Path("/app/last.pt")

    def __init__(self, weights: str | Path | None = None, device: str | None = None):
        if weights is None:
            if self.DEFAULT_MODEL_PATH.exists():
                model_path = self.DEFAULT_MODEL_PATH
                print(f"Loading custom model: {model_path}")
            else:
                model_path = "yolov8n.pt"
                print(f"Custom model not found. Loading default: {model_path}")
        else:
            model_path = weights
            print(f"Loading specified model: {model_path}")

        self.model = YOLO(model_path)
        if device:
            self.model.to(device)

    async def track_video_stream(self, source, area) -> AsyncGenerator[str, None]:
        cap = cv2.VideoCapture(int(source) if str(source).isdigit() else str(source))
        if not cap.isOpened():
            raise IOError(f"Cannot open video source: {source}")

        try:
            while cap.isOpened():
                success, frame = cap.read()
                if not success:
                    break

                frame_to_track = frame
                offset_x, offset_y = 0, 0
                if area:
                    x1, y1, x2, y2 = area
                    frame_to_track = frame[y1:y2, x1:x2]
                    offset_x, offset_y = x1, y1
                
                results = self.model.track(frame_to_track, stream=False, persist=True, verbose=False)
                if results:
                    results = results[0] # track returns a list of results for a single image

                _, buffer = cv2.imencode('.jpg', frame)
                frame_b64 = base64.b64encode(buffer).decode('utf-8')

                detections = []
                if results and results.boxes.id is not None:
                    for box in results.boxes:
                        x1, y1, x2, y2 = box.xyxy[0].tolist()
                        detections.append({
                            "bbox": [x1 + offset_x, y1 + offset_y, x2 + offset_x, y2 + offset_y],
                            "confidence": float(box.conf.item()),
                            "class_id": int(box.cls.item()),
                            "label": self.model.names[int(box.cls.item())],
                            "track_id": int(box.id.item()),
                        })

                data = {
                    "detections": detections,
                    "image_b64": frame_b64,
                }

                yield f"{json.dumps(data)}\n\n"
                await asyncio.sleep(0.01)
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