/*

Customer Profile Extraction

Using the customers table, return:

customer_id
first_name
last_name
email
city
state

Requirements:

Return only the first 20 customers.
Sort by customer_id in ascending order.
Do not use SELECT *.
*/

SELECT 
    customer_id,
    first_name,
    last_name,
    email,
    city,
    state
FROM
    customers
ORDER BY 
    customer_id ASC
LIMIT 20
;

/*
Maharashtra Customers

Using the customers table, return:

customer_id
first_name
last_name
city
customer_segment

Requirements
Return only customers from Maharashtra.
Return the first 25 customers.
Sort by customer_id in ascending order.
Do not use SELECT

*/

SELECT
    customer_id, 
    first_name, 
    last_name, 
    city,customer_segment
FROM 
    customers
WHERE state = 'Maharashtra'
ORDER BY customer_id ASC
LIMIT 25;

/*
High-Value Products

Using the products table, return:

product_id
product_name
brand
price
product_rating

Requirements
Only products where price > 50,000
Sort by price from highest to lowest
Return only the top 20
Do not use SELECT *
*/

SELECT 
    product_id,
    product_name,
    brand,
    price,
    product_rating
FROM
    products
WHERE
    price > 50000
ORDER BY price DESC
LIMIT 20;

/*
Using the customers table, return:

customer_id
first_name
last_name
email
customer_segment
is_active
Requirements
customer_segment must be Premium
Customer must be active
Sort by customer_id ascending
Return only the first 30
Don't use SELECT *
*/

SELECT
    customer_id,
    first_name,
    last_name,
    email,
    customer_segment,
    is_active
FROM
    customers
WHERE 
    customer_segment = 'Premium'
AND
    is_active = TRUE
ORDER BY
    customer_id
LIMIT 30;

/*
Recent Delivered Orders

Use the orders table.

Return:

order_id
customer_id
order_date
total_amount
sales_channel
Requirements
Only orders where order_status = 'delivered'
Only orders placed during 2026
Sort by order_date from newest → oldest
Return only 25 rows
*/

SELECT
    order_id,
    customer_id,
    order_date,
    total_amount,
    sales_channel
FROM
    orders
WHERE
    order_status = 'delivered'
    AND order_date >= '2026-01-01 00:00:00'
    AND order_date < '2027-01-01 00:00:00'
ORDER BY order_date DESC
LIMIT 25;
