-- 04_gold_marts.sql
-- Aggregated marts for reporting and serving to downstream apps

CREATE OR REPLACE TABLE gold.patient_profile AS
SELECT p.*, COUNT(e.patient_id) AS event_count
FROM silver.patients p
LEFT JOIN silver.patient_events e USING (patient_id)
GROUP BY p.patient_id, p.first_name, p.last_name, p.email, p.phone, p.dob;
