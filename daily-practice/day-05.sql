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


/*

3. Category Sales Performance

Using products and order_items, calculate for each category:

category
number of unique products sold
total quantity sold
total revenue

Requirements:

Only include quantity > 0
Ignore rows where unit_price is NULL
Count unique products, not order items
Sort by total revenue descending

Return the top 10 categories.

Focus: JOIN, COUNT(DISTINCT ...), SUM, GROUP BY, NULL handling

*/



SELECT
    p.product_name, -- category field is not in this table so used prouct
    COUNT(DISTINCT p.product_id) AS number_of_unique_products_sold,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM
    products p
JOIN
    order_items oi
ON
    p.product_id = oi.product_id
WHERE
    oi.quantity >0
AND
    oi.unit_price IS NOT NULL
GROUP BY
    p.product_name
ORDER BY
    total_revenue DESC
LIMIT 10;

