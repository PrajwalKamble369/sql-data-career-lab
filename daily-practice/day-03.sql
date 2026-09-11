/*

1. Customer Spending — Filtering + Sorting

Using orders, return:

order_id
customer_id
order_date
total_amount
order_status

Requirements:

total_amount between ₹5,000 and ₹50,000, inclusive
Exclude cancelled orders
Sort by total_amount descending
For equal amounts, sort by order_date newest → oldest
Return the top 25

Focus: WHERE, BETWEEN, AND, ORDER BY

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
    total_amount BETWEEN 5000 AND 50000
    AND order_status <> 'cancelled'
ORDER BY
    total_amount DESC,
    order_date ASC
LIMIT 25 ;

