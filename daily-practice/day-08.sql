/*

1. Monthly Revenue Analysis

Difficulty: 🟢 → 🟡
Focus: dates · filtering · aggregation · GROUP BY

Using orders, analyze orders placed during 2025.

Return one row per month:

month
order_count
total_order_value
average_order_value

Include all order statuses.

Sort chronologically from January to December.

*/

SELECT
    EXTRACT(MONTH FROM order_date) AS month,
    COUNT(order_id) AS order_count,
    SUM(total_amount) AS total_order_value,
    AVG(total_amount) AS average_order_value
FROM 
    orders
WHERE
    EXTRACT(YEAR FROM order_date) = 2025
GROUP BY
    EXTRACT(MONTH FROM order_date)
ORDER BY
    month;