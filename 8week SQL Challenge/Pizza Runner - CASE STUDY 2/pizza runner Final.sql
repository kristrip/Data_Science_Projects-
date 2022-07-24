CREATE SCHEMA pizza_runner;
SET search_path = pizza_runner;

DROP TABLE IF EXISTS runners;
CREATE TABLE runners (
  runner_id INTEGER,
  registration_date DATE
);
INSERT INTO runners
  (runner_id, registration_date)
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');


DROP TABLE IF EXISTS customer_orders;
CREATE TABLE customer_orders (
  order_id INTEGER,
  customer_id INTEGER,
  pizza_id INTEGER,
  exclusions VARCHAR(4),
  extras VARCHAR(4),
  order_time TIMESTAMP
);

INSERT INTO customer_orders
  (order_id, customer_id, pizza_id, exclusions, extras, order_time)
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');


DROP TABLE IF EXISTS runner_orders;
CREATE TABLE runner_orders (
  order_id INTEGER,
  runner_id INTEGER,
  pickup_time VARCHAR(19),
  distance VARCHAR(7),
  duration VARCHAR(10),
  cancellation VARCHAR(23)
);

INSERT INTO runner_orders
  (order_id, runner_id, pickup_time, distance, duration, cancellation)
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');


DROP TABLE IF EXISTS pizza_names;
CREATE TABLE pizza_names (
  pizza_id INTEGER,
  pizza_names TEXT
);
INSERT INTO pizza_names
  (pizza_id, pizza_names)
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');


DROP TABLE IF EXISTS pizza_recipes;
CREATE TABLE pizza_recipes (
  pizza_id INTEGER,
  toppings TEXT
);
INSERT INTO pizza_recipes
  (pizza_id, toppings)
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');


DROP TABLE IF EXISTS pizza_toppings;
CREATE TABLE pizza_toppings (
  topping_id INTEGER,
  topping_name TEXT
);
INSERT INTO pizza_toppings
  (topping_id, topping_name)
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');
  


  -- Ques | How many pizzas were ordered?
  
SELECT count(order_id) AS total_pizza_ordered FROM customer_orders;
  
  -- Ques | How many unique customer orders were made?
  
  -- for this we need to clean the data because it contain too
  -- many missing values
  
  select * from customer_orders;
  
  DROP TABLE IF EXISTS updated_customer_orders;
CREATE  TABLE updated_customer_orders AS (
  SELECT
    order_id,
    customer_id,
    pizza_id,
    CASE 
      WHEN exclusions IS NULL 
        OR exclusions LIKE 'null' THEN ''
      ELSE exclusions 
    END AS exclusions,
    CASE 
      WHEN extras IS NULL
        OR extras LIKE 'null' THEN ''
      ELSE extras 
    END AS extras,
    order_time
  FROM pizza_runner.customer_orders
);
select * from updated_customer_orders;

UPDATE customer_orders SET exclusions = '' WHERE exclusions like 'null';
UPDATE customer_orders SET extras = '' WHERE extras like 'null' or extras IS NULL;

select * from customer_orders;

select count(distinct(c.order_id)) as unique_orders from customer_orders c;

-- ques | How many successful orders were delivered by each runner?
  
  select * from runner_orders;
  
  -- (DROP TABLE IF EXISTS updated_runner_orders;
-- CREATE  TABLE updated_runner_orders AS (
 -- SELECT
  --  order_id,
  --  runner_id,
  --   CASE WHEN pickup_time LIKE 'null' THEN null ELSE pickup_time END :: timestamp AS pickup_time,
   -- case when cancellation  NULLIF(regexp_replace(distance, '[^0-9.]','','g'), '')::numeric AS distance,
   -- NULLIF(regexp_replace(duration, '[^0-9.]','','g'), '')::numeric AS duration,
   -- CASE WHEN cancellation IN ('null', 'NaN', '') THEN null ELSE cancellation END AS cancellation
 -- FROM pizza_runner.runner_orders);)
  
UPDATE runner_orders SET distance = '' WHERE distance like 'null';
UPDATE runner_orders SET pickup_time = '' WHERE pickup_time like 'null';
UPDATE runner_orders SET duration = '' WHERE duration like 'null';
UPDATE runner_orders SET cancellation = '' WHERE cancellation like 'null' OR cancellation IS NULL;

select * from runner_orders;

select runner_id, count(order_id) as sucessful_orders
from runner_orders WHERE cancellation = '' group by runner_id;

-- Ques | How many of each type of pizza was delivered?

