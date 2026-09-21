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
