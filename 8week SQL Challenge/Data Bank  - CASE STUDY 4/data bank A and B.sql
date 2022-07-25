-- 1. How many unique nodes are there on the Data Bank system?

select count(distinct(node_id)) as unique_node from customer_nodes;

-- 2. What is the number of nodes per region?

select region_id,count(node_id) as node_count from customer_nodes group by region_id order by region_id asc;
select r.region_id,count(node_id) as node_count,region_name from
customer_nodes c join regions r 
on c.region_id = r.region_id
group by region_id order by region_id asc;

-- 3. How many customers are allocated to each region?
select r.region_id,count(distinct(customer_id)) as customer_count,region_name from
customer_nodes c join regions r 
on c.region_id = r.region_id
group by region_id order by customer_count desc;

-- 4. How many days on average are customers reallocated to a different node?
select*from customer_nodes;
SELECT round(avg(datediff(end_date, start_date)), 2) AS avg_days
FROM customer_nodes
WHERE end_date!='9999-12-31';

-- 5. What is the median, 
-- 80th and 95th percentile for this same reallocation days metric for each region?
SELECT *, (datediff(end_date, start_date)) AS days_change,
percent_rank() over(partition by region_id order by (datediff(end_date, start_date)))
 as percent
FROM customer_nodes
WHERE end_date!='9999-12-31';

WITH reallocation_days_cte AS
  (SELECT *,
          (datediff(end_date, start_date)) AS reallocation_days
   FROM customer_nodes
   INNER JOIN regions USING (region_id)
   WHERE end_date!='9999-12-31'),
     percentile_cte AS
  (SELECT *,
          percent_rank() over(PARTITION BY region_id
                              ORDER BY reallocation_days)*100 AS p
   FROM reallocation_days_cte)
SELECT region_id,
       region_name,
       reallocation_days
FROM percentile_cte
WHERE p >95
GROUP BY region_id;

-- 80th percentile

WITH reallocation_days_cte AS
  (SELECT *,
          (datediff(end_date, start_date)) AS reallocation_days
   FROM customer_nodes
   INNER JOIN regions USING (region_id)
   WHERE end_date!='9999-12-31'),
     percentile_cte AS
  (SELECT *,
          percent_rank() over(PARTITION BY region_id
                              ORDER BY reallocation_days)*100 AS p
   FROM reallocation_days_cte)
SELECT region_id,
       region_name,
       reallocation_days
FROM percentile_cte
WHERE p >80
GROUP BY region_id;

-- 50th percentile

WITH reallocation_days_cte AS
  (SELECT *,
          (datediff(end_date, start_date)) AS reallocation_days
   FROM customer_nodes
   INNER JOIN regions USING (region_id)
   WHERE end_date!='9999-12-31'),
     percentile_cte AS
  (SELECT *,
          percent_rank() over(PARTITION BY region_id
                              ORDER BY reallocation_days)*100 AS p
   FROM reallocation_days_cte)
SELECT region_id,
       region_name,
       reallocation_days,p
FROM percentile_cte
WHERE p >50
GROUP BY region_id;

                         -- Part - B --

-- Ques | What is the unique count and total amount for each transaction type?

select * from customer_transactions;
select txn_type,count(*) as unique_count, sum(txn_amount)as total_amount
from customer_transactions group by txn_type;

-- 2. What is the average total historical deposit counts
-- and amounts for all customers?

with cte as (select customer_id, count(txn_type) as txn_count, sum(txn_amount) as total_tax
from customer_transactions where txn_type= 'deposit' group by customer_id
order by customer_id)
select avg(txn_count) as avg_txn_count, avg(total_tax) as avg_total_tax from cte;

-- 3. For each month - how many Data Bank customers make more than 1 deposit and 
-- either 1 purchase or 1 withdrawal in a single month?
select * from customer_transactions;
with cte as (select customer_id, month(txn_date)as month, monthname(txn_date) as month_name,
 sum(case when txn_type = 'deposit' then 1 else 0 end) as dep ,
 sum(case when txn_type = 'withdrawl' then 1 else 0 end) as withd,
 sum(case when txn_type = 'purchase' then 1 else 0 end) as pur from
 customer_transactions group by month,month_name,customer_id)
 SELECT 
	month,
	COUNT(distinct(customer_id)) AS customer_count
FROM cte
WHERE dep > 1 AND (pur >= 1 OR withd >= 1)
GROUP BY 
	month,
	month_name
ORDER BY month_name;

-- 4. What is the closing balance for each customer at the end of the month?
select *, month(txn_date) as month from customer_transactions;
with cte as (select customer_id, month(txn_date)as month, sum(case when txn_type = 'deposit' then 
txn_amount else -txn_amount end) as net_transaction_amount from customer_transactions
group by customer_id,month order by customer_id)
SELECT customer_id,
       month,
       net_transaction_amount,
       sum(net_transaction_amount) over(PARTITION BY customer_id 
       ORDER BY month ROWS BETWEEN UNBOUNDED preceding AND CURRENT ROW)
       AS closing_balance
FROM cte; 

-- 5. What is the percentage of customers who increase their closing balance by more than 5%?

