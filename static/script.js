document.addEventListener('DOMContentLoaded', () => {
    // --- Model Selection ---
    const experimentSelect = document.getElementById('experimentSelect');
    const runSelect = document.getElementById('runSelect');
    const loadModelBtn = document.getElementById('loadModelBtn');
    const modelStatus = document.getElementById('model-status');
    let experimentsData = [];

    // --- Image Inference ---
    const imageUpload = document.getElementById('imageUpload');
    const uploadImageBtn = document.getElementById('uploadImageBtn');
    const imageResult = document.getElementById('imageResult');

    const startVideoBtn = document.getElementById('startVideoBtn');
    const stopVideoBtn = document.getElementById('stopVideoBtn');
    const videoCanvas = document.getElementById('videoCanvas');
    const videoStatus = document.getElementById('video-status');
    const ctx = videoCanvas.getContext('2d');

    let eventSource;

    // --- Model Loading Logic ---
    async function fetchExperiments() {
        try {
            const response = await fetch('/experiments');
            if (!response.ok) throw new Error('Failed to fetch experiments');
            experimentsData = await response.json();
            
            populateExperimentSelect();
            if (experimentsData.length > 0) {
                 // Trigger change to populate runs for the first experiment
                experimentSelect.dispatchEvent(new Event('change'));
            }
            modelStatus.textContent = 'Status: Experiments loaded. Select a model.';
        } catch (error) {
            console.error('Error fetching experiments:', error);
            modelStatus.textContent = 'Error: Could not load experiments from MLflow.';
        }
    }

    function populateExperimentSelect() {
        experimentSelect.innerHTML = '';
        experimentsData.forEach(exp => {
            const option = document.createElement('option');
            option.value = exp.id;
            option.textContent = exp.name;
            experimentSelect.appendChild(option);
        });
    }

    function populateRunSelect(experimentId) {
        runSelect.innerHTML = '';
        const selectedExperiment = experimentsData.find(exp => exp.id === experimentId);
        if (selectedExperiment) {
            selectedExperiment.runs.forEach(run => {
                // Assuming one .pt file per run for simplicity, can be expanded
                const artifact = run.artifacts[0]; 
                const option = document.createElement('option');
                option.value = JSON.stringify({ run_id: run.run_id, artifact_path: artifact });
                option.textContent = `${run.run_name} (${artifact})`;
                runSelect.appendChild(option);
            });
        }
    }

    experimentSelect.addEventListener('change', () => {
        populateRunSelect(experimentSelect.value);
    });

    loadModelBtn.addEventListener('click', async () => {
        const selectedRunData = JSON.parse(runSelect.value);
        if (!selectedRunData) {
            alert('Please select a run first.');
            return;
        }

        modelStatus.textContent = `Status: Loading model "${selectedRunData.artifact_path}"...`;
        loadModelBtn.disabled = true;

        try {
            const response = await fetch('/load-model', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(selectedRunData),
            });

            const result = await response.json();
            if (!response.ok) throw new Error(result.detail || 'Failed to load model');

            modelStatus.textContent = `Status: Model "${selectedRunData.artifact_path}" loaded successfully.`;

        } catch (error) {
            console.error('Error loading model:', error);
            modelStatus.textContent = `Error: ${error.message}`;
        } finally {
            loadModelBtn.disabled = false;
        }
    });

    // --- Image Inference ---
    uploadImageBtn.addEventListener('click', async () => {
        const file = imageUpload.files[0];
        if (!file) {
            alert('Please select an image file first.');
            return;
        }

        const formData = new FormData();
        formData.append('file', file);

        try {
            const response = await fetch('/infer', {
                method: 'POST',
                body: formData,
            });

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            const result = await response.json();
            displayImageWithDetections(file, result.detections);

        } catch (error) {
            console.error('Error uploading image:', error);
            imageResult.innerHTML = `<p>Error during inference. See console for details.</p>`;
        }
    });

    function displayImageWithDetections(file, detections) {
        const reader = new FileReader();
        reader.onload = (e) => {
            const img = new Image();
            img.onload = () => {
                const canvas = document.createElement('canvas');
                const ctx = canvas.getContext('2d');
                canvas.width = img.width;
                canvas.height = img.height;
                ctx.drawImage(img, 0, 0);

                // Draw detections
                ctx.strokeStyle = 'red';
                ctx.lineWidth = 2;
                ctx.font = '16px sans-serif';
                ctx.fillStyle = 'red';

                detections.forEach(det => {
                    const [x1, y1, x2, y2] = det.bbox;
                    const label = det.label;
                    ctx.strokeRect(x1, y1, x2 - x1, y2 - y1);
                    ctx.fillText(label, x1, y1 > 20 ? y1 - 5 : y1 + 20);
                });

                imageResult.innerHTML = '';
                imageResult.appendChild(canvas);
            };
            img.src = e.target.result;
        };
        reader.readAsDataURL(file);
    }

    // --- Video Inference ---
    startVideoBtn.addEventListener('click', () => {
        videoStatus.textContent = 'Connecting to video stream...';
        startVideoBtn.disabled = true;
        stopVideoBtn.disabled = false;

        eventSource = new EventSource('/video-stream');

        eventSource.onopen = () => {
            videoStatus.textContent = 'Video stream started.';
        };

        eventSource.onerror = (err) => {
            console.error("EventSource failed:", err);
            videoStatus.textContent = 'Error with video stream. See console for details.';
            eventSource.close();
            startVideoBtn.disabled = false;
            stopVideoBtn.disabled = true;
        };

        eventSource.onmessage = (event) => {
            const data = JSON.parse(event.data);
            const img = new Image();
            img.onload = () => {
                // Adjust canvas size to match the incoming frame
                if (videoCanvas.width !== img.width || videoCanvas.height !== img.height) {
                    videoCanvas.width = img.width;
                    videoCanvas.height = img.height;
                }
                
                ctx.drawImage(img, 0, 0);

                // Draw detections
                ctx.lineWidth = 2;
                ctx.font = '14px sans-serif';

                data.detections.forEach(det => {
                    const [x1, y1, x2, y2] = det.bbox;
                    const label = `${det.label} #${det.track_id}`;
                    
                    // Simple color hashing for tracks
                    const color = `hsl(${det.track_id * 40 % 360}, 100%, 50%)`;
                    ctx.strokeStyle = color;
                    ctx.fillStyle = color;

                    ctx.strokeRect(x1, y1, x2 - x1, y2 - y1);
                    ctx.fillText(label, x1, y1 > 15 ? y1 - 5 : y1 + 15);
                });
            };
            img.src = `data:image/jpeg;base64,${data.image_b64}`;
        };
    });

    stopVideoBtn.addEventListener('click', () => {
        if (eventSource) {
            eventSource.close();
            videoStatus.textContent = 'Stream stopped by user.';
            startVideoBtn.disabled = false;
            stopVideoBtn.disabled = true;
        }
    });

    // Initialisation
    fetchExperiments();
}); 