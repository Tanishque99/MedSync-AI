# Data Model

- `bronze.patients_raw` — raw patient CSV columns
- `bronze.daily_updates_raw` — raw event CSV columns
- `silver.patients` — cleaned patient records
- `silver.patient_events` — event timeline
- `gold.patient_profile` — profile mart with aggregates
- `gold.reminder_queue` — messages queued for delivery
