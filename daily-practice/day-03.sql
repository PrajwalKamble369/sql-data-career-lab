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


/*

2. Product Performance — Aggregation

Using order_items, calculate for each product_id:

Number of order items
Total quantity sold
Total revenue

Assume:

revenue = quantity × unit_price

Requirements:

Only include rows where quantity > 0
Sort by total revenue descending
Return the top 20 products

Focus: SUM, COUNT, arithmetic expressions, GROUP BY

*/


SELECT
    product_id,
    COUNT(order_item_id) AS number_of_order_items,
    SUM(quantity) AS quantity_sold,
    SUM(quantity * unit_price) AS total_revenue
FROM
    order_items
WHERE 
    quantity > 20
GROUP BY
    product_id
ORDER BY
    total_revenue DESC
LIMIT
    20;

/*

3. High-Value Customer Segments — GROUP BY + HAVING

Using customers and orders, calculate for each customer_segment:

Number of unique customers who placed orders
Number of orders
Total order value
Average order value

Only include segments where:

Total order value is at least ₹1 crore

Sort by total order value descending.

Focus: JOIN, COUNT(DISTINCT ...), GROUP BY, HAVING

*/


SELECT
    c.customer_segment,
    COUNT(DISTINCT c.customer_id) AS number_of_unique_customer,
    COUNT(o.order_id) AS number_of_orders,
    SUM(o.total_amount) AS total_order_value,
    AVG(o.total_amount) AS avg_order_value
FROM
    customers c
JOIN
    orders o
ON
    c.customer_id = o.customer_id
GROUP BY
    c.customer_segment
HAVING
    SUM(o.total_amount) >= 10000000
ORDER BY
    total_order_value DESC;

/*

4. Customer Order Behavior — Subquery

Find customers whose total order value is greater than the average total order value across all customers.

Return:

customer_id
total order value
number of orders
average order value

Only consider delivered orders.

Sort by total order value descending.

Important: Don't calculate the overall average manually. Let SQL calculate it.

Focus: aggregation + subquery + multi-level analytical reasoning.

*/

SELECT
    customer_id,
    SUM(total_amount) AS total_order_value,
    COUNT(order_id) AS number_of_orders,
    AVG(total_amount) AS avg_order_value
FROM
    orders
WHERE
    order_status = 'delivered'
GROUP BY
    customer_id
HAVING
    SUM(total_amount) > (
        -- Subquery: Calculates the average total spend per customer
        SELECT AVG(customer_total)
        FROM (
            SELECT SUM(total_amount) AS customer_total
            FROM orders
            WHERE order_status = 'delivered'
            GROUP BY customer_id
        ) AS customer_averages
    )
ORDER BY
    total_order_value DESC;

/*

5. Monthly Revenue Classification — CASE + Date Analysis

Using orders, analyze delivered orders from 2026.

For each month, return:

month
total delivered sales
number of delivered orders
average order value
a sales_category

Classify each month based on total delivered sales:

>= ₹10,00,000       → 'High'
>= ₹5,00,000        → 'Medium'
< ₹5,00,000         → 'Low'

Sort chronologically from January → December.

Focus: date extraction + aggregation + CASE.

*/

SELECT
    EXTRACT(MONTH FROM order_date) AS month,
    SUM(total_amount) AS total_delivered_sales,
    COUNT(order_id) AS number_of_delivered_orders,
    AVG(total_amount) AS average_order_value,
    CASE 
        WHEN SUM(total_amount) >= 1000000 THEN 'High'
        WHEN SUM(total_amount) >= 500000  THEN 'Medium'
        ELSE 'Low'
    END AS sales_category
FROM
    orders
WHERE
    order_status = 'delivered'
    AND EXTRACT(YEAR FROM order_date) = 2026
GROUP BY
    EXTRACT(MONTH FROM order_date)
ORDER BY
    month ASC;
