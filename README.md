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

Prerequisites
-------------
* Docker

Quick Start
-----------
1. Clone the repository (or download the code).
2. Place the provided `datasets/` folder alongside this README.
3. Build & start the service:

   ```bash
   docker compose up --build
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