select pizza_runner.customer_orders.pizza_id, 
count(customer_orders.order_id) as order_count,
pizza_runner.pizza_names.pizza_names
from pizza_runner.customer_orders 
join pizza_runner.pizza_names
on pizza_runner.customer_orders.pizza_id = pizza_runner.pizza_names.pizza_id
Join pizza_runner.runner_orders 
On pizza_runner.customer_orders.order_id = pizza_runner.runner_orders.order_id
WHERE cancellation = ''
group by pizza_runner.pizza_names.pizza_id;

SELECT 
  pizza_runner.pizza_names.pizza_names,
  COUNT(pizza_runner.customer_orders.pizza_id) AS successful_pizza_delivered
FROM pizza_runner.customer_orders
Join pizza_runner.runner_orders 
On pizza_runner.customer_orders.order_id = pizza_runner.runner_orders.order_id
Join pizza_runner.pizza_names
On pizza_runner.customer_orders.pizza_id = pizza_runner.pizza_names.pizza_id
WHERE pizza_runner.runner_orders.duration != ''
GROUP BY pizza_runner.pizza_names.pizza_names;

-- Ques | How many Vegetarian and Meatlovers were ordered by each customer

select pizza_runner.customer_orders.customer_id, 
count(customer_orders.pizza_id) as pizza_count,
pizza_runner.pizza_names.pizza_names
from pizza_runner.customer_orders 
join pizza_runner.pizza_names
on pizza_runner.customer_orders.pizza_id = pizza_runner.pizza_names.pizza_id
group by pizza_runner.customer_orders.customer_id, pizza_runner.pizza_names.pizza_names;

SELECT
  customer_id,
  SUM(CASE WHEN pizza_id = 1 THEN 1 ELSE 0 END) AS meat_lovers,
  SUM(CASE WHEN pizza_id = 2 THEN 1 ELSE 0 END) AS vegetarian
FROM updated_customer_orders
GROUP BY customer_id;

-- 6.What was the maximum number of pizzas delivered in a single order?
-- what is maximun number of pizza ordered by single customer

select order_id, max(max_order) as max_order from (SELECT 
  c.order_id 
  ,COUNT(c.order_id) AS max_order
FROM customer_orders as c
join runner_orders as ro 
on c.order_id= ro.order_id
WHERE ro.cancellation = ''
GROUP BY c.order_id) as ed ;

SELECT MAX(pizza_count) AS max_count
FROM (
  SELECT
    co.order_id,
    COUNT(co.pizza_id) AS pizza_count
  FROM updated_customer_orders AS co
  INNER JOIN updated_runner_orders AS ro
    ON co.order_id = ro.order_id
  WHERE 
    ro.cancellation IS NULL
    OR ro.cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation')
  GROUP BY co.order_id) AS mycount;
  
  WITH number_pizza_per_order_cte AS
 (
 SELECT 
  c.order_id 
  ,COUNT(c.pizza_id) AS pizza_delivered_per_order
FROM customer_orders as c
join runner_orders as ro 
on c.order_id= ro.order_id
WHERE ro.duration != ''
GROUP BY c.order_id
)

SELECT
 order_id,
 MAX(pizza_delivered_per_order) AS maximum_pizza_delivered
FROM number_pizza_per_order_cte;

-- Que | For each customer, how many delivered pizzas had
-- at least 1 change and how many had no changes?

select c.customer_id, order_id, pizza_ordered,c , l from (SELECT 
  c.order_id,
  sum(case when c.pizza_id = 1 then 1 else 0 end ) as c,
  sum(case when c.pizza_id = 2 then 1 else 0 end ) as l
  ,COUNT(c.pizza_id) AS pizza_ordered
FROM customer_orders as c
join runner_orders as ro 
on c.order_id= ro.order_id
WHERE ro.cancellation = ''
GROUP BY c.order_id) as ed ;

SELECT 
  co.customer_id,
  SUM(CASE WHEN co.exclusions IS NOT NULL OR co.extras IS NOT NULL THEN 1 ELSE 0 END) AS changes,
  SUM(CASE WHEN co.exclusions IS NULL OR co.extras IS NULL THEN 1 ELSE 0 END) AS no_change
FROM updated_customer_orders AS co
INNER JOIN updated_runner_orders AS ro
  ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL
  OR ro.cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation')
GROUP BY co.customer_id
ORDER BY co.customer_id;

-- Ques | How many pizzas were delivered that had both exclusions and extras?
select * from runner_orders; 
select * from customer_orders c join runner_orders r on c.order_id = r.order_id;
select count(pizza_id) from customer_orders c 
join runner_orders r on c.order_id = r.order_id
where r.cancellation = '' and  c.exclusions != '' and c.extras != '';

-- Ques | What was the total volume of pizzas ordered for each hour of the day

