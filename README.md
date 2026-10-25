# Conversion Funnel Analysis in BigQuery

**E-commerce Conversion Funnel & Sales Performance Analysis using SQL (BigQuery)**

* **Tools:** SQL (Google BigQuery)
* **Overview:** Built an advanced SQL query to calculate step-by-step conversion rates (from initial session start to purchase) broken down by dates and traffic acquisition channels.

### Key Tasks & Implementation:
* **Data Transformation:** Extracted event-level data and parsed timestamps to generate session-level dates (`event_date`).
* **Traffic Segmentation:** Categorized traffic sources across three dimensions: `source`, `medium`, and `campaign`.
* **User Session Calculation:** Aggregated unique sessions by combining user identifiers and session IDs to ensure precise counting.
* **Funnel Metrics Computation:** Calculated multi-stage conversion rates for each date and traffic channel:
  * `visit_to_cart` (Session Start → Add to Cart)
  * `visit_to_checkout` (Session Start → Begin Checkout)
  * `visit_to_purchase` (Session Start → Purchase)

### Key Result:
Generated a clean, structured analytical dataset evaluating marketing funnel performance across dates and acquisition channels, ready for executive dashboarding and performance marketing optimization.
