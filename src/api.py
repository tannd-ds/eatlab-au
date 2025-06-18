from fastapi import FastAPI, HTTPException, Request
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from sse_starlette.sse import EventSourceResponse
from pydantic import BaseModel
from typing import List, Dict, Any, Optional
import os

from .tracker import DispatcherTracker
from .services.feedback import save_feedback
from .services.mlflow_client import MLflowClient

app = FastAPI(title="Dispatch Monitoring System")
app.mount("/static", StaticFiles(directory="static"), name="static")

# --- Globals ---
tracker: Optional[DispatcherTracker] = None
mlflow_client: Optional[MLflowClient] = None
VIDEO_PATH = "datasets/AU/1473_CH05_20250501133703_154216.mp4"
DISPATCH_ZONES = {
    "staging_area": [
        (900, 50), (1500, 50), (1500, 300), (900, 300)
    ]
}

@app.on_event("startup")
def startup_event():
    """Initialise the model tracker and database on startup."""
    global tracker, mlflow_client
    mlflow_client = MLflowClient()
    tracker = DispatcherTracker()
    tracker.set_zones(DISPATCH_ZONES)
    print("Default model loaded and zones configured.")


class FeedbackIn(BaseModel):
    source_video: str
    frame: int
    bbox: List[float]  # [x1,y1,x2,y2]
    correct_label: str
    notes: str | None = None


@app.get("/", response_class=HTMLResponse)
async def read_root(request: Request):
    with open("static/index.html") as f:
        return HTMLResponse(content=f.read(), status_code=200)


@app.get("/experiments")
def get_experiments() -> List[Dict[str, Any]]:
    """Fetch all experiments and their runs from MLflow."""
    if not mlflow_client:
        raise HTTPException(status_code=503, detail="MLflow client not initialized.")
    return mlflow_client.get_experiments()


@app.post("/load-model")
async def load_model(payload: Dict[str, str]):
    """Load a new model from the specified MLflow artifact path."""
    global tracker
    if not tracker or not mlflow_client:
        raise HTTPException(status_code=503, detail="Tracker or MLflow client not initialized.")

    artifact_path = payload.get("artifact_path")
    run_id = payload.get("run_id")

    if not artifact_path or not run_id:
        raise HTTPException(status_code=400, detail="Missing artifact_path or run_id.")

    try:
        print(f"Attempting to load model '{artifact_path}' from run '{run_id}'...")
        local_path = mlflow_client.load_model(run_id=run_id, artifact_path=artifact_path)
        
        tracker.set_detector(local_path)
        tracker.set_zones(DISPATCH_ZONES)
        print(f"Successfully loaded model from {local_path}")
        return {"message": f"Model '{artifact_path}' loaded successfully."}
    except Exception as e:
        print(f"Error loading model: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to load model. Error: {e}")


@app.get("/health")
def health_check() -> Dict[str, str]:
    return {"status": "ok"}


@app.get("/video-stream")
async def video_stream(request: Request):
    """Streams annotated video frames using Server-Sent Events."""
    if not tracker:
        raise HTTPException(status_code=503, detail="Model not loaded. Please select a model.")
    stream_generator = tracker.track_video_stream(VIDEO_PATH)
    return EventSourceResponse(stream_generator, media_type="text/event-stream")


@app.post("/feedback")
async def feedback(data: FeedbackIn):
    """Persist user feedback to the database for later retraining."""
    save_feedback(data.dict())
    return {"message": "Thank you for your feedback!"} 