import csv
from pathlib import Path
from datetime import datetime, timedelta

DATA_DIR = Path(__file__).resolve().parents[1] / "data" / "sample"
PATIENTS_CSV = DATA_DIR / "patients.csv"
UPDATES_CSV = DATA_DIR / "daily_updates.csv"


def simulate_updates(days=7):
    DATA_DIR.mkdir(parents=True, exist_ok=True)
    if not PATIENTS_CSV.exists():
        print(f"No patients file at {PATIENTS_CSV}. Run generate_data.py first.")
        return
    with open(PATIENTS_CSV) as f:
        reader = list(csv.DictReader(f))
    start = datetime.utcnow()
    updates = []
    for d in range(days):
        day = start + timedelta(days=d)
        for p in reader[:5]:  # sample subset per day
            updates.append({
                "patient_id": p["patient_id"],
                "event_time": day.isoformat(),
                "note": f"Simulated touchpoint for patient {p['patient_id']} on {day.date()}"
            })
    with open(UPDATES_CSV, "w") as f:
        writer = csv.DictWriter(f, fieldnames=["patient_id", "event_time", "note"])
        writer.writeheader()
        writer.writerows(updates)
    print(f"Wrote {len(updates)} updates to {UPDATES_CSV}")

if __name__ == '__main__':
    simulate_updates(14)
