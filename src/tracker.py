from pathlib import Path
from typing import List, Dict, Any

import cv2
import numpy as np
from ultralytics import YOLO


class DispatcherTracker:
    """Wrapper around YOLOv8 + simple centroid tracking.

    In production you may swap in DeepSORT or ByteTrack; this class
    supplies a common interface used by the API layer.
    """

    def __init__(self, weights: str | Path = "yolov8n.pt", device: str | None = None):
        self.model = YOLO(str(weights))
        if device:
            self.model.to(device)

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
            import json, os
            os.makedirs(Path(save_path).parent, exist_ok=True)
            Path(save_path).write_text(json.dumps(all_frames))

        return all_frames 