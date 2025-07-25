drop table if exists zepto;

create table zepto(
	sku_id SERIAL PRIMARY KEY,
	category VARCHAR(120),
	name VARCHAR(150) NOT NULL,
	mrp NUMERIC(8,2),
	discountPercent NUMERIC(5,2), 
	availableQuantity INTEGER,
	discountedSellingPrice NUMERIC(8,2),
	weightInGms INTEGER,
	outOfStock BOOLEAN,
	quantity INTEGER
	);

-- data exploration
 SELECT COUNT(*) FROM zepto;

-- sample data
SELECT * FROM zepto;

--null values
SELECT * FROM zepto
WHERE  
name is NULL
OR
category is NULL
OR
mrp is NULL
OR
discountPercent is NULL
OR
availableQuantity is NULL
OR
discountedSellingPrice is NULL
OR
weightInGns is NULL
OR
availableQuantity is NULL
OR
outOfStock is NULL
OR
quantity is NULL

--Different product categories

SELECT DISTINCT category
FROM zepto
ORDER BY category;

--products in stock and procucts out of stock

SELECT outOfStock, COUNT (sku_id)
FROM zepto
GROUP BY outOfStock;

--repeated product names

SELECT name, COUNT(sku_id) as "number of SKUs"
FROM zepto
GROUP BY name
HAVING count(sku_id) > 1
ORDER BY count(sku_id) DESC;

--data cleaning

--product price=0
SELECT * FROM zepto
WHERE mrp=0 OR discountedSellingPrice = 0;

DELETE FROM zepto WHERE mrp=0;

--convert pise to rs

UPDATE zepto
SET mrp=mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

SELECT mrp,discountedSellingPrice FROM zepto

--Q1. Find the top 10 best-value products based on the discount percentage.
select distinct name, mrp, discountedSellingPrice, discountPercent
from zepto
order by discountPercent desc;

--Q2.What are the Products with High MRP but Out of Stock
select distinct name, mrp
from zepto
where outOfStock = true and mrp>300
order by mrp desc;

--Q3.Calculate Estimated Revenue for each category
select category, 
sum (discountedSellingPrice * availableQuantity) as total_revenue
from zepto
group by category
order by total_revenue desc

--Q4. Find all products where MRP is greater than 500 and discount is less than 10%.
select name, mrp, discountPercent
from zepto
where mrp >500 and discountPercent < 10
order by mrp DESc, discountPercent desc ;

--Q5. Identify the top 5 categories offering the highest average discount percentage.
select category,
(avg(discountPercent),2) as avg_discount
from zepto
group by category
order by avg_discount desc
limit 5;

--Q6. Find the price per gram for products above 100g and sort by best value.
select distinct 
name, 
weightingns, 
discountedsellingprice,
ROUND(discountedSellingPrice / weightInGns, 2) as price_per_gms
from zepto
where  weightingns >= 100
order by price_per_gms ; 

--Q7. group products into categories like Low, Medium, Bulk based on weight in grams.
select distinct 
name, weightingns,
case 
	when weightingns < 1000 then 'low'
	when weightingns < 5000 then 'medium'
	else 'bulk'
	end as weight_category
from zepto;
 

--Q8. what is the total inventory weight per category
select category, sum(weightingns * availableQuantity ) as total_weight
from zepto
group by category
order by total_weight desc;

