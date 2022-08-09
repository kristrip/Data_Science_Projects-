-- Ques | What are the top 3 products by total revenue before discount?

with cte as (select prod_id,sum(qty*price) as revenue from sales
 group by prod_id order by revenue desc limit 3)
 select 
 revenue,prod_id,product_name
 from cte c left join product_details d
 on c.prod_id = d.product_id;
 
 ELECT 
	details.product_name,
	SUM(sales.qty * sales.price) AS nodis_revenue
FROM balanced_tree.sales AS sales
INNER JOIN balanced_tree.product_details AS details
	ON sales.prod_id = details.product_id
GROUP BY details.product_name
ORDER BY nodis_revenue DESC
LIMIT 3;

-- Ques |What is the total quantity, revenue and discount for each segment?


SELECT 
	details.segment_id,
	details.segment_name,
	SUM(sales.qty) AS total_quantity,
	SUM(sales.qty * sales.price) AS total_revenue,
	SUM(sales.qty * sales.price * sales.discount)/100 AS total_discount
FROM balanced_tree.sales AS sales
INNER JOIN balanced_tree.product_details AS details
	ON sales.prod_id = details.product_id
GROUP BY 
	details.segment_id,
	details.segment_name
ORDER BY total_revenue DESC;

-- Ques |What is the top selling product for each segment?

select
prod_id, max(qty) as top_product
from sales s join product_details d
on s.prod_id=d.product_id
group by d.segment_id;

SELECT 
	details.segment_id,
	details.segment_name,
	details.product_id,
	details.product_name,
	SUM(sales.qty) AS product_quantity
FROM balanced_tree.sales AS sales
INNER JOIN balanced_tree.product_details AS details
	ON sales.prod_id = details.product_id
GROUP BY
	details.segment_id,
	details.segment_name,
	details.product_id,
	details.product_name
ORDER BY product_quantity DESC
-- Limit to the top 5 best selling products
LIMIT 5;

-- Ques | What is the total quantity, revenue and discount for each category?

SELECT 
	details.category_id,
	details.category_name,
	SUM(sales.qty) AS total_quantity,
	SUM(sales.qty * sales.price) AS total_revenue,
	round(SUM(sales.qty * sales.price * sales.discount)/100,2) AS total_discount
FROM balanced_tree.sales AS sales
INNER JOIN balanced_tree.product_details AS details
	ON sales.prod_id = details.product_id
GROUP BY 
	details.category_id,
	details.category_name
ORDER BY total_revenue DESC;

-- Ques |  What is the top selling product for each category?

SELECT 
	details.product_id,
	details.product_name,
	SUM(sales.qty) AS product_quantity
FROM balanced_tree.sales AS sales
INNER JOIN balanced_tree.product_details AS details
	ON sales.prod_id = details.product_id
GROUP BY
	details.product_id,
	details.product_name
ORDER BY product_quantity DESC
-- Limit to the top 5 best selling products
LIMIT 5;

-- Ques | What is the percentage split of revenue by product for each segment?
with cte as 
(select d.segment_id, d.segment_name, d.product_id, d.product_name,
sum(s.qty*s.price) AS product_revenue
from sales s join product_details d
on s.prod_id = d.product_id
group by d.segment_id, d.segment_name, d.product_id, d.product_name)
select segment_name, Product_name ,
round((product_revenue/sum(product_revenue) over(partition by segment_name))*100,2)
as segment_product_percentage from cte ORDER BY
	segment_id,
	segment_product_percentage DESC;
    
-- Ques | What is the percentage split of revenue by segment for each category? 
with cte as 
(select d.segment_id, d.segment_name, d.category_id, d.category_name,
sum(s.qty*s.price) AS product_revenue
from sales s join product_details d
on s.prod_id = d.product_id
group by d.segment_id, d.segment_name, d.category_id, d.category_name)
select segment_name, category_name ,
round((product_revenue/sum(product_revenue) over(partition by category_name))*100,2)
as segment_category_percentage from cte ORDER BY
	segment_id,
	segment_category_percentage DESC;
    
-- Ques | What is the percentage split of total revenue by category?

select category_name,category_id, sum(s.qty*s.price) as revenue,
sum(s.qty*s.price) over() as total_revenue
 from sales s join product_details d
on s.prod_id = d.product_id
group by category_name,category_id;

SELECT 
   ROUND(100 * SUM(CASE WHEN details.category_id = 1 THEN (sales.qty * sales.price) END) / 
		 SUM(qty * sales.price),
		 2) AS category_1,
   (100 - ROUND(100 * SUM(CASE WHEN details.category_id = 1 THEN (sales.qty * sales.price) END) / 
		 SUM(sales.qty * sales.price),
		 2)
	) AS category_2
FROM balanced_tree.sales AS sales
INNER JOIN balanced_tree.product_details AS details
	ON sales.prod_id = details.product_id;
   
-- Ques | What is the total transaction “penetration” for each product?   