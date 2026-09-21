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

/*

4. Customer Segment — Order Quality

Using customers and orders, calculate for each customer_segment:

number of unique customers
total orders
delivered orders
cancelled orders
total order value

Consider all orders.

Only include segments having at least 50 unique customers.

Sort by total order value descending.

Focus: multiple aggregations, COUNT, COUNT(DISTINCT), conditional counting, GROUP BY, HAVING

This is your first problem where you'll need to think carefully about how to count different subsets of rows inside the same group.

5. Product Revenue Leaderboard Preparation

Using products and order_items, find products that meet both conditions:

sold quantity is at least 100 units
total revenue is at least ₹1,00,000

Return:

product_id
product_name
brand
total quantity sold
total revenue
average selling price

Only consider:

quantity > 0
non-NULL unit_price

Sort by total revenue descending and return the top 25.

Focus: multi-table JOIN, aggregation, GROUP BY, HAVING, multiple business conditions.

Day 5 progression

P1 → basic JOIN + aggregation
P2 → revenue metrics + HAVING
P3 → DISTINCT aggregation + NULL handling
P4 → multiple conditional metrics in one query
P5 → combined business rules + aggregation

No solutions. Submit your SQL when you've worked through them, and I'll review each one individually and update your progress.

*/


SELECT
    c.customer_segment,
    COUNT(DISTINCT c.customer_id) AS number_of_unique_customers,
    COUNT(o.order_id) AS total_orders,
    COUNT(CASE WHEN o.order_status = 'delivered' THEN 1 END) AS delivered_orders, 
    COUNT(CASE WHEN o.order_status = 'cancelled' THEN 1 END) AS cancelled_order,
    SUM(o.total_amount) AS total_order_value
FROM
    customers c
JOIN
    orders o
ON
    c.customer_id = o.customer_id
GROUP BY
    c.customer_segment
HAVING
    COUNT(DISTINCT c.customer_id) >=50
ORDER BY
    total_order_value DESC;


/*

5. Product Revenue Leaderboard Preparation

Using products and order_items, find products that meet both conditions:

sold quantity is at least 100 units
total revenue is at least ₹1,00,000

Return:

product_id
product_name
brand
total quantity sold
total revenue
average selling price

Only consider:

quantity > 0
non-NULL unit_price

Sort by total revenue descending and return the top 25.

Focus: multi-table JOIN, aggregation, GROUP BY, HAVING, multiple business conditions.

*/


SELECT
    p.product_id,
    p.product_name,
    p.brand,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.quantity * oi.unit_price) AS total_revenue,
    AVG(oi.unit_price) AS average_selling_price
FROM 
    products p
JOIN 
    order_items oi 
ON 
    p.product_id = oi.product_id
WHERE 
    oi.quantity > 0
AND 
    oi.unit_price IS NOT NULL
GROUP BY 
    p.product_id,
    p.product_name,
    p.brand
HAVING 
    SUM(oi.quantity) >= 100
AND 
    SUM(oi.quantity * oi.unit_price) >= 100000
ORDER BY 
    total_revenue DESC
LIMIT 25;
