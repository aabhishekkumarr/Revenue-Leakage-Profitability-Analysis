/* ============================================================
   PROJECT: Revenue Leakage & Profitability Analysis
   AUTHOR: Abhishek Kumar
   PURPOSE:
   - Analyze revenue leakage caused by discounts
   - Evaluate profitability by region, category, and customer
   - Support Power BI dashboards with optimized queries
   ============================================================ */


/* ============================================================
   1. DISCOUNT BUCKET PROFITABILITY ANALYSIS
   ============================================================ */

SELECT
    CASE
        WHEN discount <= 0.10 THEN 'Low (0-10%)'
        WHEN discount <= 0.30 THEN 'Medium (10-30%)'
        ELSE 'High (30%+)'
    END AS discount_bucket,
    ROUND(SUM(true_profit), 2) AS total_profit
FROM superstore_cleaned
GROUP BY discount_bucket
ORDER BY total_profit DESC;


/* ============================================================
   2. REVENUE LEAKAGE BY SUB-CATEGORY
   ============================================================ */

SELECT
    sub_category,
    ROUND(SUM(discount_loss), 2) AS total_discount_loss
FROM superstore_cleaned
GROUP BY sub_category
ORDER BY total_discount_loss DESC
LIMIT 5;


/* ============================================================
   3. PROFITABILITY BY REGION
   ============================================================ */

SELECT
    region,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(SUM(true_profit), 2) AS total_profit,
    ROUND(SUM(true_profit) / SUM(sales) * 100, 2) AS net_margin_percent
FROM superstore_cleaned
GROUP BY region
ORDER BY total_profit DESC;


/* ============================================================
   4. REGION × CATEGORY PROFITABILITY MATRIX
   ============================================================ */

SELECT
    region,
    category,
    ROUND(SUM(sales), 2) AS net_revenue,
    ROUND(SUM(true_profit), 2) AS total_profit,
    ROUND(SUM(true_profit) / SUM(sales) * 100, 2) AS net_margin_percent
FROM superstore_cleaned
GROUP BY region, category
ORDER BY region, net_margin_percent DESC;


/* ============================================================
   5. HIGH REVENUE BUT LOW PROFIT PRODUCTS
   ============================================================ */

SELECT
    sub_category,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(SUM(true_profit), 2) AS total_profit
FROM superstore_cleaned
GROUP BY sub_category
ORDER BY total_revenue DESC;


/* ============================================================
   6. CUSTOMER RISK ANALYSIS (LOW PROFIT CUSTOMERS)
   ============================================================ */

SELECT
    customer_id,
    ROUND(SUM(sales), 2) AS total_revenue,
    ROUND(SUM(true_profit), 2) AS total_profit
FROM superstore_cleaned
GROUP BY customer_id
ORDER BY total_profit ASC
LIMIT 20;


/* ============================================================
   7. INDEXING FOR PERFORMANCE OPTIMIZATION
   (Improves filtering & aggregation performance in BI tools)
   ============================================================ */

CREATE INDEX idx_region ON superstore_cleaned(region);
CREATE INDEX idx_category ON superstore_cleaned(category);
CREATE INDEX idx_sub_category ON superstore_cleaned(sub_category);
CREATE INDEX idx_customer ON superstore_cleaned(customer_id);
