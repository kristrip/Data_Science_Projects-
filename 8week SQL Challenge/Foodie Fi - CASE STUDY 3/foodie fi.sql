-- Ques | Customer Journey

sELECT
    s.customer_id,
    p.plan_name,
    s.start_date
FROM subscriptions s
JOIN plans p ON s.plan_id = p.plan_id; 

-- Ques | How many customers has Foodie-Fi ever had?
select count(distinct(customer_id)) as total_customers from subscriptions;

-- Ques | What is the monthly distribution of trial plan start_date values
-- for our dataset use the start of the month as the group by value

select * from subscriptions;
select count(customer_id) as monthly_distribution, MONTH(start_date) AS months
from subscriptions where
plan_id = 0 group by months order by months asc;

-- Ques | What plan start_date values occur after the year 2020 for our dataset? 
-- Show the breakdown by count of events for each plan_name

select p.plan_id, p.plan_name, count(*)as event_occourances_2021 from subscriptions s
join plans p on s.plan_id = p.plan_id where start_date >= '2021-01-01' 
group by plan_id, plan_name order by plan_id;

select p.plan_id, p.plan_name, count(*)as event_occourances_2020 from subscriptions s
join plans p on s.plan_id = p.plan_id where 
'2020-01-01' <= start_date <= '2020-12-31' 
group by plan_id, plan_name order by plan_id;

-- Ques | 4. What is the customer count and percentage of
--  customers who have churned rounded to 1 decimal place?

select count(customer_id) as customer_count ,
round((count(customer_id)/1000)*100) as percent
 from subscriptions where plan_id =4 ;
 
 -- Ques | How many customers have churned straight after their initial free trial 
 -- what percentage is this rounded to the nearest whole number?
 
with cte as (select s.customer_id,  s.plan_id, p.plan_name ,
dense_rank() over(partition by s.customer_id order by s.plan_id) as row_count
from subscriptions s join plans p on s.plan_id = p.plan_id)
 select count(*) as churn_count , round((count(*)/1000)*100) as percent
 from cte where row_count =2 and plan_id  =4;
 
 
 -- Ques | 
 
 -- Retrieve next plan's start date located in the next row based on current row
WITH next_plan_cte AS (
  SELECT 
    customer_id, 
    plan_id, 
    start_date,
    LEAD(plan_id, 1) OVER(
      PARTITION BY customer_id 
      ORDER BY plan_id) as next_plan
  FROM foodie_fi.subscriptions)

SELECT 
  COUNT(*) AS downgraded
FROM next_plan_cte
WHERE start_date <= '2020-12-31'
  AND plan_id = 2 
  AND next_plan = 1;
 -- Ques |  What is the number and percentage of customer plans after
 -- their initial free trial?
 select * from subscriptions;
 select count(distinct(customer_id)) as number_con, 
 (count(distinct(customer_id))/1000)*100 as percentage from
 subscriptions s join plans p on s.plan_id = p.plan_id where s.plan_id != 4;
 
with cte as (select *, lead(s.plan_id,1) over(partition by s.customer_id order by s.plan_id)
as next_plan from subscriptions s )
select count(*) as num_cost,
ROUND(COUNT(*) * 100/(SELECT COUNT(DISTINCT customer_id) FROM subscriptions),1)
AS perc_next_plan from cte WHERE next_plan != 0 and plan_id = 0 
group by next_plan order by next_plan;

-- Ques | What is the customer count and percentage breakdown of all 5
-- plan_name values at 2020-12-31?
select * from subscriptions;
select * from plans;
with cte as (select 
sum(case when plan_id = 0 then 1 else 0 end) as Trial,
sum(case when plan_id = 1 then 1 else 0 end) as bas_mon,
sum(case when plan_id = 2 then 1 else 0 end) as pro_mon,
sum(case when plan_id = 3 then 1 else 0 end) as pro_ann,
sum(case when plan_id = 4 then 1 else 0 end) as churn
from subscriptions where start_date < '2020-12-31')
select (trial/1000)*100 as trial_percent, (bas_mon/1000)*100 as bas_mon_percent,
(pro_mon/1000)*100 as pro_mon_percent, (pro_ann/1000)*100 as pro_ann_percent,
(churn/1000)*100 as churn_percent from cte;

-- Ques | How many customers have upgraded to an annual plan in 2020?

select count(distinct(customer_id)) as annual_pro from subscriptions
where plan_id=3 and start_date <= '2020-12-31';

-- Ques | How many days on average does it take for a customer to an annual
-- plan from the day they join Foodie-Fi?
select * from subscriptions s join plans p on s.plan_id=p.plan_id; 
select customer_id, (case when plan_id=0 then start_date else '' end) as 0_start_date,
(case when plan_id=3 then start_date else '' end) as 3_start_date
from subscriptions;

WITH trial_plan AS 
  (SELECT 
    customer_id, 
    start_date AS trial_date
  FROM subscriptions
  WHERE plan_id = 0
),
-- Filter results to customers at pro annual plan = 3
annual_plan AS
  (SELECT 
    customer_id, 
    start_date AS annual_date
  FROM subscriptions
  WHERE plan_id = 3
)
select round(avg(datediff(annual_date,trial_date))) as avg_day_to_annual
from trial_plan join annual_plan on trial_plan.customer_id =
 annual_plan.customer_id;
 
-- Ques | How would you calculate the rate of growth for Foodie-Fi?
 -- i would calculate the monthly reveneue of the foodie fi and see the conversion metrices for the 
-- What key metrics would you recommend Foodie-Fi management to track over time to assess performance of their overall business?
-- conversion rates and drop rate( i.e free to churn and free to paid and increase in customers)
-- What are some key customer journeys or experiences that you would analyse further to improve customer retention?
-- i would look the trend in the conversion rate of customer who join the annual plan and who dosent
-- If the Foodie-Fi team were to create an exit survey shown to customers who wish to cancel their subscription, what questions would you include in the survey?
-- reason for cancellation , any technical issue , feednack 
-- What business levers could the Foodie-Fi team use to reduce the customer churn rate? How would you validate the effectiveness of your ideas?
-- trial period extended for the targey customer , discount on annual plan, advantage to customer who upgrade from bacic_monthly
-- check the conversion metrices for the strategy
