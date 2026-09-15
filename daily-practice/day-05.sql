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

/*

2. Delivered Revenue by Customer

Using customers and orders, calculate for each customer:

customer_id
first_name
last_name
total delivered revenue
average delivered order value

Only consider delivered orders.

Only show customers whose total delivered revenue is at least ₹50,000.

Sort by total delivered revenue descending.

Focus: JOIN, WHERE, SUM, AVG, GROUP BY, HAVING

*/



SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(o.total_amount) AS total_delivered_revenue,
    AVG(o.total_amount) AS avg_delivered_order_value
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
HAVING
    SUM(o.total_amount) >= 50000
ORDER BY
    total_delivered_revenue DESC;