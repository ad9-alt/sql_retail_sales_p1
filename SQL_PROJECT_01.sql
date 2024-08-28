USE SQL_Project_P1

-- CREATE TABLE
create table retail_sales(
	transactions_id	int PRIMARY KEY,
	sale_date Date,
	sale_time Time,
	customer_id	int,
	gender VARCHAR(15),
	age	int,
	category VARCHAR(15),	
	quantiy	int,
	price_per_unit Float,	
	cogs Float,
	total_sale Float
	)

select * from retail_sales

select count(*) from retail_sales


-- check null values
select * from retail_sales
where transactions_id is null
	or sale_date is null
	or sale_time is null
	or customer_id is null
	or gender is null
	or age is null
	or category is null
	or quantiy is null
	or price_per_unit is null
	or cogs is null
	or total_sale is null;

Delete from retail_sales
where transactions_id is null
	or sale_date is null
	or sale_time is null
	or customer_id is null
	or gender is null
	or age is null
	or category is null
	or quantiy is null
	or price_per_unit is null
	or cogs is null
	or total_sale is null;



-- Data Exploration

--How many sales we have ?
Select count(*) as total_sale 
from retail_sales 

--How many customers we have ?
Select count(Distinct customer_id) as Unique_customers
from retail_sales 

Select Distinct category as Categories
from retail_sales 


-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'

select * from retail_sales
where sale_date = '2022-11-05'

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' 
--     and the quantity sold is more than 10 in the month of Nov-2022

SELECT *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    FORMAT(sale_date, 'yyyy-MM') = '2022-11'
    AND
    quantiy >= 4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select category,
sum(total_sale) as total_sale 
from retail_sales
group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select round(avg(age),2) as Average_age_cust
from retail_sales
where category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail_sales
where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select gender ,category,
count(transactions_id) as ttl_transac 
from retail_sales
group by category,gender
order by category

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select 
yearx
monthx,
round(average_sales,2) as avg_sales
from
(
SELECT 
    YEAR(sale_date) AS yearx,
    MONTH(sale_date) AS monthx,
    AVG(total_sale) AS average_sales,
	Rank()over(PARTITION BY  YEAR(sale_date) ORDER BY AVG(total_sale)DESC) as Rnk
FROM 
    retail_sales
GROUP BY 
    YEAR(sale_date),
    MONTH(sale_date)
)as t1
where rnk = 1

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 


select TOP 5 customer_id,
sum(total_sale) as total_sales
from retail_sales
group by customer_id
order by total_sales DESC

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select count(distinct customer_id) as cnt,category
from retail_sales
GROUP BY category
order by cnt DESC

-- Q.10 Write a SQL query to create each shift and number of orders
--      (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH h_sales AS (
    SELECT *,
        CASE
            WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
            WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Night'
        END AS SHIFT
    FROM retail_sales
)
SELECT 
    SHIFT,
    COUNT(*) AS number_of_orders
FROM 
    h_sales
GROUP BY 
    SHIFT;


--END OF THE PROJECT
