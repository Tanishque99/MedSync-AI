# Architecture

This project demonstrates a simple ELT flow for MedSync data using Snowflake:

- Bronze: raw ingested CSVs
- Silver: curated normalized tables
- Gold: aggregated marts and reminder queue

A downstream service or Streamlit app can read from `gold.reminder_queue` to send reminders.
