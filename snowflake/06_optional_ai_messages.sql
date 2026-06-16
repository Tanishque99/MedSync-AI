
--****** Since the Cortex AI cannot be used in free versions we cannot run the below code to send AI message. Instead we can use SQL query as below shown uncommented.

-- USE ROLE ACCOUNTADMIN;
-- GRANT DATABASE ROLE SNOWFLAKE.CORTEX_USER TO USER TANISHQUE;

-- USE DATABASE MEDSYNC_AI;

-- CREATE OR REPLACE TABLE AI.AI_REFILL_MESSAGES_SAMPLE AS
-- SELECT
--     prescription_id,
--     patient_id,
--     SNOWFLAKE.CORTEX.AI_COMPLETE(
--         'mistral-large',
--         'Write a short, privacy-conscious medication refill reminder. Do not include sensitive medical details. Context: medicine running low, pharmacy nearby.'
--     ) AS ai_message
-- FROM GOLD.MART_NEAREST_REFILL_OPTIONS
-- LIMIT 5;


--SQL query to send refill messages instead of AI
USE WAREHOUSE MEDSYNC_WH;
USE DATABASE MEDSYNC_AI;

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

-- select * from gold.mart_refill_messages;


-- SELECT CURRENT_ACCOUNT();
-- SELECT CURRENT_ORGANIZATION_NAME();
-- SELECT CURRENT_REGION();
