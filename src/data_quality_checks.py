import pandas as pd
from pathlib import Path

DATA_DIR = Path("data/sample")

checks = {
    "patients.csv": ["patient_id", "latitude", "longitude"],
    "medications.csv": ["medication_id", "medicine_name"],
    "prescriptions.csv": ["prescription_id", "patient_id", "medication_id"],
    "medication_logs.csv": ["log_id", "prescription_id", "status"],
    "pharmacies.csv": ["pharmacy_id", "latitude", "longitude"],
    "pharmacy_inventory.csv": ["inventory_id", "pharmacy_id", "medication_id"],
}

for file_name, required_columns in checks.items():
    path = DATA_DIR / file_name
    df = pd.read_csv(path)

    missing_columns = [col for col in required_columns if col not in df.columns]
    null_counts = df[required_columns].isnull().sum().sum() if not missing_columns else None

    print(f"\n{file_name}")
    print(f"Rows: {len(df)}")
    print(f"Missing columns: {missing_columns}")
    print(f"Nulls in required columns: {null_counts}")