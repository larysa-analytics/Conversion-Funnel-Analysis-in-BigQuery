/* author: Yevsiukova L.
Завдання 2. Підготовка даних для побудови звітів у BI системах.
Створи запит для отримання таблиці з інформацією про події, користувачів та сесії в GA4.
В результаті виконання запиту ми маємо отримати таблицю, що міститиме  поля:
•	event_timestamp — дата та час події (тип даних має бути timestamp)
•	user_pseudo_id — анонімний ідентифікатор користувача в GA4
•	session_id — ідентифікатор сесії подій в GA4
•	event_name — назва події
•	country — країна користувача сайту
•	device_category — категорія пристрою користувача сайту
•	source — джерело відвідування сайту
•	medium — medium відвідування сайту
•	campaign — назва кампанії відвідування сайту
Таблиця має включати лише дані за 2021 рік і таких подій:
•	Початок сесії на сайті
•	Перегляд товару
•	Додавання товару до корзини
•	Подія початку оформлення замовлення
•	Додавання інформації про доставку
•	Додавання платіжної інформації
•	Покупка*/

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