Select 
   hour(order_time)As hour,
   COUNT(order_id) AS pizza_count
from customer_orders
group by hour(order_time) order by hour desc;

-- Ques | What was the volume of orders for each day of the week

Select 
   weekday(order_time)As day,
   COUNT(order_id) AS pizza_count
from customer_orders
group by hour(order_time) order by pizza_count desc;

                            -- PART 2 --
                            
 -- Ques | How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
 
 select *  from runners;
 select count(runner_id), week(registration_date) as runner_signed_up
 from runners group by week(registration_date);
 
 WITH runner_signups AS (
  SELECT
    runner_id,
    registration_date,
    registration_date - ((registration_date - '2021-01-01') % 7)  AS start_of_week
  FROM pizza_runner.runners
)
SELECT
  start_of_week,
  COUNT(runner_id) AS signups
FROM runner_signups
GROUP BY start_of_week
ORDER BY start_of_week;

 -- What was the average time in minutes it took for each runner to arrive
 -- at the Pizza Runner HQ to pickup the order?
 
 select * from (select runner_id, time(order_time) as  OT,
time(pickup_time) as PT from customer_orders c join runner_orders r
 on c.order_id = r.order_id 
 where r.duration != '') l where pt != NULL;
 
 select time(order_time) as c from customer_orders;
select time(pickup_time) as d from runner_orders;

WITH time_taken_ete AS
(
 SELECT c.order_id, c.order_time, pizza_runner.runner_orders.pickup_time,
 pizza_runner.runner_orders.runner_id,
  (minute(pickup_time) - minute(order_time)) as  pickup_minutes
 FROM customer_orders AS c
 JOIN runner_orders 
  ON c.order_id = runner_orders.order_id
 WHERE runner_orders.distance != 0
 GROUP BY c.order_id, c.order_time, runner_orders.pickup_time
)
select runner_id, avg(pickup_minutes) as avg_time 
from time_taken_ete
where pickup_minutes > 1  group by runner_id;

-- Ques |Is there any relationship between the number of pizzas
-- and how long the order takes to prepare?
with cte as (SELECT c.order_id,count(c.order_id) as pizza_order, c.order_time,
 pizza_runner.runner_orders.pickup_time,
  (minute(pickup_time) - minute(order_time)) as  pickup_minutes
 FROM customer_orders AS c
 JOIN runner_orders 
  ON c.order_id = runner_orders.order_id
 WHERE runner_orders.distance != 0
 GROUP BY c.order_id, c.order_time, runner_orders.pickup_time)
 select pizza_order, avg(pickup_minutes) from cte where pickup_minutes >1
 group by pizza_order;
 
 -- Ques | What was the average distance travelled for each customer?
 
 DROP TABLE IF EXISTS updated_runner_orders;
CREATE  TABLE updated_runner_orders as  (SELECT order_id, runner_id,
  CASE 
    WHEN pickup_time LIKE 'null' THEN ' '
    ELSE pickup_time 
    END AS pickup_time,
  CASE 
    WHEN distance LIKE 'null' THEN ' '
    WHEN distance LIKE '%km' THEN TRIM('km' from distance) 
    ELSE distance END AS distance,
  CASE 
    WHEN duration LIKE 'null' THEN ' ' 
    WHEN duration LIKE '%mins' THEN TRIM('mins' from duration) 
    WHEN duration LIKE '%minute' THEN TRIM('minute' from duration)        
    WHEN duration LIKE '%minutes' THEN TRIM('minutes' from duration)       
    ELSE duration END AS duration,
  CASE 
    WHEN cancellation IS NULL or cancellation LIKE 'null' THEN ''
    ELSE cancellation END AS cancellation
FROM runner_orders);
select * from updated_runner_orders u
 join updated_customer_orders o  on u.order_id=o.order_id;
select customer_id, round(avg(duration) ) from updated_runner_orders u
 join updated_customer_orders o  on u.order_id=o.order_id where duration != ''
group by customer_id;

-- Ques | What was the difference between the longest and 
-- shortest delivery times for all orders?
select * from updated_runner_orders;
with cte as (SELECT c.order_id,c.order_time,
 pizza_runner.updated_runner_orders.pickup_time,
  (minute(pickup_time) - minute(order_time)) as  pickup_minutes
 FROM updated_customer_orders AS c
 JOIN updated_runner_orders 
  ON c.order_id = updated_runner_orders.order_id
 WHERE updated_runner_orders.distance != '')
 select (max(pickup_minutes) - min(pickup_minutes)) as differnce
 from cte where pickup_minutes > 1;
 
 -- Ques | What was the average speed for each runner for each delivery and 
 -- do you notice any trend for these values?
 
 select * from updated_runner_orders ur join updated_customer_orders uc on
 ur.order_id = uc.order_id where
 ur.duration != '' ;
 
 select runner_id , uc.order_id, distance,
 minute(order_time)-minute(pickup_time) as time_taken 
 from updated_runner_orders ur join updated_customer_orders uc on
 ur.order_id = uc.order_id where
 ur.duration != '' ;
 
 SELECT r.runner_id, c.customer_id, c.order_id, 
 COUNT(c.order_id) AS pizza_count, 
 r.distance, round((r.duration / 60)) AS duration_hr , 
 ROUND((r.distance/r.duration * 60), 2) AS avg_speed
