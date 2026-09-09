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