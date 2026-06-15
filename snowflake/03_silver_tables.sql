-- 03_silver_tables.sql
-- Transformations to clean and normalize bronze data into silver curated tables

CREATE OR REPLACE TABLE silver.patients AS
SELECT
  patient_id,
  first_name,
  last_name,
  email,
  phone,
  TO_DATE(dob) AS dob
FROM bronze.patients_raw;

CREATE OR REPLACE TABLE silver.patient_events AS
SELECT
  patient_id,
  TO_TIMESTAMP_TZ(event_time) AS event_time,
  note
FROM bronze.daily_updates_raw;
