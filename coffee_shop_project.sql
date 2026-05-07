create database coffee_shop_sales_db;
select * from coffee_shop_sales;
describe coffee_shop_sales;

select transaction_date, 
 str_to_date(transaction_date, '%d/%m/%Y')
from coffee_shop_sales ;

alter table coffee_shop_sales
modify transaction_date date;
  
alter table coffee_shop_sales
modify transaction_time time;
  
-- checking the datatypes
describe coffee_shop_sales;

select min(transaction_id),
max(transaction_id),count(*) 
from coffee_shop_sales;

update coffee_shop_sales
set transaction_date = str_to_date(transaction_date, '%d-%m-%Y');

    -- TOTAL SALES
SELECT ROUND(SUM(unit_price * transaction_qty)) as Total_Sales 
FROM coffee_shop_sales 
WHERE MONTH(transaction_date) = 5 ; -- for month of (CM-May)


-- TOTAL SALES KPI - MOM DIFFERENCE AND MOM GROWTH
SELECT 
    MONTH(transaction_date) AS month,
    ROUND(SUM(unit_price * transaction_qty)) AS total_sales,
    (SUM(unit_price * transaction_qty) - LAG(SUM(unit_price * transaction_qty), 1)
    OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(unit_price * transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (4, 5) -- for months of April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);
    
    SELECT COUNT(transaction_id) as Total_Orders
FROM coffee_shop_sales 
WHERE MONTH (transaction_date)= 5; -- for month of (CM-May)

SELECT 
    MONTH(transaction_date) AS month,
    ROUND(COUNT(transaction_id)) AS total_orders,
    (COUNT(transaction_id) - LAG(COUNT(transaction_id), 1) 
    OVER (ORDER BY MONTH(transaction_date))) / LAG(COUNT(transaction_id), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (4, 5) -- for April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);
    
    SELECT SUM(transaction_qty) as Total_Quantity_Sold
FROM coffee_shop_sales 
WHERE MONTH(transaction_date) = 5; -- for month of (CM-May)

SELECT 
    MONTH(transaction_date) AS month,
    ROUND(SUM(transaction_qty)) AS total_quantity_sold,
    (SUM(transaction_qty) - LAG(SUM(transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_increase_percentage
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) IN (4, 5)   -- for April and May
GROUP BY 
    MONTH(transaction_date)
ORDER BY 
    MONTH(transaction_date);
    
    SELECT
    SUM(unit_price * transaction_qty) AS total_sales,
    SUM(transaction_qty) AS total_quantity_sold,
    COUNT(transaction_id) AS total_orders
FROM 
    coffee_shop_sales
WHERE 
    transaction_date = '2023-05-18'; -- For 18 May 2023
    
    SELECT 
    CONCAT(ROUND(SUM(unit_price * transaction_qty) / 1000, 1),'K') AS total_sales,
    CONCAT(ROUND(COUNT(transaction_id) / 1000, 1),'K') AS total_orders,
    CONCAT(ROUND(SUM(transaction_qty) / 1000, 1),'K') AS total_quantity_sold
FROM 
    coffee_shop_sales
WHERE 
    transaction_date = '2023-05-18'; -- For 18 May 2023
    
    SELECT AVG(total_sales) AS average_sales
FROM (
    SELECT 
        SUM(unit_price * transaction_qty) AS total_sales
    FROM 
        coffee_shop_sales
	WHERE 
        MONTH(transaction_date) = 5  -- Filter for May
    GROUP BY 
        transaction_date
) AS internal_query;

SELECT 
    DAY(transaction_date) AS day_of_month,
    ROUND(SUM(unit_price * transaction_qty),1) AS total_sales
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) = 5  -- Filter for May
GROUP BY 
    DAY(transaction_date)
ORDER BY 
    DAY(transaction_date);
    
    SELECT 
    CASE 
        WHEN DAYOFWEEK(transaction_date) IN (1, 7) THEN 'Weekends'
        ELSE 'Weekdays'
    END AS day_type,
    ROUND(SUM(unit_price * transaction_qty),2) AS total_sales
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) = 5  -- Filter for May
GROUP BY 
    CASE 
        WHEN DAYOFWEEK(transaction_date) IN (1, 7) THEN 'Weekends'
        ELSE 'Weekdays'
    END;
    
    
    SELECT 
	store_location,
	SUM(unit_price * transaction_qty) as Total_Sales
FROM coffee_shop_sales
WHERE
	MONTH(transaction_date) =5 
GROUP BY store_location
ORDER BY 	SUM(unit_price * transaction_qty) DESC;

SELECT 
	product_category,
	ROUND(SUM(unit_price * transaction_qty),1) as Total_Sales
FROM coffee_shop_sales
WHERE
	MONTH(transaction_date) = 5 
GROUP BY product_category
ORDER BY SUM(unit_price * transaction_qty) DESC;

SELECT 
	product_type,
	ROUND(SUM(unit_price * transaction_qty),1) as Total_Sales
FROM coffee_shop_sales
WHERE
	MONTH(transaction_date) = 5 
GROUP BY product_type
ORDER BY SUM(unit_price * transaction_qty) DESC
LIMIT 10;

SELECT 
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales,
    SUM(transaction_qty) AS Total_Quantity,
    COUNT(*) AS Total_Orders
FROM 
    coffee_shop_sales
WHERE 
    DAYOFWEEK(transaction_date) = 3 -- Filter for Tuesday (1 is Sunday, 2 is Monday, ..., 7 is Saturday)
    AND HOUR(transaction_time) = 8 -- Filter for hour number 8
    AND MONTH(transaction_date) = 5; -- Filter for May (month number 5) 
    
   --  TO GET SALES FROM MONDAY TO SUNDAY FOR MONTH OF MAY
SELECT 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END AS Day_of_Week,
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) = 5 -- Filter for May (month number 5)
GROUP BY 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END;
    
    SELECT 
    HOUR(transaction_time) AS Hour_of_Day,
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM 
    coffee_shop_sales
WHERE 
    MONTH(transaction_date) = 5 -- Filter for May (month number 5)
GROUP BY 
    HOUR(transaction_time)
ORDER BY 
    HOUR(transaction_time);
    select * from coffee_shop_project;
    
    
