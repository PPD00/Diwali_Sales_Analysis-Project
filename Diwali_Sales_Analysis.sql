CREATE TABLE diwali_sales (
    User_ID INT,
    Cust_name VARCHAR(500),
    Product_ID VARCHAR(50),
    Gender CHAR(1),
    Age_Group VARCHAR(20),
    Age INT,
    Marital_Status INT,
    State VARCHAR(50),
    Zone VARCHAR(50),
    Occupation VARCHAR(50),
    Product_Category VARCHAR(50),
    Orders INT,
    Amount DECIMAL(10, 2)
);

COPY diwali_sales FROM 'E:\POWER_BI\Diwali Sales Project/Diwali Sales Data_new.csv' WITH (FORMAT csv, HEADER, ENCODING 'WIN1252', DELIMITER ',', QUOTE '"');


select * from diwali_sales
select COUNT(*) from diwali_sales

-- Query lelo Query

1. Calculate the total sales amount for each product category.

SELECT product_category, SUM(amount) AS total_sales_amount
FROM diwali_sales
GROUP BY product_category
ORDER BY total_sales_amount DESC

2. List the top 5 states based on the total sales amount.

SELECT state, SUM(amount) AS total_sales_amount
FROM diwali_sales
GROUP BY state
ORDER BY total_sales_amount DESC
LIMIT 5

3. Identify the customers who made the highest number of orders. -- top 5 customers are listed below

SELECT cust_name, SUM(orders) AS no_of_orders
FROM diwali_sales
GROUP BY cust_name
ORDER BY no_of_orders DESC
LIMIT 5 

4. Calculate the average order amount for each age group.

SELECT age_group, ROUND(AVG(amount), 2) AS avg_order_amount
FROM diwali_sales
GROUP BY age_group
ORDER BY avg_order_amount DESC

5. List the top 3 occupations based on the total sales amount.

SELECT occupation, SUM(amount) AS total_sales_amount
FROM diwali_sales
GROUP BY occupation
ORDER BY total_sales_amount DESC
LIMIT 3

6. Identify the most popular product category for each state.

WITH popular_category AS (
SELECT state, product_category, SUM(orders) AS total_order
FROM diwali_sales
GROUP BY state, product_category
),

ranking AS (
SELECT state, product_category, total_order, 
       RANK() OVER(PARTITION BY State ORDER BY total_order DESC) AS rank
FROM popular_category
)
-- select * from ranking
SELECT state, product_category, total_order
FROM ranking
WHERE rank = 1

7. Calculate the total number of orders made by married vs. unmarried customers.

SELECT CASE WHEN marital_status = 0 THEN 'unmarried'
       WHEN marital_status = 1 THEN 'married' END AS marital_status,
       SUM(orders) AS total_num_of_orders
FROM diwali_sales
GROUP BY marital_status

8. List the customers who have placed orders in more than 3 different zones.

SELECT cust_name, COUNT(DISTINCT zone) AS no_of_zones
FROM diwali_sales
GROUP BY cust_name
HAVING COUNT(DISTINCT zone) > 3
ORDER BY no_of_zones DESC

9. Calculate the average order amount for male and female customers.

SELECT CASE WHEN gender = 'M' THEN 'Male'
       WHEN gender = 'F' THEN 'Female' END AS gender,
	   ROUND(AVG(amount), 2) AS avg_amount
FROM diwali_sales
GROUP BY gender

10. Identify the product categories with the highest sales amount for each age group.

WITH age_group_category AS (
SELECT age_group, product_category, MAX(amount) AS highest_sales_amount
FROM diwali_sales
GROUP BY age_group, product_category
),

ranking AS (
SELECT age_group, product_category, highest_sales_amount,
       RANK() OVER(PARTITION BY age_group ORDER BY highest_sales_amount) AS rank
FROM age_group_category
)

SELECT age_group, product_category, highest_sales_amount
FROM ranking
WHERE rank = 1

11. Find the state with the highest average order amount.

SELECT state, ROUND(AVG(amount), 2) AS avg_amount
FROM diwali_sales
GROUP BY state
ORDER BY avg_amount
LIMIT 3

12. Calculate the cumulative sales amount for each zone. 

SELECT zone, SUM(amount) OVER(PARTITION BY zone ORDER BY zone ROWS BETWEEN 2 PRECEDING and CURRENT ROW) AS cumulative_amount
FROM diwali_sales
GROUP BY zone, amount
-- this cumulative sum is of around 9543 rows

13. List the top 3 product categories based on the number of orders.

SELECT product_category, COUNT(orders) AS no_of_orders
FROM diwali_sales
GROUP BY product_category
ORDER BY no_of_orders DESC
LIMIT 3

14. Identify the states where the average order amount is greater than the overall average.

SELECT state, ROUND(AVG(amount), 2) AS avg_amount
FROM diwali_sales
GROUP BY state
HAVING ROUND(AVG(amount), 2) > (SELECT ROUND(AVG(amount), 2) AS overall_avg FROM diwali_sales)
ORDER BY avg_amount DESC

15. Calculate the year-over-year growth in the number of unique customers for each state.
-- there is no date column so its not possible

16. List the top 5 customers based on the total amount spent.

SELECT cust_name, SUM(amount) AS total_amount_spent
FROM diwali_sales
GROUP BY cust_name
ORDER BY total_amount_spent DESC
LIMIT 5

17. Find the zone with the highest total sales amount and the lowest total sales amount.

WITH zone_sales AS (
SELECT zone, SUM(amount) AS total_sales_amount
FROM diwali_sales
GROUP BY zone
)

SELECT zone, total_sales_amount
FROM zone_sales
WHERE total_sales_amount = (SELECT MAX(total_sales_amount) FROM zone_sales)
      OR
	  total_sales_amount = (SELECT MIN(total_sales_amount) FROM zone_sales)
-- here first min value is represented then the max value.


18. List the top 5 products id in each product category based on the total sales amount.

WITH productid_category_sales AS (
SELECT product_id, product_category, SUM(amount) AS total_sales_amount
FROM diwali_sales
GROUP BY product_id, product_category
),
ranking AS (
SELECT product_id, product_category, total_sales_amount,
       RANK() OVER(PARTITION BY product_category ORDER BY total_sales_amount DESC) AS rank
FROM productid_category_sales
)

SELECT product_category, product_id, total_sales_amount
FROM ranking
WHERE rank <= 5 AND total_sales_amount IS NOT NULL
ORDER BY product_category, rank





select * from diwali_sales
