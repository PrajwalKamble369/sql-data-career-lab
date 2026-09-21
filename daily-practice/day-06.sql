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

SELECT * FROM customers;
SELECT * FROM orders;

SELECT
    customer_id,
    first_name,
    last_name,
    SUM(total_amount) ,
    (CASE WHEN SUM(total_amount >=200000) THEN 1 END) AS High_Value,
    (CASE WHEN SUM(total_amount >=100000) THEN 1 END) AS Medium_Value,
    (CASE WHEN SUM(total_amount <100000) THEN 1 END) AS Low_Value