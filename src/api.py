from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.responses import JSONResponse
from pydantic import BaseModel
from typing import List, Dict, Any
from pathlib import Path
import shutil
import uuid

from .tracker import DispatcherTracker
from .feedback import save_feedback

app = FastAPI(title="Dispatch Monitoring System")

# Initialise model once at startup
detector = DispatcherTracker()


class FeedbackIn(BaseModel):
    frame: int
    bbox: List[float]  # [x1,y1,x2,y2]
    correct_label: str
    notes: str | None = None


@app.get("/health")
def health_check() -> Dict[str, str]:
    return {"status": "ok"}


@app.post("/infer")
async def infer(file: UploadFile = File(...)):
    """Run detection/tracking on an uploaded image or video file."""
    # Save upload to a temporary file on disk (for video handling)
    suffix = Path(file.filename).suffix
    temp_path = Path("/tmp") / f"{uuid.uuid4().hex}{suffix}"
    with temp_path.open("wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    if suffix.lower() in {".jpg", ".jpeg", ".png"}:
        # Image
        import cv2
        img = cv2.imread(str(temp_path))
        if img is None:
            raise HTTPException(status_code=400, detail="Invalid image file.")
        detections = detector.infer(img)
        temp_path.unlink(missing_ok=True)
        return JSONResponse(content={"detections": detections})
    else:
        # Assume video
        results = detector.track_video(temp_path)
        temp_path.unlink(missing_ok=True)
        return JSONResponse(content={"frames": results})


@app.post("/feedback")
async def feedback(data: FeedbackIn):
    """Persist user feedback to disk for later retraining."""
    save_feedback(data.dict())
    return {"message": "Thank you for your feedback!"} 