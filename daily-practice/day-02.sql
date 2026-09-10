/*
1. Customer Order Activity — Basic Filtering

Using orders, return:

order_id
customer_id
order_date
total_amount
order_status

Requirements:

Orders with total_amount >= 10,000
Only orders with status delivered or shipped
Sort by total_amount highest → lowest
Return the top 20 rows
*/

SELECT
    order_id,
    customer_id,
    order_date,
    total_amount,
    order_status
FROM
    orders
WHERE
    total_amount >= 10000
AND
    order_status IN ('delivered','shipped')
ORDER BY
    total_amount DESC
LIMIT 20;

