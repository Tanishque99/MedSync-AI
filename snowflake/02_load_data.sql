-- 02_load_data.sql
-- Example commands to load staged CSV data into bronze tables

-- put file://... @%staging
-- copy into bronze.patients_raw from @my_stage/patients.csv file_format=(type='csv' skip_header=1);
-- copy into bronze.daily_updates_raw from @my_stage/daily_updates.csv file_format=(type='csv' skip_header=1);
