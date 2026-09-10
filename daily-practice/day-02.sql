/*
1. Customer Order Activity — Basic Filtering

Using orders, return:

order_id
customer_id
order_date
total_amount
order_status

Requirements:

Orders with total_amount >= 10,000
Only orders with status delivered or shipped
Sort by total_amount highest → lowest
Return the top 20 rows
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
    total_amount >= 10000
AND
    order_status IN ('delivered','shipped')
ORDER BY
    total_amount DESC
LIMIT 20;

/*
2. Sales Channel Summary — Aggregation

Using orders, calculate for each sales_channel:

Number of orders
Total sales (SUM(total_amount))
Average order value

Sort by total sales highest → lowest.

Concept focus: COUNT, SUM, AVG, GROUP BY, ORDER B
*/



SELECT
    sales_channel
    COUNT(order_id) AS number_of_orders,
    SUM(total_amount) AS total_sales,
    AVG(total_amount) AS avg_order_value
FROM 
    orders
GROUP BY
    sales_channel
ORDER BY
    SUM(total_amount) DESC;

/*
3. Valuable Customers — GROUP BY + HAVING

Using orders, find customers who:

Have placed at least 5 orders
Have generated at least ₹100,000 in total order value

Return:

customer_id
number of orders
total order value
average order value

Sort by total order value descending.

Concept focus: GROUP BY + HAVING

*/

SELECT
    customer_id,
    COUNT(order_id) AS number_of_orders,
    SUM(total_amount) AS total_order_value,
    AVG(total_amount)AS avg_order_value
FROM
    orders
GROUP BY
    customer_id
HAVING
    COUNT(order_id) >= 5
    AND
    SUM(total_amount) > 100000;

