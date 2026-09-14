/*

1. High-Value Recent Orders

Using orders, return:

order_id
customer_id
order_date
total_amount
order_status

Requirements:

total_amount >= 15,000
Include only delivered or shipped
Exclude rows where total_amount is NULL
Sort by total_amount highest → lowest
For equal amounts, sort by order_date newest → oldest
Return the top 20

Focus: WHERE, IN, NULL, multi-column ORDER BY, LIMIT

*/

SELECT * FROM orders;
SELECT
    order_id,
    customer_id,
    order_date,
    total_amount,
    order_status
FROM
    orders
WHERE
    total_amount >= 15000
AND
    order_status IN ('delivered','shipped')
AND
    total_amount IS NOT NULL
ORDER BY 
    total_amount DESC,
    order_date DESC
LIMIT 20;
