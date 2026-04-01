create database appleretailsales

use  appleretailsales


select * from category
select * from products
select * from sales
select * from stores
select * from warrenty

select distinct repair_status from warrenty

select count(*) from sales

-- Find the number of stores in each country
select country,count(store_id)  as total_stores from stores
group by country
order by total_stores desc


-- calculate the total number of units sold by each store
SELECT 
    s.store_id,
    st.store_name,
    SUM(s.quantity) AS total_unit_sold
FROM sales s
JOIN stores st 
    ON s.store_id = s.store_id 
GROUP BY 
    s.store_id, 
    st.store_name
ORDER BY total_unit_sold DESC;

-- Identify how many sales occurred in December 2023

SELECT *, FORMAT(sale_date, 'MM-yyyy') AS formatted_date
FROM sales
WHERE FORMAT(sale_date, 'MM-yyyy') = '12-2023';


SELECT COUNT(sale_id) AS total_sale
FROM sales 
WHERE 
    YEAR(sale_date) = 2023
    AND MONTH(sale_date) = 12;


-- calculate the percentage of completed from warranty

select * from warrenty
select distinct repair_status from warrenty

select 
    count(case when repair_status = 'completed' then 1 end) * 100.0
	/ count(*) as completed_percentage
from warrenty


-- Identify which store had the highest total units sold in the last year.

SELECT 
    s.store_id,
	st.store_name,
	SUM(s.quantity) AS max_quantity
FROM sales as s 
join stores as st 
on s.store_id = st.Store_ID
WHERE sale_date >= DATEADD(YEAR, -1, (SELECT MAX(sale_date) FROM sales))
GROUP BY s.store_id,st.store_name
ORDER BY max_quantity DESC


-- Count the number of unique products sold in the last year
select count( distinct product_id) from sales 
where sale_date >= DATEADD(YEAR, -1, (SELECT MAX(sale_date) FROM sales))

-- find the average price of product each category 

select p. category_id, c.category_name,
AVG(p.price) as avg_price 
from products as p join category as c
on p.Category_ID = c.category_id
group by p.category_id,c.category_name
order by avg_price desc

-- how many warranty claim were filled in 2024

select count(*) as total_claims_2024
from warrenty 
where year(claim_date) = 2024

-- For each store, identify the best-selling day based on highest quantity sold
select * from (
select store_id,
     datename(weekday , sale_date ) as day_name ,
	 sum(quantity) as total_units_sold,
	 rank () over (partition by store_id order by sum(quantity) desc ) as rnk 
from sales
group by store_id , datename(weekday , sale_date )
)t
where rnk = 1


-- Identify the least selling product in each country for each year based on total units sold
with product_rank 
as (
select st.country,
       p.Product_Name,
	   sum(s.quantity) as total_qty_sold,
	   rank() over(partition by st.country order by sum(s.quantity)) as rank 
from sales as s join stores as st 
on s.store_id = st.store_id
join products as p 
on s.product_id = p.product_id
group by st.Country ,p.product_name 
)

select * from product_rank
where rank = 1

-- Calculate how many warranty claims were filed within 180 days of a product sale.

SELECT 
    w.*,
    s.sale_date,
    DATEDIFF(DAY, s.sale_date, w.claim_date) AS days_diff
FROM warrenty AS w 
LEFT JOIN sales AS s 
    ON s.sale_id = w.sale_id
WHERE 
    DATEDIFF(DAY, s.sale_date, w.claim_date) <= 180


SELECT 
  count(*)
FROM warrenty AS w 
LEFT JOIN sales AS s 
    ON s.sale_id = w.sale_id
WHERE 
    DATEDIFF(DAY, s.sale_date, w.claim_date) <= 180

-- total count of warranty claims were filed within 180 days of a product sale is 5760

-- Identify the product category with the most warranty claims filed in the last two years.

SELECT 
    c.category_name,
    COUNT(w.claim_id) AS total_claim
FROM warrenty w
LEFT JOIN sales s 
    ON w.sale_id = s.sale_id
JOIN products p 
    ON p.product_id = s.product_id
JOIN category c 
    ON c.category_id = p.category_id
WHERE 
    w.claim_date >= DATEADD(YEAR, -2, (SELECT MAX(claim_date) FROM warrenty))
GROUP BY 
    c.category_name
ORDER BY 
    total_claim DESC;


--Calculate the correlation between product price and warranty claims for products sold in the last five years, segmented by price range.

SELECT  
    CASE 
        WHEN p.price < 500 THEN 'less expense product'
        WHEN p.price BETWEEN 500 AND 1000 THEN 'mid range product'
        ELSE 'expensive'
    END AS price_segment,

    COUNT(w.claim_id) AS total_claim

FROM warrenty AS w 
LEFT JOIN sales AS s 
    ON w.sale_id = s.sale_id 
JOIN products AS p 
    ON p.product_id = s.product_id

WHERE 
    w.claim_date >= DATEADD(YEAR, -5, (SELECT MAX(claim_date) FROM warrenty))

GROUP BY  
    CASE 
        WHEN p.price < 500 THEN 'less expense product'
        WHEN p.price BETWEEN 500 AND 1000 THEN 'mid range product'
        ELSE 'expensive'
    END;

-- Write a query to calculate the monthly running total of sales for each store over the past four years and compare trends during this period.


SELECT 
    p.product_name,

    CASE 
        WHEN s.sale_date >= p.launch_date 
             AND s.sale_date < DATEADD(MONTH, 6, p.launch_date) 
        THEN '0-6 month'

        WHEN s.sale_date >= DATEADD(MONTH, 6, p.launch_date) 
             AND s.sale_date < DATEADD(MONTH, 12, p.launch_date) 
        THEN '6-12 month'

        WHEN s.sale_date >= DATEADD(MONTH, 12, p.launch_date) 
             AND s.sale_date < DATEADD(MONTH, 18, p.launch_date) 
        THEN '12-18 month'

        ELSE '18+'
    END AS plc,

    SUM(s.quantity) AS total_qty_sale

FROM sales AS s
JOIN products AS p 
    ON s.product_id = p.product_id

GROUP BY 
    p.product_name,
    CASE 
        WHEN s.sale_date >= p.launch_date 
             AND s.sale_date < DATEADD(MONTH, 6, p.launch_date) 
        THEN '0-6 month'

        WHEN s.sale_date >= DATEADD(MONTH, 6, p.launch_date) 
             AND s.sale_date < DATEADD(MONTH, 12, p.launch_date) 
        THEN '6-12 month'

        WHEN s.sale_date >= DATEADD(MONTH, 12, p.launch_date) 
             AND s.sale_date < DATEADD(MONTH, 18, p.launch_date) 
        THEN '12-18 month'

        ELSE '18+'
    END

ORDER BY 
    p.product_name,
    total_qty_sale DESC;








