-- DATA ANALYSIS
--Tables
update [dbo].[prod_dimen]
set Prod_id= 'Prod_16' where Prod_id = ' RULERS AND TRIMMERS,Prod_16'
select *
from [dbo].[prod_dimen]

UPDATE [dbo].[shipping_dimen] SET Ship_Date = CONVERT(DATE, Ship_Date, 105);
ALTER TABLE [dbo].[shipping_dimen]
ALTER COLUMN ship_Date DATE NOT NULL;

--1. Join all the tables and create a new table called combined_table. (market_fact, cust_dimen, orders_dimen, prod_dimen, shipping_dimen)
select *
into combined_table
from
(
select
cd.Cust_id, cd.Customer_Name, cd.Province, cd.Region, cd.Customer_Segment, mf.Ord_id,
mf.Prod_id, mf.Sales, mf.Discount, mf.Order_Quantity, mf.Profit, mf.Shipping_Cost, mf.Product_Base_Margin,
od.Order_Date, od.Order_Priority,
pd.Product_Category, pd.Product_Sub_Category,
sd.Ship_id, sd.Ship_Mode, sd.Ship_Date
from
market_fact mf
inner join
cust_dimen cd on mf.cust_id= cd.Cust_id
inner join
orders_dimen od on mf.Ord_id= od.Ord_id
inner join
prod_dimen pd on mf.Prod_id=pd.Prod_id
inner join
shipping_dimen sd on mf.Ship_id=sd.Ship_id
) a
select *
from
combined_table
--2. Find the top 3 customers who have the maximum count of orders.
select top 3 cust_id, Customer_Name, count (distinct Ord_id) num_ord
from
combined_table
group by
cust_id, Customer_Name
order by
num_ord desc
--3. Create a new column at combined_table as DaysTakenForDelivery that contains the date difference of Order_Date and Ship_Date.

update combined_table
set [DaysTakenForDelivery]= datediff(day, order_date, Ship_Date)
select cust_id, order_date, Ship_Date, [DaysTakenForDelivery]
from
combined_table


--4. Find the customer whose order took the maximum time to get delivered.
select cust_id, customer_name, order_date, Ship_Date, DaysTakenForDelivery
from
combined_table
where
DaysTakenForDelivery =
						(
						select max(DaysTakenForDelivery)
						from
						combined_table)


select cust_id, count_in_month, convert(date, [Month] + '-1') month_date
from
(
select cust_id, SUBSTRING(cast(order_date as varchar), 1,7) as [Month], count (*) count_in_month
from
combined_table
group by
cust_id, SUBSTRING(cast(order_date as varchar), 1,7)
) a						)