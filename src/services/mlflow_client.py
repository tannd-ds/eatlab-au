import mlflow
import os
from typing import List, Dict, Any


class MLflowClient:
    _instance = None
    def __new__(cls, *args, **kwargs):
        if cls._instance is None:
            print("[INFO] No MLflowClient instance found, creating new one")
            cls._instance = super().__new__(cls)
        else:
            print("[INFO] MLflowClient instance already exists, returning existing instance")
        return cls._instance

    def __init__(self, tracking_uri: str | None = None):
        self.tracking_uri = tracking_uri or os.environ.get("MLFLOW_TRACKING_URI", "http://localhost:5000")
        mlflow.set_tracking_uri(self.tracking_uri)
        self.client = mlflow.tracking.MlflowClient()

    def start_run(self, experiment_name: str, run_name: str):
        mlflow.set_experiment(experiment_name)
        return mlflow.start_run(run_name=run_name)

    def get_experiments(self) -> List[Dict[str, Any]]:
        """
        Fetch all experiments and their runs from MLflow.
        """
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

    def load_model(self, run_id: str, artifact_path: str) -> str:
        model_uri = f"runs:/{run_id}/{artifact_path}"
        local_path = mlflow.artifacts.download_artifacts(model_uri)
        return local_path

    def load_pytorch_model(self, *args, **kwargs):
        return mlflow.pytorch.load_model(*args, **kwargs)

    def log_params(self, params: Dict[str, Any]):
        mlflow.log_params(params)

    def log_metrics(self, metrics: Dict[str, float], step: int | None = None):
        mlflow.log_metrics(metrics, step=step)

    def register_model(self, *args, **kwargs):
        return mlflow.register_model(*args, **kwargs)

    def search_runs(self, *args, **kwargs):
        return mlflow.search_runs(*args, **kwargs)

    def log_pytorch_model(self, *args, **kwargs):
        mlflow.pytorch.log_model(*args, **kwargs)

    def get_experiment_by_name(self, name: str):
        return self.client.get_experiment_by_name(name)

    def get_latest_model_uri_from_experiment(self, experiment_name: str) -> str | None:
        """
        Get the latest model URI from a given experiment.
        """
        experiment = self.get_experiment_by_name(experiment_name)
        if not experiment:
            return None

        experiment_id = experiment.experiment_id
        logged_model_latest = self.client.search_logged_models(
            experiment_ids=[experiment_id],
            max_results=1
        )

        if not logged_model_latest:
            return None
        
        latest_model = logged_model_latest[0]
        return latest_model.artifact_location
