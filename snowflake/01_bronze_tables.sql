USE WAREHOUSE MEDSYNC_WH;
USE DATABASE MEDSYNC_AI;

CREATE OR REPLACE TABLE BRONZE.RAW_PATIENTS (
    patient_id STRING,
    first_name STRING,
    last_name STRING,
    age INTEGER,
    gender STRING,
    city STRING,
    state STRING,
    latitude FLOAT,
    longitude FLOAT,
    phone_number STRING,
    load_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE BRONZE.RAW_MEDICATIONS (
    medication_id STRING,
    medicine_name STRING,
    drug_class STRING,
    tablet_strength STRING,
    load_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE BRONZE.RAW_PRESCRIPTIONS (
    prescription_id STRING,
    patient_id STRING,
    medication_id STRING,
    start_date DATE,
    end_date DATE,
    dose_per_intake INTEGER,
    intakes_per_day INTEGER,
    total_tablets INTEGER,
    current_tablets INTEGER,
    load_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE BRONZE.RAW_MEDICATION_LOGS (
    log_id STRING,
    prescription_id STRING,
    scheduled_time TIMESTAMP,
    status STRING,
    response_time TIMESTAMP,
    load_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE BRONZE.RAW_PHARMACIES (
    pharmacy_id STRING,
    pharmacy_name STRING,
    city STRING,
    state STRING,
    latitude FLOAT,
    longitude FLOAT,
    load_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE BRONZE.RAW_PHARMACY_INVENTORY (
    inventory_id STRING,
    pharmacy_id STRING,
    medication_id STRING,
    stock_quantity INTEGER,
    price FLOAT,
    last_updated DATE,
    load_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);
