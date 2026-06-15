import random
from pathlib import Path
from datetime import datetime, timedelta

import pandas as pd
from faker import Faker

fake = Faker()
random.seed(42)

# This writes to project_root/data/sample even when script is inside src/
PROJECT_ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = PROJECT_ROOT / "data" / "sample"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

medications = [
    ("M001", "Metformin", "Diabetes", "500mg"),
    ("M002", "Lisinopril", "Blood Pressure", "10mg"),
    ("M003", "Atorvastatin", "Cholesterol", "20mg"),
    ("M004", "Amlodipine", "Blood Pressure", "5mg"),
    ("M005", "Levothyroxine", "Thyroid", "50mcg"),
    ("M006", "Omeprazole", "Acid Reflux", "20mg"),
]

locations = [
    ("Phoenix", 33.4484, -112.0740),
    ("Tempe", 33.4255, -111.9400),
    ("Mesa", 33.4152, -111.8315),
    ("Scottsdale", 33.4942, -111.9261),
    ("Chandler", 33.3062, -111.8413),
]

# -----------------------------
# Patients
# -----------------------------
patients = []

for i in range(1, 501):
    city, lat, lon = random.choice(locations)

    patients.append({
        "patient_id": f"P{i:04d}",
        "first_name": fake.first_name(),
        "last_name": fake.last_name(),
        "age": random.randint(18, 90),
        "gender": random.choice(["M", "F"]),
        "city": city,
        "state": "AZ",
        "latitude": round(lat + random.uniform(-0.04, 0.04), 6),
        "longitude": round(lon + random.uniform(-0.04, 0.04), 6),
        "phone_number": fake.phone_number()
    })

# -----------------------------
# Pharmacies
# -----------------------------
pharmacy_names = [
    "CVS Pharmacy",
    "Walgreens",
    "Walmart Pharmacy",
    "Costco Pharmacy",
    "Safeway Pharmacy"
]

pharmacies = []

for i in range(1, 31):
    city, lat, lon = random.choice(locations)

    pharmacies.append({
        "pharmacy_id": f"PH{i:03d}",
        "pharmacy_name": f"{random.choice(pharmacy_names)} #{i}",
        "city": city,
        "state": "AZ",
        "latitude": round(lat + random.uniform(-0.06, 0.06), 6),
        "longitude": round(lon + random.uniform(-0.06, 0.06), 6)
    })

# -----------------------------
# Prescriptions and logs
# -----------------------------
prescriptions = []
logs = []

today = datetime.today().date()

for i in range(1, 901):
    patient = random.choice(patients)
    medication = random.choice(medications)

    dose_per_intake = 1
    intakes_per_day = random.choice([1, 2, 3])
    total_tablets = random.choice([30, 60, 90])
    current_tablets = random.randint(0, total_tablets)

    prescription_id = f"RX{i:05d}"

    prescriptions.append({
        "prescription_id": prescription_id,
        "patient_id": patient["patient_id"],
        "medication_id": medication[0],
        "start_date": today - timedelta(days=random.randint(1, 60)),
        "end_date": today + timedelta(days=random.randint(30, 120)),
        "dose_per_intake": dose_per_intake,
        "intakes_per_day": intakes_per_day,
        "total_tablets": total_tablets,
        "current_tablets": current_tablets
    })

    if intakes_per_day == 1:
        reminder_hours = [8]
    elif intakes_per_day == 2:
        reminder_hours = [8, 20]
    else:
        reminder_hours = [8, 14, 20]

    for day_offset in range(-14, 1):
        for hour in reminder_hours:
            scheduled_time = (
                datetime.combine(today + timedelta(days=day_offset), datetime.min.time())
                + timedelta(hours=hour)
            )

            status = random.choices(
                ["Taken", "Missed", "Skipped", "Snoozed"],
                weights=[0.78, 0.12, 0.06, 0.04]
            )[0]

            response_time = ""
            if status in ["Taken", "Snoozed"]:
                response_time = scheduled_time + timedelta(minutes=random.randint(1, 90))

            logs.append({
                "log_id": f"L{len(logs) + 1:07d}",
                "prescription_id": prescription_id,
                "scheduled_time": scheduled_time,
                "status": status,
                "response_time": response_time
            })

# -----------------------------
# Pharmacy inventory
# -----------------------------
inventory = []

for pharmacy in pharmacies:
    for medication in medications:
        inventory.append({
            "inventory_id": f"I{len(inventory) + 1:06d}",
            "pharmacy_id": pharmacy["pharmacy_id"],
            "medication_id": medication[0],
            "stock_quantity": random.randint(0, 250),
            "price": round(random.uniform(4.99, 49.99), 2),
            "last_updated": today
        })

# -----------------------------
# Write CSVs
# -----------------------------
files = {
    "patients.csv": pd.DataFrame(patients),
    "medications.csv": pd.DataFrame(
        medications,
        columns=["medication_id", "medicine_name", "drug_class", "tablet_strength"]
    ),
    "prescriptions.csv": pd.DataFrame(prescriptions),
    "medication_logs.csv": pd.DataFrame(logs),
    "pharmacies.csv": pd.DataFrame(pharmacies),
    "pharmacy_inventory.csv": pd.DataFrame(inventory),
}

for file_name, df in files.items():
    output_path = OUTPUT_DIR / file_name
    df.to_csv(output_path, index=False)
    print(f"Wrote {len(df)} rows to {output_path}")

print("\nSynthetic MedSync AI data generated successfully.")