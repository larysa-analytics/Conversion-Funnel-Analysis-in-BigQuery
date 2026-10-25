/*
  Author: Larysa Yevsiukova
  Project: E-commerce GA4 Data Pipeline
  Script: 01_bi_raw_events_prep.sql
  Database/Source: BigQuery Public Dataset (GA4 E-commerce)
  Description: Extracts and cleans raw GA4 event-level data (2021) to prepare 
               a structured staging dataset for BI systems (Power BI / Tableau).
*/

WITH base AS (
  SELECT 
    TIMESTAMP_MICROS(event_timestamp) AS event_timestamp,
    user_pseudo_id,
    (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS session_id,
    event_name,
    geo.country AS country,
    device.category AS device_category,
    traffic_source.source AS source,
    traffic_source.medium AS medium,
    traffic_source.name AS campaign
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` 
      WHERE _TABLE_SUFFIX BETWEEN '20210101' AND '20211231'
      AND event_name IN (
      'session_start',
      'view_item',
      'add_to_cart',
      'begin_checkout',
      'add_shipping_info',
      'add_payment_info',
      'purchase'
    )
)
SELECT DISTINCT
  event_timestamp,
  user_pseudo_id,
  session_id,
  event_name,
  country,
  device_category,
  source,
  medium,
  campaign
FROM base
WHERE session_id IS NOT NULL
ORDER BY user_pseudo_id, session_id;
