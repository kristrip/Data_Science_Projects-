--  Ques | What was the total quantity sold for all products?

select sum(qty) as total_quantity_sold from sales;

select prod_id,sum(qty) as total_quantity from sales group by prod_id;

select s.prod_id,d.product_name,sum(qty) as total_quantity 
from sales s join product_details d 
on s.prod_id = d.product_id 
group by s.prod_id, d.product_name
order by total_quantity desc;

-- Ques | What is the total generated revenue for all products before discounts?

SELECT 
	SUM(price * qty) AS total_revenue
FROM sales;

SELECT 
	details.product_name,
	SUM(sales.qty * sales.price) AS total_revenue
FROM balanced_tree.sales AS sales
INNER JOIN balanced_tree.product_details AS details
	ON sales.prod_id = details.product_id
GROUP BY details.product_name
ORDER BY total_revenue DESC;

-- Ques | What was the total discount amount for all products?

select sum(discount) as total_discount from sales;

select prod_id,sum(discount) as total_discount from sales group by prod_id;

select prod_id,product_name,sum(discount) as total_discount 
from sales s join product_details d 
on s.prod_id = d.product_id
group by prod_id
order by total_discount desc
;



