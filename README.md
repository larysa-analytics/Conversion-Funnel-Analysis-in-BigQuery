# E-commerce GA4 Data Pipeline & Conversion Funnel Analysis (BigQuery)

**End-to-End Data Preparation for BI & Sales Conversion Analysis using BigQuery SQL**

- **Tools:** SQL (Google BigQuery)
- **Data Source:** Google Analytics 4 (GA4) Public E-commerce Dataset (`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`)
- **Overview:** Developed a two-stage SQL analysis pipeline on GA4 event data: preparing raw event data for BI visualization tools (Power BI/Tableau) and aggregating user interactions to compute multi-stage funnel conversion rates across marketing channels.

---

## 📂 Project Structure & Workflow

### 1. Data Preparation for BI Systems (`sql/01_bi_raw_events_prep.sql`)
Extracted and transformed raw GA4 microsecond timestamps and nested JSON attributes (`event_params`, `geo`, `device`, `traffic_source`) into a clean, flat relational dataset (2021 data slice).
- **Filtered Events:** `session_start`, `view_item`, `add_to_cart`, `begin_checkout`, `add_shipping_info`, `add_payment_info`, `purchase`.
- **Dimensions Handled:** User identifiers (`user_pseudo_id`, `ga_session_id`), device categories, geographic locations, and traffic channels (`source`, `medium`, `campaign`).
- **Use Case:** Designed specifically as a clean data layer for import into BI platforms (Power BI / Tableau) for interactive dashboarding.

### 2. Conversion Funnel Analysis (`sql/02_conversion_funnel_metrics.sql`)
Built an analytical aggregation query to calculate step-by-step conversion rates from initial site visit to final purchase.
- **Funnel Metrics Computed:**
  - `visit_to_cart` (Session Start → Add to Cart)
  - `visit_to_checkout` (Session Start → Begin Checkout)
  - `visit_to_purchase` (Session Start → Purchase)
- **Segmentation:** Metrics grouped across dates and multi-channel marketing campaigns.

---

## 🎯 Key Results & Business Value
- Created a robust SQL data transformation process handling unnested arrays and GA4 event parameters.
- Delivered structured output datasets ready for executive dashboarding and performance marketing optimization.
