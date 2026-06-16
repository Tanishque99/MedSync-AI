USE WAREHOUSE MEDSYNC_WH;
USE DATABASE MEDSYNC_AI;

TRUNCATE TABLE BRONZE.RAW_PATIENTS;
TRUNCATE TABLE BRONZE.RAW_MEDICATIONS;
TRUNCATE TABLE BRONZE.RAW_PRESCRIPTIONS;
TRUNCATE TABLE BRONZE.RAW_MEDICATION_LOGS;
TRUNCATE TABLE BRONZE.RAW_PHARMACIES;
TRUNCATE TABLE BRONZE.RAW_PHARMACY_INVENTORY;

COPY INTO BRONZE.RAW_PATIENTS (
    patient_id,
    first_name,
    last_name,
    age,
    gender,
    city,
    state,
    latitude,
    longitude,
    phone_number
)
FROM @OPS.MEDSYNC_STAGE
FILE_FORMAT = OPS.CSV_FORMAT
FILES = ('patients.csv');

COPY INTO BRONZE.RAW_MEDICATIONS (
    medication_id,
    medicine_name,
    drug_class,
    tablet_strength
)
FROM @OPS.MEDSYNC_STAGE
FILE_FORMAT = OPS.CSV_FORMAT
FILES = ('medications.csv');

COPY INTO BRONZE.RAW_PRESCRIPTIONS (
    prescription_id,
    patient_id,
    medication_id,
    start_date,
    end_date,
    dose_per_intake,
    intakes_per_day,
    total_tablets,
    current_tablets
)
FROM @OPS.MEDSYNC_STAGE
FILE_FORMAT = OPS.CSV_FORMAT
FILES = ('prescriptions.csv');

COPY INTO BRONZE.RAW_MEDICATION_LOGS (
    log_id,
    prescription_id,
    scheduled_time,
    status,
    response_time
)
FROM @OPS.MEDSYNC_STAGE
FILE_FORMAT = OPS.CSV_FORMAT
FILES = ('medication_logs.csv');

COPY INTO BRONZE.RAW_PHARMACIES (
    pharmacy_id,
    pharmacy_name,
    city,
    state,
    latitude,
    longitude
)
FROM @OPS.MEDSYNC_STAGE
FILE_FORMAT = OPS.CSV_FORMAT
FILES = ('pharmacies.csv');

COPY INTO BRONZE.RAW_PHARMACY_INVENTORY (
    inventory_id,
    pharmacy_id,
    medication_id,
    stock_quantity,
    price,
    last_updated
)
FROM @OPS.MEDSYNC_STAGE
FILE_FORMAT = OPS.CSV_FORMAT
FILES = ('pharmacy_inventory.csv');


