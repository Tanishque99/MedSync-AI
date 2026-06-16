# MedSync AI — Snowflake Medication Reminder & Refill Intelligence Platform

## Problem
Medication non-adherence and delayed refills can lead to poor patient outcomes. Patients may forget doses or realize too late that tablets are running out.

## Solution
MedSync AI is a Snowflake-powered data engineering project that simulates medication reminders, tracks adherence, predicts refill needs, and recommends the nearest pharmacy with available inventory.

## Key Features
- Synthetic patient, prescription, medication, intake log, and pharmacy inventory data
- Snowflake Bronze/Silver/Gold architecture
- Medication reminder queue
- Adherence risk scoring
- Refill date prediction
- Nearest pharmacy recommendation using geospatial SQL
- Streamlit dashboard
- Optional Snowflake Cortex message generation

## Free Implementation Strategy
- No real patient data
- No SMS API
- No paid pharmacy API
- No paid cloud storage
- Snowflake free trial only
- Local Streamlit dashboard

## Architecture
Add diagram here.

## Data Model
Explain all source tables and mart tables.

## Demo Screenshots
Add dashboard screenshots.

## Future Improvements
- Twilio SMS integration
- Real pharmacy API integration
- dbt transformations
- Snowpipe ingestion
- Snowflake Cortex AI message personalization
- HIPAA-ready consent and audit workflows