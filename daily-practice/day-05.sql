/*

1. Customer Order Count

Using customers and orders, find customers who have placed at least 3 orders.

Return:

customer_id
first_name
last_name
number of orders

Include all order statuses.

Sort by number of orders descending, then customer_id ascending.

Focus: JOIN, COUNT, GROUP BY, ORDER BY, HAVING

*/


SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(o.order_id) AS number_of_orders
FROM
    customers c
JOIN
    orders o
ON
    c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
HAVING
    COUNT(o.order_id) >=3
ORDER BY
    number_of_orders DESC,
    c.customer_id ASC;