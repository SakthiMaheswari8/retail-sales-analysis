-- CREATING DB --
create database project_retail_sales_analysis;
USE project_retail_sales_analysis;

-- CREATING_TABLE--
create table sales_analysis(
					transactions_id	int,
					sale_date date,	
					sale_time time,	
					customer_id	int,
					gender	varchar(50),
					age	int,
					category varchar(50),	
					quantiy	int,
					price_per_unit	float,
					cogs	float,
					total_sale float
);
select*from sales_analysis;
SHOW TABLES;

-- to check the table is imported properly --- 
SELECT *
FROM sales_analysis
LIMIT 10;

-- count --
SELECT COUNT(*) FROM sales_analysis;

-- data_cleaning --
select*from sales_analysis where
	transactions_id	is null
	or
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	age is null
	or
	category  is null
	or	
	quantiy	is null
	or 
	price_per_unit is null	
	or 
	cogs is null
	or
	total_sale is null ;
delete from sales_analysis 
	where
	transactions_id	is null
	or
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	age is null
	or
	category  is null
	or	
	quantiy	is null
	or 
	price_per_unit is null	
	or 
	cogs is null
	or
	total_sale is null ;
    
-- data exploration --
-- 1. how many sale we have? --
select count(*) from sales_analysis;
-- 2. how many unique customers we have? --
select count( distinct customer_id) as total_customers from sales_analysis; 
-- 3. what are the categories that we have? --
select distinct category from sales_analysis;

-- DATA ANALYSIS AND BUSINESS KEY PROBLEMS --
-- 1. retrive all columns for sales made on '2022-11-05' --
select*from sales_analysis where sale_date = '2022-11-05';

-- 2. retrive all transactions where category is "clothing" and the quantity sold is more than 2 in the month of nov-2022 --
select*from sales_analysis where 
	category='clothing' and 
	quantiy>=2 and 
	sale_date between '2022-11-01' and '2022-11-30';

-- 3. calculate the total sales for each category --
select 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
from sales_analysis
group by 1;

-- 4. all transactions where total sale is greater than 1000 --
select * from sales_analysis where total_sale>1000;

-- 5.total number of transactions made by each gender in each category --
select 
gender,category ,
 count(transactions_id) as total_transaction
 from sales_analysis
 group by 1,2
order by 1;

-- 6. customer who made more than 5 purchases --
SELECT
    customer_id,
    COUNT(transactions_id) AS total_purchases
FROM sales_analysis
GROUP BY customer_id
HAVING COUNT(transactions_id) > 5;

-- 7. highest single transaction --
select max(total_sale) from sales_analysis ;
-- with full details --
select *
from sales_analysis
where total_sale = (
    select MAX(total_sale)
    from sales_analysis
);

-- 8. top 5 customer based on highest total sale --
select customer_id,
       sum(total_sale) as total_revenue
from sales_analysis
group by customer_id
order by total_revenue desc
limit 5;

-- 9. to find avg age  of customer who purchased items from a 'beauty' category --
select round(avg(age),2) from sales_analysis where category='beauty';

-- 10.  analyze customer purchases across different age groups for each product category --
select
    category,
    case
        when age < 20 then 'below 20'
        when age between 20 and 29 then '20-29'
        when age between 30 and 39 then '30-39'
        else '40+'
    end as age_group,
    count(*) as total_purchases
from sales_analysis
group by category, age_group
order by category, total_purchases desc;

-- 11.count unique customer who purchased item from each category --
select category,count(distinct(customer_id)) as unique_customer  from sales_analysis group by 1;

-- 12.which category generated highest revenue --
select category,
sum(total_sale) as category_wise_total_sale 
from sales_analysis 
group by 1 
order by category_wise_total_sale desc 
limit 1;

-- 13. what is the average order value for each category --
select category, 
round(avg(total_sale),2) as avg_sale_of_each_category
from sales_analysis
group by 1;

-- 14.average amount spent by male and female customers across each product category. --
select category, gender,
round(avg(total_sale),2) as avg_sale_of_each_category
from sales_analysis
group by category, gender
order by gender;

-- 15.total sales revenue generated in each month --
select
    monthname(sale_date) as month_name,
    sum(total_sale) as total_sales
from sales_analysis
group by month(sale_date), monthname(sale_date)
order by month(sale_date);


