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


/*

2. Product Performance Summary

Using order_items, calculate for each product_id:

product_id
number of order items
total quantity sold
total revenue
average selling price

Requirements:

Only include rows where quantity > 0
unit_price must not be NULL
Revenue = quantity × unit_price
Sort by total revenue descending
Return the top 20 products

Focus: COUNT, SUM, AVG, arithmetic, GROUP BY, NULL filtering

*/
SELECT
    product_id,
    COUNT(order_id) AS number_of_order_items,
    SUM(quantity) AS total_quantity_sold,
    SUM(unit_price * quantity) AS total_revenue,
    AVG(unit_price) AS avg_selling_price
FROM
    order_items
WHERE
    quantity > 0
AND
    unit_price IS NOT NULL
GROUP BY
    product_id
ORDER BY
    total_revenue DESC
LIMIT
    20;

/*

3. Valuable Customers

Using customers and orders, find customers who have:

At least 5 delivered orders
At least ₹1,00,000 total delivered order value

Return:

customer_id
first_name
last_name
customer_segment
number of delivered orders
total delivered order value
average delivered order value

Sort by total delivered order value descending.

Focus: JOIN, WHERE, GROUP BY, HAVING


*/


SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.customer_segment,
    COUNT(o.order_id) AS number_of_delivered_orders,
    SUM(o.total_amount) AS total_delivered_order_value,
    AVG(o.total_amount) AS average_delivered_order_value
FROM
    customers c
INNER JOIN
    orders o
ON
    c.customer_id = o.customer_id
WHERE
    o.order_status = 'delivered'
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.customer_segment
HAVING
    COUNT(o.order_id) >=5
    AND SUM(o.total_amount) >= 100000
ORDER BY
    total_delivered_order_value DESC;

/*

4. Brand Revenue Analysis

Using products and order_items, calculate for each brand:

brand
number of different products sold
total quantity sold
total revenue

Requirements:

Only positive quantities
Only products appearing in order_items
Sort by total revenue descending
Return the top 15 brands

Focus: JOIN, COUNT(DISTINCT ...), SUM, GROUP BY

*/

SELECT * FROM products;
SELECT * FROM order_items;

SELECT
    p.brand,
    COUNT(DISTINCT oi.order_id) AS num_of_product_sold,
    SUM(oi.quantity) AS quantity_sold,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM
    products p
JOIN
    order_items oi
ON
    p.product_id = oi.product_id
GROUP BY
    p.brand
ORDER BY
    total_revenue DESC
LIMIT 15;

/*

5. Customer Segment Performance

Using customers and orders, calculate for each customer_segment:

number of unique customers
number of delivered orders
total delivered revenue
average delivered order value

Only include segments having:

at least 100 delivered orders
at least ₹50,00,000 total delivered revenue

Sort by total delivered revenue descending.

Focus: combining JOIN + COUNT(DISTINCT) + GROUP BY + HAVING

*/


SELECT
    c.customer_segment,
    COUNT(DISTINCT c.customer_id) AS unique_customers,
    COUNT(o.order_id) AS delivered_orders,
    SUM(o.total_amount) AS revenue,
    AVG(o.total_amount) AS average_delivered_order_value 
FROM
    customers c
JOIN
    orders o
ON
    c.customer_id = o.customer_id
WHERE
    o.order_status = 'delivered'
GROUP BY
    c.customer_segment
HAVING
    COUNT(o.order_id) >= 100
    AND
    SUM(o.total_amount) >= 5000000
ORDER BY
    revenue DESC;
