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
