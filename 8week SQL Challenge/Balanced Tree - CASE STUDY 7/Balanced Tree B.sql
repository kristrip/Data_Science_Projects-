-- Ques | How many unique transactions were there?

select count(distinct(txn_id)) as unique_txn_count from sales;

-- Ques | What is the average unique products purchased in each transaction?

with cte as (select count(distinct(prod_id)) as unique_product
from sales group by txn_id)
select round(avg(unique_product)) as avg_product from cte;

-- Ques | What are the 25th, 50th and 75th percentile values
--       for the revenue per transaction?

WITH cte_transaction_revenue AS (
  SELECT
    txn_id,
    SUM(qty * price) AS revenue
  FROM balanced_tree.sales
  GROUP BY txn_id
)
SELECT
   percent_rank() over(partition by revenue)
FROM cte_transaction_revenue;

-- Ques | What is the average discount value per transaction?

WITH cte_transaction_discounts AS (
	SELECT
		txn_id,
		SUM(price * qty * discount)/100 AS total_discount
	FROM balanced_tree.sales
	GROUP BY txn_id
)
SELECT
	ROUND(AVG(total_discount)) AS avg_unique_products
FROM cte_transaction_discounts;

-- Ques | What is the percentage split of all transactions
--        for members vs non-members?

SELECT 
	ROUND(100 * 
		  COUNT(DISTINCT CASE WHEN members = 't' THEN txn_id END) / 
		  COUNT(DISTINCT txn_id)
		  , 2) AS member_transaction,
	(100 - ROUND(100 * 
		  COUNT(DISTINCT CASE WHEN members = 't' THEN txn_id END) / 
		  COUNT(DISTINCT txn_id)
		  , 2)
	 ) AS non_member_transaction
FROM balanced_tree.sales;

-- Ques | What is the average revenue for 
--        member transactions and non-member transactions?

WITH cte_member_revenue AS (
  SELECT
    members,
    txn_id,
    SUM(price * qty) AS revenue
  FROM balanced_tree.sales
  GROUP BY 
	members, 
	txn_id
)
SELECT
  members,
  ROUND(AVG(revenue), 2) AS avg_revenue
FROM cte_member_revenue
GROUP BY members;