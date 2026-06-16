USE WAREHOUSE MEDSYNC_WH;
USE DATABASE MEDSYNC_AI;

CREATE OR REPLACE TABLE SILVER.CLEAN_PATIENTS AS
SELECT
    patient_id,
    INITCAP(first_name) AS first_name,
    INITCAP(last_name) AS last_name,
    age,
    UPPER(gender) AS gender,
    INITCAP(city) AS city,
    UPPER(state) AS state,
    latitude,
    longitude,
    phone_number
FROM BRONZE.RAW_PATIENTS
WHERE patient_id IS NOT NULL
  AND age BETWEEN 18 AND 100
  AND latitude IS NOT NULL
  AND longitude IS NOT NULL;

CREATE OR REPLACE TABLE SILVER.CLEAN_MEDICATIONS AS
SELECT
    medication_id,
    INITCAP(medicine_name) AS medicine_name,
    drug_class,
    tablet_strength
FROM BRONZE.RAW_MEDICATIONS
WHERE medication_id IS NOT NULL;

CREATE OR REPLACE TABLE SILVER.CLEAN_PRESCRIPTIONS AS
SELECT
    prescription_id,
    patient_id,
    medication_id,
    start_date,
    end_date,
    dose_per_intake,
    intakes_per_day,
    total_tablets,
    current_tablets,
    current_tablets / NULLIF(dose_per_intake * intakes_per_day, 0) AS days_remaining
FROM BRONZE.RAW_PRESCRIPTIONS
WHERE prescription_id IS NOT NULL
  AND current_tablets >= 0
  AND dose_per_intake > 0
  AND intakes_per_day > 0;

CREATE OR REPLACE TABLE SILVER.CLEAN_MEDICATION_LOGS AS
SELECT
    log_id,
    prescription_id,
    scheduled_time,
    INITCAP(status) AS status,
    response_time
FROM BRONZE.RAW_MEDICATION_LOGS
WHERE log_id IS NOT NULL
  AND status IN ('Taken', 'Missed', 'Skipped', 'Snoozed');

CREATE OR REPLACE TABLE SILVER.CLEAN_PHARMACIES AS
SELECT
    pharmacy_id,
    pharmacy_name,
    INITCAP(city) AS city,
    UPPER(state) AS state,
    latitude,
    longitude
FROM BRONZE.RAW_PHARMACIES
WHERE pharmacy_id IS NOT NULL
  AND latitude IS NOT NULL
  AND longitude IS NOT NULL;

CREATE OR REPLACE TABLE SILVER.CLEAN_PHARMACY_INVENTORY AS
SELECT
    inventory_id,
    pharmacy_id,
    medication_id,
    stock_quantity,
    price,
    last_updated
FROM BRONZE.RAW_PHARMACY_INVENTORY
WHERE inventory_id IS NOT NULL
  AND stock_quantity >= 0
  AND price >= 0;


