from fastapi import FastAPI, UploadFile, File, HTTPException, Request
from fastapi.responses import JSONResponse, HTMLResponse
from fastapi.staticfiles import StaticFiles
from sse_starlette.sse import EventSourceResponse
from pydantic import BaseModel
from typing import List, Dict, Any
from pathlib import Path
import shutil
import uuid
import tempfile
import mlflow
import os

from .tracker import DispatcherTracker
from .feedback import save_feedback

app = FastAPI(title="Dispatch Monitoring System")
app.mount("/static", StaticFiles(directory="static"), name="static")

# --- Globals ---
detector: DispatcherTracker | None = None
VIDEO_PATH = "datasets/AU/1473_CH05_20250501133703_154216.mp4"

@app.on_event("startup")
def startup_event():
    """Initialise the model tracker on startup."""
    global detector
    mlflow.set_tracking_uri(os.environ.get("MLFLOW_TRACKING_URI", "http://localhost:5000"))
    detector = DispatcherTracker()
    print("Default model loaded.")


class FeedbackIn(BaseModel):
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
    experiments_data = []
    experiments = mlflow.search_experiments()
    for exp in experiments:
        runs_data = []
        runs = mlflow.search_runs(experiment_ids=[exp.experiment_id])
        if runs.empty:
            continue
        
        for _, run in runs.iterrows():
            artifact_uri = run.artifact_uri
            try:
                artifacts = mlflow.artifacts.list_artifacts(artifact_uri + "/weights")
                if artifacts:
                     runs_data.append({
                        "run_id": run.run_id,
                        "run_name": run.get("tags.mlflow.runName", "default"),
                        "artifacts": [f.path for f in artifacts],
                        "artifact_uri": artifact_uri
                    })
            except Exception as e:
                print(f"Could not list artifacts for run {run.run_id}: {e}")
        
        if runs_data:
            experiments_data.append({
                "id": exp.experiment_id,
                "name": exp.name,
                "runs": runs_data
            })
    return experiments_data


@app.post("/load-model")
async def load_model(payload: Dict[str, str]):
    """Load a new model from the specified MLflow artifact path."""
    global detector
    artifact_path = payload.get("artifact_path")
    run_id = payload.get("run_id")

    if not artifact_path or not run_id:
        raise HTTPException(status_code=400, detail="Missing artifact_path or run_id.")

    try:
        print(f"Attempting to load model '{artifact_path}' from run '{run_id}'...")
        # store the chosen weights in a temporary directory
        model_uri = f"runs:/{run_id}/{artifact_path}"
        local_path = mlflow.artifacts.download_artifacts(model_uri)
        
        # Re-init
        detector = DispatcherTracker(weights=local_path)
        print(f"Successfully loaded model from {local_path}")
        return {"message": f"Model '{artifact_path}' loaded successfully."}
    except Exception as e:
        print(f"Error loading model: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to load model. Error: {e}")


@app.get("/health")
def health_check() -> Dict[str, str]:
    return {"status": "ok"}


@app.post("/infer")
async def infer(file: UploadFile = File(...)):
    """Run detection/tracking on an uploaded image or video file."""
    if not detector:
        raise HTTPException(status_code=503, detail="Model not loaded. Please select a model.")
    # Save upload to a temporary file on disk (for video handling)
    suffix = Path(file.filename).suffix
    temp_dir = tempfile.gettempdir()
    temp_path = Path(temp_dir) / f"{uuid.uuid4().hex}{suffix}"
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


@app.get("/video-stream")
async def video_stream(request: Request):
    """Streams annotated video frames using Server-Sent Events."""
    if not detector:
        raise HTTPException(status_code=503, detail="Model not loaded. Please select a model.")
    stream_generator = detector.track_video_stream(VIDEO_PATH, area=(900, 50, 1500, 300))
    return EventSourceResponse(stream_generator)


@app.post("/feedback")
async def feedback(data: FeedbackIn):
    """Persist user feedback to disk for later retraining."""
    save_feedback(data.dict())
    return {"message": "Thank you for your feedback!"} 