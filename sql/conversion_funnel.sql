/* author: Yevsiukova L.
Розрахунок конверсій в розрізі дат та каналів трафіку
Опис завдання:
Створи запит для отримання таблиці з інформацією про конверсії від початку сесії до покупки. Таблиця з результатами має містити такі поля:
•	event_date — дата старту сесії, що отримана з поля event_timestamp
•	source — джерело відвідування сайту
•	medium — medium відвідування сайту
•	campaign — назва кампанії відвідування сайту
•	user_sessions_count — кількість унікальних сесій в унікальних користувачів у відповідну дату та для відповідного каналу трафіку.
•	visit_to_cart — конверсія від початку сесії на сайті до додавання товару в корзину (у відповідну дату та для відповідного каналу трафіку)
•	visit_to_checkout — конверсія від початку сесії на сайті до спроби оформити замовлення (у відповідну дату та для відповідного каналу трафіку)
•	Visit_to_purchase — конверсія від початку сесії на сайті до покупки (у відповідну дату та для відповідного каналу трафіку)
Примітка :різні користувачі можуть мати однакові ідентифікатори сесій, тому щоб порахувати унікальні сесії унікальних користувачів, треба враховувати не тільки ідентифікатор сесії, а й ідентифікатор користувача.*/

WITH base AS (
  SELECT
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
