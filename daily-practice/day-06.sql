/*

Focus: JOIN · WHERE · SUM() · GROUP BY · CASE

Using customers and orders, return:

customer_id
first_name
last_name
total_delivered_revenue
spending_tier

Only consider delivered orders.

Classify customers:

>= 200000 → High Value
>= 100000 → Medium Value
< 100000 → Low Value

Sort by total_delivered_revenue descending.

*/


SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(o.total_amount) AS total_delivered_revenue,
    CASE
        WHEN SUM(o.total_amount) >=200000 THEN 'High_Value'
        WHEN SUM(o.total_amount) >=100000 THEN  'Medium_Value'
        ELSE 'Low_Value'
    END AS spending_tier
FROM
    customers c
JOIN
    orders o
ON
    c.customer_id = o.customer_id
WHERE
    o.order_status = 'delivered'
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY
    total_delivered_revenue DESC;


/*

2. Order Value Classification

Difficulty: 🟢 → 🟡
Focus: CASE · NULL handling · filtering · sorting

Using orders, return:

order_id
customer_id
total_amount
order_status
order_value_category

Classification:

>= 50000 → Very High
>= 20000 → High
>= 5000 → Medium
< 5000 → Low
NULL → Unknown

Only include orders with status delivered or shipped.

Sort by total_amount descending, with NULL values last.

Return the top 30.

*/

SELECT
    order_id,
    customer_id,
    total_amount,
    order_status,
    CASE
        WHEN total_amount >= 50000 THEN 'Very High'
        WHEN total_amount >= 20000 THEN 'High'
        WHEN total_amount >= 5000 THEN 'Medium'
        WHEN total_amount < 5000 THEN 'LOW'
        ELSE 'UNKOWN'
    END AS order_value_category
FROM
    orders
WHERE
    order_status IN ('delivered', 'shipped')
ORDER BY
    total_amount DESC NULLS LAST
LIMIT 30;

/*

3. Product Revenue With Missing Prices

Difficulty: 🟡 Medium
Focus: JOIN · COALESCE() · aggregation · NULL handling

Using products and order_items, return:

product_id
product_name
brand
total_quantity_sold
total_revenue
number_of_order_items

Rules:

Only include quantity > 0.
unit_price can be NULL.
Treat NULL unit_price as 0 when calculating revenue.
Sort by total_revenue descending.
Return the top 20 products.

Think about this as preparing a clean product-level dataset for analytics or an ML pipeline.

*/

SELECT
    p.product_id,
    p.product_name,
    p.brand,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.quantity * COALESCE(oi.unit_price, 0)) AS total_revenue,
    COUNT(oi.order_item_id) AS number_of_order_items -- Assuming primary key of order_items table
FROM
    products p
JOIN
    order_items oi ON p.product_id = oi.product_id
WHERE
    oi.quantity > 0 -- Filters out non-positive quantities
GROUP BY
    p.product_id,
    p.product_name,
    p.brand
ORDER BY
    total_revenue DESC
LIMIT 20;

/*

4. Customer Activity Classification

Difficulty: 🟡 → 🔴
Focus: LEFT JOIN · conditional counting · CASE · GROUP BY

Using customers and orders, include every customer, even customers with zero delivered orders.

Return:

customer_id
first_name
last_name
delivered_order_count
activity_level

Classification:

10+ → Very Active
5–9 → Active
1–4 → Occasional
0 → Inactive

Only delivered orders should contribute to the count.

Sort by:

delivered_order_count descending
customer_id ascending

The key challenge is deciding where the delivered-order condition belongs so that inactive customers aren't accidentally removed.

*/

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(CASE WHEN o.order_status = 'delivered' THEN o.order_id END) AS delivered_order_count,
    CASE 
        WHEN COUNT(CASE WHEN o.order_status = 'delivered' THEN o.order_id END) >= 10 THEN 'Very Active'
        WHEN COUNT(CASE WHEN o.order_status = 'delivered' THEN o.order_id END) BETWEEN 5 AND 9 THEN 'Active'
        WHEN COUNT(CASE WHEN o.order_status = 'delivered' THEN o.order_id END) BETWEEN 1 AND 4 THEN 'Occasional'
        ELSE 'Inactive'
    END AS activity_level
FROM customers c
LEFT JOIN orders o 
    ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY 
    delivered_order_count DESC,
    c.customer_id ASC;


/*

5. Revenue Quality by Customer Segment

Difficulty: 🔴 Hard
Focus: conditional aggregation · CASE · arithmetic · ROUND() · HAVING

Using customers and orders, return one row per customer_segment:

customer_segment
unique_customers
total_orders
delivered_orders
cancelled_orders
delivered_revenue
avg_delivered_order_value
delivered_order_percentage

Calculate:

delivered_order_percentage = delivered_orders / total_orders × 100

Rules:

Count customers uniquely.
Count all orders.
Count delivered orders separately.
Count cancelled orders separately.
Revenue should come only from delivered orders.
Average order value should use only delivered orders.
Round the percentage to 2 decimal places.
Include only segments with at least 100 total orders.
Sort by delivered_order_percentage descending.

This is the most important problem today: you need to calculate several different metrics from the same grouped dataset without filtering away the rows needed for other metrics.


*/

SELECT 
    c.customer_segment,
    COUNT(DISTINCT c.customer_id) AS unique_customers,
    COUNT(o.order_id) AS total_orders,
    COUNT(CASE WHEN o.order_status = 'delivered' THEN o.order_id END) AS delivered_orders,
    COUNT(CASE WHEN o.order_status = 'cancelled' THEN o.order_id END) AS cancelled_orders,
    SUM(CASE WHEN o.order_status = 'delivered' THEN o.order_amount ELSE 0 END) AS delivered_revenue,
    AVG(CASE WHEN o.order_status = 'delivered' THEN o.order_amount END) AS avg_delivered_order_value,
    ROUND(
        100.0 * COUNT(CASE WHEN o.order_status = 'delivered' THEN o.order_id END) / COUNT(o.order_id), 
        2
    ) AS delivered_order_percentage
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_segment
HAVING 
    COUNT(o.order_id) >= 100
ORDER BY 
    delivered_order_percentage DESC;