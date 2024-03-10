
alter table dbo.[WalmartSalesData.csv]
add time_of_day as(case 
when try_cast(substring(try_cast(Time as nvarchar),11,19) as time) between '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN try_cast(substring(try_cast(Time as nvarchar),11,19) as time) BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
		end)

select *
from dbo.[WalmartSalesData.csv]


alter table dbo.[WalmartSalesData.csv]
add day_name as(DAteNAME(weekday,Date))

alter table dbo.[WalmartSalesData.csv]
add month_name as(DAteNAME(month,Date))
-- Generic Question
-------------------
--1. How many unique cities does the data have?
select count(distinct City) as number_of_cities
from dbo.[WalmartSalesData.csv]

--2. In which city is each branch?
select distinct(City),Branch
from dbo.[WalmartSalesData.csv]

-- Product
----------
--1. How many unique product lines does the data have?
select count(distinct(Product_line)) as No_of_Product_lines
from dbo.[WalmartSalesData.csv]
--2. What is the most common payment method?
select top 1
Payment,count(Payment) as no_of_trasnsactions
from dbo.[WalmartSalesData.csv]
group by Payment
order by no_of_trasnsactions Desc

--3. What is the most selling product line?
select top 1
Product_line,sum(Total) as Revenue_generated
from dbo.[WalmartSalesData.csv]
group  by Product_line
order by Revenue_generated
--4. What is the total revenue by month?
select month_name,sum(Total) as Revenue
from dbo.[WalmartSalesData.csv]
group by month_name
--5. What month had the largest COGS?
select top 1
month_name,sum(cogs) as Cogs
from dbo.[WalmartSalesData.csv]
group by month_name
order by Cogs desc

--6. What is the city with the largest revenue?
select top 1
City,sum(Total) as total_revenue
from dbo.[WalmartSalesData.csv]
group by City
order by total_revenue


--6. What product line had the largest VAT?
select top 1
Product_line,sum(Tax_5) as VAT
from dbo.[WalmartSalesData.csv]
group  by Product_line
order by VAT

--7. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
select Product_line,(case
when avg_sales_of_Product_line > (select avg(Total)from dbo.[WalmartSalesData.csv]) then 'good'
else 'bad'
end)as Sales_are_good_or_bad
from
(select Product_line,avg(Total) as avg_sales_of_Product_line
from dbo.[WalmartSalesData.csv]
group by Product_line) as t1

--8. Which branch sold more products than average product sold?
select Branch, sum(try_cast(quantity as int)) as no_product_sold
from dbo.[WalmartSalesData.csv]
group by Branch
having  sum(try_cast(quantity as int)) >=
(select avg(product_sold)
from
(select Branch, sum(try_cast(quantity as int)) as product_sold
from dbo.[WalmartSalesData.csv]
group by Branch) as t2)
--9. What is the most common product line by gender?
select Gender,Product_line,count(Product_line) as total_count
from dbo.[WalmartSalesData.csv]
group by Gender,Product_line

--10. What is the average rating of each product line?
select Product_line,round(avg(Rating),3) as avg_rating
from dbo.[WalmartSalesData.csv]
group by Product_line

--### Sales
-----------
--1. Number of sales made in each time of the day per weekday
select day_name as week_day,time_of_day,sum(Total) as sales
from dbo.[WalmartSalesData.csv]
group by day_name,time_of_day
order by day_name,time_of_day

--2. Which of the customer types brings the most revenue?
select top 1
Customer_type,sum(Total) as revenue
from dbo.[WalmartSalesData.csv]
group by Customer_type
order by revenue desc

--3. Which city has the largest tax percent/ VAT (**Value Added Tax**)?
select top 1
City,sum(Tax_5) as VAT
from dbo.[WalmartSalesData.csv]
group by City
order by VAT desc

--4. Which customer type pays the most in VAT?
select top 1
Customer_type,sum(Tax_5) as VAT
from dbo.[WalmartSalesData.csv]
group by Customer_type
order by VAT desc

--### Customer
---------------
--1. How many unique customer types does the data have?
select count(distinct Customer_type) as unique_customer_type
from dbo.[WalmartSalesData.csv]
--2. How many unique payment methods does the data have?
select count(distinct Payment) as unique_payment_type
from dbo.[WalmartSalesData.csv]
--3. What is the most common customer type?
select top 1
Customer_type,count(*) as count_of_customers
from dbo.[WalmartSalesData.csv]
group by Customer_type
order by count_of_customers desc
--4. Which customer type buys the most?
select top 1
Customer_type,sum(Total) as Revenue_generated
from dbo.[WalmartSalesData.csv]
group by Customer_type
order by Revenue_generated desc
--5. What is the gender of most of the customers?
select top 1
Gender,COUNT(*) as count_of_customers
from dbo.[WalmartSalesData.csv]
group by Gender
order by count_of_customers desc
--6. What is the gender distribution per branch?
select Branch,gender,count(gender) as count_of_gender
from dbo.[WalmartSalesData.csv]
group by Branch,Gender
order by Branch,Gender
--7. Which time of the day do customers give most ratings?
select top 1
time_of_day,avg(Rating) as avg_rating
from dbo.[WalmartSalesData.csv]
group by time_of_day
order by avg_rating desc

--8. Which day of the week has the best avg ratings?
select top 1
day_name,avg(Rating) as avg_rating
from dbo.[WalmartSalesData.csv]
group by day_name
order by avg_rating desc














		