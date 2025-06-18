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

    let all_events = [];

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
        } finally {
            loadModelBtn.disabled = false;
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

    // --- Video Inference ---
    function updateStatus(statusData) {
        const { active_objects, events } = statusData;
        let statusHTML = '<h3>Real-time Status</h3>';

        // Display recent events
        if (events && events.length > 0) {
            statusHTML += '<h4>Recent Events:</h4><ul class="events-list">';
            // Show latest 5 events
            events.slice(-5).reverse().forEach(e => {
                let eventText = `(${new Date().toLocaleTimeString()}) #${e.track_id}: ${e.event}`;
                if (e.to_zone) eventText += ` -> ${e.to_zone}`;
                if (e.from_zone) eventText += ` (from ${e.from_zone})`;
                if (e.dwell_time) eventText += ` after ${e.dwell_time}s`;
                all_events.push(eventText);
                statusHTML += `<li>${eventText}</li>`;
            });
            statusHTML += '</ul>';
        }
        statusHTML += `<ul class="events-list"><li>${all_events.join('</li><li>')}</li></ul>`;

        // Display active objects and their dwell times
        if (active_objects && Object.keys(active_objects).length > 0) {
            statusHTML += '<h4>Active Objects in Zones:</h4><ul class="active-objects-list">';
            for (const [trackId, data] of Object.entries(active_objects)) {
                statusHTML += `<li>Track ${trackId}: In <strong>${data.zone}</strong> for ${data.dwell_time}s</li>`;
            }
            statusHTML += '</ul>';
        } else {
            statusHTML += '<p>No objects currently tracked in zones.</p>';
        }

        videoStatus.innerHTML = statusHTML;
    }

    startVideoBtn.addEventListener('click', () => {
        videoStatus.innerHTML = '<h3>Connecting to video stream...</h3>';
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

        eventSource.addEventListener('message', (event) => {
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

                if (data.detections) {
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
                }
                
                // Update the status display with active objects and events
                updateStatus(data);
            };
            img.src = `data:image/jpeg;base64,${data.image_b64}`;
        });
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