USE WAREHOUSE MEDSYNC_WH;
USE DATABASE MEDSYNC_AI;

CREATE OR REPLACE TABLE GOLD.MART_PATIENT_ADHERENCE AS
SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    pr.prescription_id,
    m.medicine_name,
    m.drug_class,
    COUNT(l.log_id) AS total_scheduled_doses,
    COUNT_IF(l.status = 'Taken') AS doses_taken,
    COUNT_IF(l.status = 'Missed') AS doses_missed,
    COUNT_IF(l.status = 'Skipped') AS doses_skipped,
    COUNT_IF(l.status = 'Snoozed') AS doses_snoozed,
    ROUND(COUNT_IF(l.status = 'Taken') / NULLIF(COUNT(l.log_id), 0), 4) AS adherence_rate,
    CASE
        WHEN ROUND(COUNT_IF(l.status = 'Taken') / NULLIF(COUNT(l.log_id), 0), 4) >= 0.90 THEN 'Good'
        WHEN ROUND(COUNT_IF(l.status = 'Taken') / NULLIF(COUNT(l.log_id), 0), 4) >= 0.75 THEN 'Moderate'
        ELSE 'High Risk'
    END AS adherence_risk
FROM SILVER.CLEAN_PATIENTS p
JOIN SILVER.CLEAN_PRESCRIPTIONS pr
    ON p.patient_id = pr.patient_id
JOIN SILVER.CLEAN_MEDICATIONS m
    ON pr.medication_id = m.medication_id
LEFT JOIN SILVER.CLEAN_MEDICATION_LOGS l
    ON pr.prescription_id = l.prescription_id
GROUP BY
    p.patient_id,
    p.first_name,
    p.last_name,
    pr.prescription_id,
    m.medicine_name,
    m.drug_class;


-- Adding for refill
CREATE OR REPLACE TABLE GOLD.MART_REFILL_PREDICTION AS
SELECT
    pr.prescription_id,
    pr.patient_id,
    p.first_name,
    p.last_name,
    pr.medication_id,
    m.medicine_name,
    pr.current_tablets,
    pr.dose_per_intake,
    pr.intakes_per_day,
    ROUND(pr.current_tablets / NULLIF(pr.dose_per_intake * pr.intakes_per_day, 0), 2) AS days_remaining,
    DATEADD(
        DAY,
        FLOOR(pr.current_tablets / NULLIF(pr.dose_per_intake * pr.intakes_per_day, 0)),
        CURRENT_DATE()
    ) AS estimated_runout_date,
    CASE
        WHEN pr.current_tablets / NULLIF(pr.dose_per_intake * pr.intakes_per_day, 0) <= 2 THEN 'Urgent Refill'
        WHEN pr.current_tablets / NULLIF(pr.dose_per_intake * pr.intakes_per_day, 0) <= 7 THEN 'Refill Soon'
        ELSE 'Sufficient Stock'
    END AS refill_status
FROM SILVER.CLEAN_PRESCRIPTIONS pr
JOIN SILVER.CLEAN_PATIENTS p
    ON pr.patient_id = p.patient_id
JOIN SILVER.CLEAN_MEDICATIONS m
    ON pr.medication_id = m.medication_id;


-- Nearest Pharmacy recommendations
CREATE OR REPLACE TABLE GOLD.MART_NEAREST_REFILL_OPTIONS AS
WITH refill_needed AS (
    SELECT
        prescription_id,
        patient_id,
        medication_id,
        medicine_name,
        refill_status,
        days_remaining
    FROM GOLD.MART_REFILL_PREDICTION
    WHERE refill_status IN ('Urgent Refill', 'Refill Soon')
),

pharmacy_matches AS (
    SELECT
        rn.prescription_id,
        rn.patient_id,
        rn.medication_id,
        rn.medicine_name,
        rn.refill_status,
        rn.days_remaining,
        ph.pharmacy_id,
        ph.pharmacy_name,
        inv.stock_quantity,
        inv.price,
        ROUND(
            ST_DISTANCE(
                ST_MAKEPOINT(p.longitude, p.latitude),
                ST_MAKEPOINT(ph.longitude, ph.latitude)
            ) / 1609.34,
            2
        ) AS distance_miles
    FROM refill_needed rn
    JOIN SILVER.CLEAN_PATIENTS p
        ON rn.patient_id = p.patient_id
    JOIN SILVER.CLEAN_PHARMACY_INVENTORY inv
        ON rn.medication_id = inv.medication_id
    JOIN SILVER.CLEAN_PHARMACIES ph
        ON inv.pharmacy_id = ph.pharmacy_id
    WHERE inv.stock_quantity > 0
)

SELECT *
FROM pharmacy_matches
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY prescription_id
    ORDER BY distance_miles ASC, price ASC
) = 1;