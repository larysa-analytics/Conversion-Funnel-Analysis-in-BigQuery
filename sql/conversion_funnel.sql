/*
  Author: Larysa Yevsiukova
  Project: E-commerce Conversion Funnel Analysis
  Database/Source: BigQuery Public Dataset (GA4 E-commerce)
  Description: SQL query to calculate step-by-step conversion rates 
  from session start to purchase, segmented by date and traffic acquisition channels.
*/
    TIMESTAMP_MICROS(event_timestamp) AS event_timestamp,
    user_pseudo_id ||
    CAST((SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS string) as user_session_id,
    event_name,
    traffic_source.source AS source,
    traffic_source.medium AS medium,
    traffic_source.name AS campaign
    FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` 
      WHERE event_name IN ('session_start', 'add_to_cart', 'begin_checkout', 'purchase')
      ),
sessions_count AS (
  SELECT
    DATE(event_timestamp) AS event_date,
    source,
    medium,
    campaign,
    COUNT(DISTINCT CASE WHEN event_name = 'session_start' THEN user_session_id END) AS user_session_count,
    COUNT(DISTINCT CASE WHEN event_name = 'add_to_cart' THEN  user_session_id END) AS add_to_cart_count,
    COUNT(DISTINCT CASE WHEN event_name = 'begin_checkout' THEN  user_session_id END) AS begin_checkout_count,
    COUNT(DISTINCT CASE WHEN event_name = 'purchase' THEN user_session_id END) AS purchase_count
  FROM base
  GROUP BY 1,2,3,4
)
SELECT
  event_date,
  source,
  medium,
  campaign,
  user_session_count,
  SAFE_DIVIDE(add_to_cart_count, user_session_count) AS visit_to_cart,
  SAFE_DIVIDE(begin_checkout_count, user_session_count) AS visit_to_checkout,
  SAFE_DIVIDE(purchase_count, user_session_count) AS visit_to_purchase
FROM sessions_count
ORDER BY event_date, source, medium, campaign;
