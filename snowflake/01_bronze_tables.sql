-- 01_bronze_tables.sql
-- Bronze raw tables for ingested CSVs or staged data

CREATE OR REPLACE TABLE bronze.patients_raw (
    patient_id INTEGER,
    first_name STRING,
    last_name STRING,
    email STRING,
    phone STRING,
    dob DATE,
    _ingest_time TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE bronze.daily_updates_raw (
    patient_id INTEGER,
    event_time TIMESTAMP_TZ,
    note STRING,
    _ingest_time TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);
