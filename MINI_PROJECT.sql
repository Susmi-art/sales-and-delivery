CREATE DATABASE sales_delivery;
USE sales_delivery;

-- --Question 1: Find the top 3 customers who have the maximum number of orders
SELECT * FROM cust_dimen;
SELECT * FROM market_fact;
SELECT 
      c.Customer_Name,
      c.Cust_id,
      COUNT(m.Ord_id) AS order_count
FROM 
     cust_dimen c
JOIN
      market_fact m ON c.Cust_id = m.Cust_id
GROUP BY 
      c.Customer_Name,c.Cust_id
ORDER BY 
	 order_count DESC
LIMIT 3;


-- --Question 2: Create a new column DaysTakenForDelivery that contains the date difference between Order_Date and Ship_Date.
SELECT * FROM orders_dimen;
SELECT * FROM shipping_dimen;
SELECT 
      O.Order_ID,
      O.Order_Date,
      S.Ship_Date,
      DATEDIFF(s.Ship_Date,o.Order_Date) AS DaysTakenForDelivery
FROM 
      orders_dimen AS O
JOIN 
      shipping_dimen AS S ON o.Order_ID = s.Order_ID;
-- --Question 3: Find the customer whose order took the maximum time to get delivered.
SELECT * FROM cust_dimen;
SELECT * FROM orders_dimen;
SELECT * FROM shipping_dimen;
SELECT 
      c.Customer_Name,
      o.Order_ID,DATEDIFF(s.Ship_Date,o.Order_Date) AS DaysTakenForDelivery
FROM 
      cust_dimen as c 
JOIN 
	market_fact AS m ON c.Cust_id = m.Cust_id
JOIN
     orders_dimen AS o ON m.Ord_id=o.Ord_id
JOIN 
     shipping_dimen AS s ON o.Order_ID = s.Order_ID
ORDER BY 
     DaysTakenForDelivery DESC LIMIT 1;
-- --Question 4: Retrieve total sales made by each product from the data (use Windows function)
SELECT * FROM market_fact;
SELECT 
     Prod_id,SUM(Sales) OVER (PARTITION BY Prod_id ) AS total_sales
FROM 
     market_fact;
-- --Question 5: Retrieve the total profit made from each product from the data (use windows function)
SELECT * FROM market_fact;
SELECT
    Prod_id,
    SUM(Profit) OVER (PARTITION BY Prod_id ) AS total_profit
FROM
    market_fact;
-- --Question 6: Count the total number of unique customers in January and how many of them came back every month over the entire year in 2011
-- Count the total number of unique customers in January 2011

SELECT COUNT(DISTINCT cd.Customer_Name) AS UniqueCustomersInJanuary
FROM cust_dimen AS cd
JOIN market_fact AS mf ON cd.Cust_id = mf.Cust_id
JOIN orders_dimen AS od ON mf.Ord_id = od.Order_ID
WHERE EXTRACT(YEAR FROM od.Order_Date) = 2011
  AND EXTRACT(MONTH FROM od.Order_Date) = 1;

-- Count the number of customers who came back every month over the entire year in 2011
WITH MonthlyCustomerCounts AS (
  SELECT
    cd.Customer_Name,
    EXTRACT(YEAR FROM od.Order_Date) AS OrderYear,
    EXTRACT(MONTH FROM od.Order_Date) AS OrderMonth,
    COUNT(DISTINCT od.Order_ID) AS NumOrders
  FROM Cust_dimen AS cd
  JOIN market_fact AS mf ON cd.Cust_id = mf.Cust_id
  JOIN orders_dimen AS od ON mf.Ord_id = od.Order_ID
  WHERE EXTRACT(YEAR FROM od.Order_Date) = 2011
  GROUP BY cd.Customer_Name, OrderYear, OrderMonth
)
SELECT COUNT(Customer_name) AS CustomersCameBackEveryMonth
FROM MonthlyCustomerCounts
WHERE OrderYear = 2011
GROUP BY Customer_Name
HAVING COUNT(*) = 12; -- 12 months in a year