FROM updated_runner_orders AS r
JOIN updated_customer_orders AS c
 ON r.order_id = c.order_id
WHERE distance != ''
GROUP BY r.runner_id, c.customer_id, c.order_id, r.distance, r.duration
ORDER BY c.order_id;

-- Que | What is the successful delivery percentage for each runner?
SELECT runner_id, count(c.order_id) as order_count,
 (count(c.order_id)/count(*))*100 as percent
FROM updated_runner_orders AS r
JOIN updated_customer_orders AS c
 ON r.order_id = c.order_id
 where cancellation = ''
 group by runner_id;
 
                           -- PART 3 --

-- Ques |  What are the standard ingredients for each pizza?  
 with cte as (select pt.topping_name,
		pr.pizza_id,
        pizza_names.pizza_names 
from  pizza_recipes pr join pizza_toppings pt on pr.toppings=pt.topping_id
join pizza_names  on pr.pizza_id=pizza_names.pizza_id) 
select cte.pizza_names , cte.topping_name from cte;
SELECT
		pt.topping_name,
		tpr.pizza_id,
        pn.pizza_names
	FROM pizza_recipes tpr
    JOIN pizza_toppings pt ON pt.topping_id = tpr.toppings
    JOIN pizza_names pn ON pn.pizza_id = tpr.pizza_id
    ORDER BY pn.pizza_names;

-- Ques | What was the most commonly added extra?


   -- Part 4 ---
   
   -- Ques | If a Meat Lovers pizza costs $12 and Vegetarian costs $10 
   -- and there were no charges for changes - 
   -- how much money has Pizza Runner made so far if there are no delivery fees?
   
   select customer_id, (CASE
			WHEN co.pizza_id = 1 THEN 12
            ELSE 10 end ) as total_price
            from updated_runner_orders ro join updated_customer_orders co
            on co.order_id = ro.order_id;

-- Ques | What if there was an additional $1 charge for any pizza extras?
 -- Add cheese is $1 extra 
 select * from updated_customer_orders;
 with cte as (select customer_id, (CASE
			WHEN co.pizza_id = 1 THEN 12
            ELSE 10 end ) as pizza_price,
            (case when co.extras = '' then 0 
                  when co.extras = 1 then 1 
                  else 3 end ) as extra_price
            from updated_runner_orders ro join updated_customer_orders co
            on co.order_id = ro.order_id) 
select customer_id, (pizza_price + extra_price) as total_price, 
sum((pizza_price + extra_price)) as grand_total from cte;

-- Ques | The Pizza Runner team now wants to add an additional ratings system
-- that allows customers to rate their runner, how would you design an additional
-- table for this new dataset - generate a schema for this new tableand insert
--  your own data for ratings for each successful customer order between 1 to 5.
         
DROP TABLE IF EXISTS ratings;
CREATE TABLE ratings (
order_id int,
runner_id int,
rating int);

INSERT INTO ratings VALUES 
(1,2, 5), (2,7, 3), (3,9, 4), (4,5, 2), (5,4,3), (7,3, 3), (8,2, 4), (10,3, 5);

SELECT * FROM ratings;

-- ques | Using your newly generated table - can you join all of the information 
-- together to form a table which has the following information for successful deliveries?
-- customer_id, order_id, runner_id,rating,order_time,pickup_time,Time between order and pickup
-- Delivery duration,Average speed,Total number of pizzas

select c.customer_id, c.order_id, 
r.runner_id, rat.rating, c.order_time,
r.pickup_time,(minute(r.pickup_time)- minute(c.order_time) ) as TimebwOrderandPickup,
r.duration, round(avg(r.distance*60/r.duration),1) as avgspeed,
count(c.pizza_id) as PIzzaCount
from updated_customer_orders c
inner join updated_runner_orders r
on c.order_id = r.order_id
inner join ratings rat
on rat.order_id = c.order_id
group by c.customer_id, c.order_id, r.runner_id, rat.rating, c.order_time,
r.pickup_time, TimebwOrderandPickup, r.duration
order by customer_id;


