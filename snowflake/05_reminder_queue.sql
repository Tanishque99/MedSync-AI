-- 05_reminder_queue.sql
-- Queue for reminder messages to be sent by downstream service or AI

CREATE OR REPLACE TABLE gold.reminder_queue (
  queue_id STRING,
  patient_id INTEGER,
  scheduled_time TIMESTAMP_LTZ,
  message STRING,
  status STRING DEFAULT 'pending',
  created_at TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Example: Insert into queue based on patient rules
-- INSERT INTO gold.reminder_queue (queue_id, patient_id, scheduled_time, message)
-- SELECT UUID_STRING(), patient_id, DATEADD(day, 1, CURRENT_TIMESTAMP()), 'Reminder: medication refill' FROM gold.patient_profile WHERE event_count > 0;
