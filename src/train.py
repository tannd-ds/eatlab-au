import argparse
from pathlib import Path
from ultralytics import YOLO, settings
import mlflow
import os

def train(data_config_path: str, epochs: int, batch_size: int, weights: str):
    """
    Args:
        data_config_path (str): Path to the data configuration YAML file.
        epochs (int): Number of training epochs.
        batch_size (int): Batch size for training.
        weights (str): Path to pretrained weights (.pt file) or a model name like 'yolov8n.pt'.
    """
    mlflow.set_tracking_uri(os.environ.get("MLFLOW_TRACKING_URI"))
    mlflow.set_experiment("dispatch_tracker")

    with mlflow.start_run():
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
            project="models",  # This will be used by ultralytics for local saving
            name="dispatch_tracker_run", # This will be used by ultralytics for local saving
            exist_ok=True, 
            workers=0,
        )
        print("Training finished.")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Train")
    parser.add_argument('--data', type=str, default='dispatch_data.yaml', help='Path to the config file')
    parser.add_argument('--epochs', type=int, default=50, help='Number of training epochs')
    parser.add_argument('--batch-size', type=int, default=8, help='Batch size')
    parser.add_argument('--weights', type=str, default='yolov8n.pt', help='Initial weights for the model (e.g., yolov8n.pt)')
    
    args = parser.parse_args()

    settings.update({"mlflow": True})
    train(
        data_config_path=args.data,
        epochs=args.epochs,
        batch_size=args.batch_size,
        weights=args.weights,
    ) 