-- Read in the data and preview top 10 rows
SELECT *
FROM dsv1069.events_201701
LIMIT 10

-- How many records in the table?
SELECT COUNT(*)
FROM dsv1069.events_201701
-- Compared to how many unique event_ids?
SELECT COUNT(DISTINCT(EVENT_ID))
FROM dsv1069.events_201701

-- Examine unique event_names and parameter_names
SELECT DISTINCT(EVENT_NAME)
FROM dsv1069.events_201701
SELECT DISTINCT(PARAMETER_NAME)
FROM dsv1069.events_201701

-- Reshape into wide data
CREATE TEMP TABLE df_wide AS
  SELECT event_id,
    event_time,
    user_id,
    event_name,
    platform,
    MAX(CASE WHEN parameter_name='item_id' THEN parameter_value END) AS item_id,
    MAX(CASE WHEN parameter_name='referrer' THEN parameter_value END) AS referrer,
    MAX(CASE WHEN parameter_name='test_assignment' THEN parameter_value END) AS test_assignment,
    MAX(CASE WHEN parameter_name='test_id' THEN parameter_value END) AS test_id,
    MAX(CASE WHEN parameter_name='viewed_user_id' THEN parameter_value END) AS viewed_user_id
  FROM dsv1069.events_201701
  GROUP BY event_id,
    event_time,
    user_id,
    event_name,
    platform;
  
--Print frequency tables for test_assignment and test_id columns
SELECT test_assignment,
 COUNT(*) AS "Frequency"
FROM df_wide
GROUP BY test_assignment
   
SELECT test_id,
  COUNT(*) AS "Frequency"
FROM df_wide
GROUP BY test_id
   
-- Check all columns for missing values
SELECT
  SUM(CASE WHEN event_id IS NULL THEN 1 ELSE 0 END) AS "event_id_null",
  SUM(CASE WHEN event_time IS NULL THEN 1 ELSE 0 END) AS "event_time_null",
  SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS "user_id_null",
  SUM(CASE WHEN event_name IS NULL THEN 1 ELSE 0 END) AS "event_name_null",
  SUM(CASE WHEN platform IS NULL THEN 1 ELSE 0 END) AS "platform_null",
  SUM(CASE WHEN item_id IS NULL THEN 1 ELSE 0 END) AS "item_id_null",
  SUM(CASE WHEN referrer IS NULL THEN 1 ELSE 0 END) AS "referrer_null",
  SUM(CASE WHEN test_assignment IS NULL THEN 1 ELSE 0 END) AS "test_assignment_null",
  SUM(CASE WHEN test_id IS NULL THEN 1 ELSE 0 END) AS "test_id_null",
  SUM(CASE WHEN viewed_user_id IS NULL THEN 1 ELSE 0 END) AS "viewed_user_id_null"
FROM df_wide

-- Group data by month to ensure no missing values.
SELECT TO_CHAR(event_time, 'yyyy-mm') AS event_time_month,
  COUNT(*) AS "Frequency"
FROM dsv1069.events_201701
GROUP BY TO_CHAR(event_time, 'yyyy-mm')
