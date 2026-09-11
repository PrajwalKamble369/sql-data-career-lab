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