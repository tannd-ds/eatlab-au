Dispatch Monitoring System
===========================

```
PROBLEM SCOPE

Dispatch Monitoring System
- Develop an intelligent monitoring system for a commercial kitchen's dispatch area. 
- Using the provided video and dataset (in ./datasets/)
- build a complete solution capable of tracking items within the dispatch area. 
- The system should also include functionality to improve model performance based on user feedback

Requirements:
- Use *Docker Compose* for system deployment.
- Provide a *README* file with clear installation and usage instructions.
- Upload all source code and trained models to *GitHub.*
```

Features
--------
Update later

Directory Layout
----------------
```
eatlab-au-tracker/
├── config.env.example          # Example for environment variables
├── .gitignore
├── docker-compose.yml
├── mlflow.Dockerfile
├── README.md
├── requirements.txt
├── configs/                     
│   ├── dispatch_data.yaml      # Config for train Detector
│   └── settings.py             # TODO
├── scripts/                    # TODO (refactor)
│   ├── train_detector.py       # src/train.py
│   └── train_classifier.py     # src/scripts/train_resnet.py
├── src/                        # Main application source code
│   ├── __init__.py
│   ├── main.py                 # TODO: Main FastAPI app entrypoint
│   ├── api/                    # TODO: For API-related modules
│   │   ├── __init__.py
│   │   ├── endpoints.py        # Logic from your old api.py
│   │   └── schemas.py          # Pydantic models (e.g., FeedbackIn)
│   ├── models/                 # For model interaction logic
│   │   ├── __init__.py
│   │   ├── classifier.py       # Handles loading and running the classifier
│   │   └── detector.py         # Handles loading and running the YOLO detector
│   ├── services/               # external services
│   │   ├── __init__.py
│   │   ├── feedback.py         # TODO
│   │   └── mlflow_client.py    # Dedicated client for all MLflow interactions
│   └── track/                  # "track" related functionalities
│       ├── __init__.py
│       └── BaseTrack.py   
└── static/                     # UI
    ├── index.html
    ├── script.js
    └── style.css
```

Prerequisites
-------------
* Docker

Quick Start
-----------
1. Clone the repository (or download the code).
2. Place the provided `datasets/` folder alongside this README.
3. Copy the `config.env
3. Build & start the service:

   ```bash
   docker compose --env-file config.env up -d --build
   ```
4. Open your browser at `http://localhost:8000/docs` to explore the interactive Swagger UI.

Training an Initial Model
-------------------------
The repository includes a training script (`src/train.py`) and a Docker Compose service to fine-tune a YOLOv8 model on the provided dataset.

1.  **Data Configuration**: A `dispatch_data.yaml` file is included, pointing to the training/validation sets inside the container.
2.  **Run Training**: Use the `train` service in the `docker-compose.yml` file. This service is configured to use a GPU if available.

    ```bash
    docker compose run --rm train
    ```
    You can customize `epochs`, `batch-size`, and other parameters by modifying the `command` in `docker-compose.yml`.
3.  **Use Model**: After training, the best model weights will be at `models/dispatch_tracker/weights/best.pt`. The application will automatically load these weights on startup.
