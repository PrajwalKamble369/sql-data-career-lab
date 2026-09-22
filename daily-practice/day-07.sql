/*

1. High-Value Customers

Difficulty: 🟢 → 🟡
Focus: aggregation + HAVING

Using customers and orders, find customers who:

Have at least 5 orders
Have total order value of at least ₹100,000
Include all order statuses

Return:

customer_id
first_name
last_name
customer_segment
order_count
total_order_value
avg_order_value

Sort by total_order_value descending.

*/



SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.customer_segment,
    COUNT(o.order_id) AS order_count,
    COUNT(o.order_id) AS total_order_value,
    AVG(o.total_amount) AS avg_order_value
FROM
    customers c
JOIN
    orders o
ON
    c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.customer_segment
HAVING
    COUNT(o.order_id) >= 5
    AND
    COUNT(o.order_id) >= 100000
ORDER BY
    total_order_value DESC;

/*

2. Products Above Average Price

Difficulty: 🟡
Focus: scalar subquery + filtering

Using products, find products whose price is greater than the overall average product price.

Return:

product_id
product_name
brand
price

Sort by price descending.

Challenge: The average price should be calculated dynamically from the table, not manually determined.

*/


SELECT
    product_id,
    product_name,
    brand,
    price
FROM 
    products
WHERE
    price >
        (SELECT
            AVG(price) 
        FROM
            products)
ORDER BY
    price DESC;