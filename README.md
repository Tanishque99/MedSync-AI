# MedSync AI — Snowflake Medication Reminder & Refill PoC

Lightweight proof-of-concept scaffold demonstrating a Snowflake bronze→silver→gold ELT pattern, simple synthetic data generation, and a tiny Streamlit UI for local validation.

Contents
- `data/sample/` — generated sample CSVs (`patients.csv`, `daily_updates.csv`)
- `src/` — Python scripts to generate and simulate sample data
- `snowflake/` — SQL templates for Bronze/Silver/Gold layers and reminder queue
- `streamlit_app/` — minimal Streamlit demo
- `docs/` — architecture and data model notes

Quickstart

1. Install dependencies (recommended in a virtualenv):

```bash
python -m pip install -r requirements.txt
```

2. Generate sample patients:

```bash
python src/generate_data.py
```

This writes `data/sample/patients.csv` (default 50 patients). To change the count, edit the script or call `generate_patient(n)`.

3. Simulate daily updates / events:

```bash
python src/simulate_daily_updates.py
```

This writes `data/sample/daily_updates.csv` containing simulated touchpoints.

4. Run the Streamlit demo locally:

```bash
streamlit run streamlit_app/app.py
```

Snowflake

This repo includes SQL templates to create the database layers and example tables. They are intentionally minimal — adapt to your Snowflake account and run via worksheet or CI:

- `snowflake/00_setup.sql` — environment / schema notes
- `snowflake/01_bronze_tables.sql` — raw ingest tables
- `snowflake/02_load_data.sql` — example COPY commands (staging required)
- `snowflake/03_silver_tables.sql` — curated tables
- `snowflake/04_gold_marts.sql` — aggregated marts
- `snowflake/05_reminder_queue.sql` — reminder queue table
- `snowflake/06_optional_ai_messages.sql` — optional AI templates table

Files and purpose

- `src/generate_data.py` — produces `patients.csv` using `Faker` and `pandas`.
- `src/simulate_daily_updates.py` — creates `daily_updates.csv` with event_time and notes.
- `streamlit_app/app.py` — small Streamlit app that lists sample files and acts as a placeholder UI.

Demo Screenshots

The original README included a set of dashboard screenshots. They are preserved below — add or replace the image files in the repo (image.png, image-1.png, ... ) to show the app visuals.

- Front page / headline
	![alt text](image.png)
	<small><em>Example home screen for the Streamlit dashboard (placeholder).</em></small>

- Refill status distribution
	![alt text](image-1.png)
	<small><em>Distribution of refill statuses across patients.</em></small>

- Adherence distribution
	![alt text](image-2.png)
	<small><em>Histogram showing adherence scores.</em></small>

- Patient adherence details
	![alt text](image-3.png) ![alt text](image-4.png)
	<small><em>Patient-level adherence timeline and details.</em></small>

- Medication reminder queue
	![alt text](image-5.png) ![alt text](image-6.png)
	<small><em>Example reminder queue view and status columns.</em></small>

- Refill recommendations
	![alt text](image-7.png) ![alt text](image-8.png)
	<small><em>Candidate refill recommendations and nearby pharmacies.</em></small>

- Refill message examples
	![alt text](image-9.png) ![alt text](image-10.png)
	<small><em>AI-generated or templated reminder messages stored in the queue.</em></small>

- High-risk patients
	![alt text](image-11.png) ![alt text](image-12.png)
	<small><em>Patients flagged for follow-up due to adherence risk.</em></small>

Notes & Next Steps

- This is a scaffold for experimentation — production deployments require secure credential handling, proper ingestion (Snowpipe/Stream), and compliance reviews before using real PHI.
- If you want, I can: run the sample data generation in this workspace, add a `Makefile` or `run.sh` for convenience, or create a `README` badge with quick run commands.

Future Improvements
- Twilio SMS integration
- Real pharmacy API integration
- dbt transformations
- Snowpipe ingestion
- Snowflake Cortex AI message personalization
- HIPAA-ready consent and audit workflows