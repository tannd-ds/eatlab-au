import argparse
from pathlib import Path
from ultralytics import YOLO, settings
import mlflow
import os

def train(data_config_path: str, epochs: int, batch_size: int, weights: str, name: str, project: str):
    """
    Args:
        data_config_path (str): Path to the data configuration YAML file.
        epochs (int): Number of training epochs.
        batch_size (int): Batch size for training.
        weights (str): Path to pretrained weights (.pt file) or a model name like 'yolov8n.pt'.
    """
    mlflow.set_tracking_uri(os.environ.get("MLFLOW_TRACKING_URI"))
    mlflow.set_experiment(project)

    with mlflow.start_run(run_name=name) as run:
        mlflow.log_params({
            "data_config": data_config_path,
            "epochs": epochs,
            "batch_size": batch_size,
            "weights": weights,
        })

        model = YOLO(weights)

        print(f"Starting training with '{data_config_path}'...")
        results = model.train(
            data=data_config_path,
            epochs=epochs,
            batch=batch_size,
            imgsz=640,
            project=project,
            name=name,
            exist_ok=True, 
            workers=0,
        )
        print("[INFO] Training finished.")
    
        print(f"[INFO] Registering model from run {run.info.run_id}.")
        registered_model_name = f"{project}_yolov8n"
        mlflow.register_model(
            model_uri=f"mlflow-artifacts:/{run.info.run_id}/artifacts/weights/best.pt",
            name=registered_model_name
        )
        print(f"[INFO] Model '{registered_model_name}' registered from run {run.info.run_id}.")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Train")
    parser.add_argument('--data', type=str, default='dispatch_data.yaml', help='Path to the config file')
    parser.add_argument('--epochs', type=int, default=50, help='Number of training epochs')
    parser.add_argument('--batch-size', type=int, default=8, help='Batch size')
    parser.add_argument('--weights', type=str, default='yolov8n.pt', help='Initial weights for the model (e.g., yolov8n.pt)')
    parser.add_argument('--name', type=str, default='dispatch_tracker_run', help='Name of the run')
    parser.add_argument('--project', type=str, default='models', help='Project name')
    
    args = parser.parse_args()

    settings.update({"mlflow": True})
    train(
        data_config_path=args.data,
        epochs=args.epochs,
        batch_size=args.batch_size,
        weights=args.weights,
        name=args.name,
        project=args.project,
    ) 