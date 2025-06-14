from pathlib import Path
from typing import List, Dict, Any
import json


FEEDBACK_STORE = Path("feedback")
FEEDBACK_STORE.mkdir(exist_ok=True)


def save_feedback(sample: Dict[str, Any]) -> None:
    """Append a single feedback JSON object to disk."""
    all_fb: List[Dict[str, Any]] = []
    file_path = FEEDBACK_STORE / "feedback.jsonl"

    if file_path.exists():
        with file_path.open("r", encoding="utf-8") as fp:
            all_fb = [json.loads(line) for line in fp]

    all_fb.append(sample)
    with file_path.open("w", encoding="utf-8") as fp:
        for rec in all_fb:
            fp.write(json.dumps(rec) + "\n")


def retrain_model(feedback_path: Path = FEEDBACK_STORE / "feedback.jsonl"):
    """Just a placeholder"""
    if not feedback_path.exists():
        print("No feedback yet; skipping retraining.")
        return
    print("Done! Replace with actual training code.")