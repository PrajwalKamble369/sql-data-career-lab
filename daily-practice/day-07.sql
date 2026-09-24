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

/*

3. Customers With Above-Average Order Value

Difficulty: 🟡 → 🔴
Focus: subquery + aggregation

Find customers whose average order value is greater than the overall average order value across all orders.

Return:

customer_id
first_name
last_name
order_count
avg_order_value

Requirements:

Consider all orders.
Customers must have at least 3 orders.
Sort by avg_order_value descending.

Think carefully about the difference between:
    Average order value per customer

and

    Average order value across the entire orders table
*/



SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(o.order_id) AS order_count,
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
    c.last_name
HAVING
    COUNT(o.order_id) >=3
    AND
    AVG(o.total_amount) >
        (SELECT
            AVG(total_amount) 
        FROM 
            orders)
ORDER BY
    avg_order_value DESC;


/*

4. Products That Have Never Been Ordered

Difficulty: 🔴
Focus: subquery + NOT EXISTS / anti-join thinking

Find products that have never appeared in order_items.

Return:

product_id
product_name
brand
price

Sort by product_id ascending.

Important: Solve this using a subquery approach. You can later compare it with a LEFT JOIN solution.

This is a common data-quality/business problem: identifying products that exist in the catalog but have no transactional activity.

*/

SELECT
    p.product_id,
    p.product_name,
    p.brand,
    p.price
FROM
    products p
WHERE NOT EXISTS
    (SELECT 1
    FROM order_items oi
    WHERE oi.product_id = p.product_id)
ORDER BY
    p.product_id ASC;

/*

5. Customers Spending More Than Their Segment Average

Difficulty: 🔴🔥
Focus: correlated/subquery thinking + aggregation + joins

For each customer, calculate their total delivered revenue.

Then identify customers whose delivered revenue is greater than the average delivered revenue of customers in their own customer_segment.

Return:

customer_id
first_name
last_name
customer_segment
total_delivered_revenue
segment_average_revenue

Only include customers with at least one delivered order.

Sort by:

customer_segment ascending
total_delivered_revenue descending

*/
