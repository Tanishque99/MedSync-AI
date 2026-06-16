import random
from datetime import datetime, timedelta
from pathlib import Path

import pandas as pd

DATA_DIR = Path("data/sample")
random.seed(123)

prescriptions = pd.read_csv(DATA_DIR / "prescriptions.csv")
logs = pd.read_csv(DATA_DIR / "medication_logs.csv")

today = datetime.today().date() + timedelta(days=1)
new_logs = []

for _, row in prescriptions.sample(100).iterrows():
    intakes_per_day = int(row["intakes_per_day"])
    reminder_hours = [8] if intakes_per_day == 1 else [8, 20] if intakes_per_day == 2 else [8, 14, 20]

    for hour in reminder_hours:
        scheduled_time = datetime.combine(today, datetime.min.time()) + timedelta(hours=hour)
        status = random.choices(
            ["Taken", "Missed", "Skipped", "Snoozed"],
            weights=[0.78, 0.12, 0.06, 0.04]
        )[0]

        response_time = ""
        if status in ["Taken", "Snoozed"]:
            response_time = scheduled_time + timedelta(minutes=random.randint(1, 90))

        new_logs.append({
            "log_id": f"L{len(logs) + len(new_logs) + 1:07d}",
            "prescription_id": row["prescription_id"],
            "scheduled_time": scheduled_time,
            "status": status,
            "response_time": response_time
        })

updated_logs = pd.concat([logs, pd.DataFrame(new_logs)], ignore_index=True)
updated_logs.to_csv(DATA_DIR / "medication_logs.csv", index=False)

print(f"Added {len(new_logs)} new medication log records.")