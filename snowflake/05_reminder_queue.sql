USE WAREHOUSE MEDSYNC_WH;
USE DATABASE MEDSYNC_AI;

CREATE OR REPLACE TABLE GOLD.MART_MEDICATION_REMINDER_QUEUE AS
SELECT
    l.log_id,
    pr.patient_id,
    p.first_name,
    p.last_name,
    pr.prescription_id,
    m.medicine_name,
    l.scheduled_time,
    l.status,
    CASE
        WHEN l.status = 'Missed' THEN 'Escalation Reminder'
        WHEN l.status = 'Snoozed' THEN 'Snooze Reminder'
        ELSE 'Standard Reminder'
    END AS reminder_type,
    CASE
        WHEN l.status = 'Missed'
            THEN 'Hi ' || p.first_name || ', you missed your scheduled dose of ' || m.medicine_name || '. Please take it if advised by your doctor.'
        WHEN l.status = 'Snoozed'
            THEN 'Hi ' || p.first_name || ', this is your snoozed reminder for ' || m.medicine_name || '.'
        ELSE 'Hi ' || p.first_name || ', it is time to take your scheduled medicine: ' || m.medicine_name || '.'
    END AS reminder_message
FROM SILVER.CLEAN_MEDICATION_LOGS l
JOIN SILVER.CLEAN_PRESCRIPTIONS pr
    ON l.prescription_id = pr.prescription_id
JOIN SILVER.CLEAN_PATIENTS p
    ON pr.patient_id = p.patient_id
JOIN SILVER.CLEAN_MEDICATIONS m
    ON pr.medication_id = m.medication_id
WHERE l.status IN ('Missed', 'Snoozed');


-- select * from gold.mart_medication_reminder_queue

--- Refill message table
CREATE OR REPLACE TABLE GOLD.MART_REFILL_MESSAGES AS
SELECT
    n.prescription_id,
    n.patient_id,
    n.medicine_name,
    n.refill_status,
    n.days_remaining,
    n.pharmacy_name,
    n.distance_miles,
    n.price,
    'Hi! Your ' || n.medicine_name || ' supply is running low. ' ||
    n.pharmacy_name || ' has it in stock about ' ||
    n.distance_miles || ' miles away, estimated price $' ||
    n.price || '. Please refill soon or contact your provider if you need help.' AS refill_message
FROM GOLD.MART_NEAREST_REFILL_OPTIONS n;