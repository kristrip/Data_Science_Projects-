            -- DATA CLEANING --
select * from weekly_sales;
select count(*) from weekly_sales;
SELECT STR_TO_DATE(week_date,'%d/%m/%Y' ) as week_date from weekly_sales;

DROP TABLE IF EXISTS clean_weekly_sales;
CREATE TEMPORARY TABLE clean_weekly_sales AS (
SELECT
  str_to_date(week_date, '%d/%m/%Y') AS week_date,
  week(str_to_date(week_date, '%d/%m/%Y')) AS week_number,
  month(str_to_date(week_date, '%d/%m/%Y')) AS month_number,
  year(str_to_date(week_date, '%d/%m/%Y')) AS calendar_year,
  region, 
  platform, 
  segment,
  CASE WHEN RIGHT(segment,1) = '1' THEN 'Young Adults'
    WHEN RIGHT(segment,1) = '2' THEN 'Middle Aged'
    WHEN RIGHT(segment,1) in ('3','4') THEN 'Retirees'
    ELSE 'unknown' END AS age_band,
  CASE WHEN LEFT(segment,1) = 'C' THEN 'Couples'
    WHEN LEFT(segment,1) = 'F' THEN 'Families'
    ELSE 'unknown' END AS demographic,
  transactions,
  ROUND((sales/transactions),2) AS avg_transaction,
  sales
FROM data_mart.weekly_sales);

select * from clean_weekly_sales;

--  Ques | What day of the week is used for each week_date value?
SELECT 
  DISTINCT (dayname(week_date)) AS week_day 
FROM clean_weekly_sales;

-- Ques | What range of week numbers are missing from the dataset?
select distinct(week_number) x from clean_weekly_sales order by x ;

--  Ques | How many total transactions were there for each year in the dataset?

select count(transactions) as Total_transaction_count
 from clean_weekly_sales group by calendar_year;
 
 -- Ques | What is the total sales for each region for each month?
 select * from clean_weekly_sales;
 select sum(sales) as Total_sales_region, region,month_number
 from clean_weekly_sales group by region,month_number;
 
 -- Ques | What is the total count of transactions for each platform
 
select count(transactions) as Total_transaction_count, platform
 from clean_weekly_sales group by platform;
 
 -- Ques | What is the percentage of sales for Retail vs Shopify for each month?
  select * from clean_weekly_sales;
  with t as (select sum(sales) as total_monthly_sales, region, month_number from
  clean_weekly_sales group by region, month_number),
select 
  
  -- Ques | What is the percentage of sales by demographic for each year in the dataset?
  
 WITH demographic_sales AS (
  SELECT 
    calendar_year, 
    demographic, 
    SUM(sales) AS yearly_sales
  FROM clean_weekly_sales
  GROUP BY calendar_year, demographic
)

SELECT 
  calendar_year, 
  ROUND(100 *  
    max(CASE WHEN demographic = 'Couples' THEN yearly_sales ELSE NULL END) / 
      SUM(yearly_sales),2) AS couples_percentage,
  ROUND(100 *  
    max(CASE WHEN demographic = 'Families' THEN yearly_sales ELSE NULL END) / 
      SUM(yearly_sales),2) AS families_percentage,
  ROUND(100 *  
    max(CASE WHEN demographic = 'unknown' THEN yearly_sales ELSE NULL END) / 
      SUM(yearly_sales),2) AS unknown_percentage
FROM demographic_sales
GROUP BY calendar_year
ORDER BY calendar_year;

-- Ques | Which age_band and demographic values contribute the most to Retail sales?
select * from clean_weekly_sales;
select sum(sales),age_band,demographic from clean_weekly_sales group by age_band,demographic;
SELECT 
  age_band, 
  demographic, 
  SUM(sales) AS retail_sales,
  ROUND(100 * SUM(sales)/ SUM(SUM(sales)) OVER (),2) AS contribution_percentage
FROM clean_weekly_sales
WHERE platform = 'Retail'
GROUP BY age_band, demographic
ORDER BY retail_sales DESC;

-- Ques | Can we use the avg_transaction column to find the average transaction size
-- for each year for Retail vs Shopify? If not - how would you calculate it instead?
select * from clean_weekly_sales;
select calendar_year, 
  platform, 
  ROUND(AVG(avg_transaction),0) AS avg_transaction_row, 
  SUM(sales) / sum(transactions) AS avg_transaction_group
  from clean_weekly_sales group by calendar_year, platform;
  
                      --    PART 3     --
                      
-- Ques | What is the total sales for the 4 weeks before and after 2020-06-15? 
-- What is the growth or reduction rate in actual values and percentage of sales?

select * from clean_weekly_sales;
select distinct(calendar_year) from clean_weekly_sales;
SELECT 
  DISTINCT week_number
FROM clean_weekly_sales
WHERE week_date = '2020-06-15' 
  AND calendar_year = '2020';
  
-- Ques | What is the total sales for the 4 weeks before and after 2020-06-15? 
-- What is the growth or reduction rate in actual values and percentage of sales?
with band as (SELECT 
    week_date, 
    week_number, 
    SUM(sales) AS total_sales
  FROM clean_weekly_sales
  WHERE (week_number BETWEEN 20 AND 28) 
    AND (calendar_year = 2020)
  GROUP BY week_date, week_number),
 band_2 as (SELECT 
    SUM(CASE WHEN week_number BETWEEN 20 AND 24 THEN total_sales END) AS before_change,
    SUM(CASE WHEN week_number BETWEEN 25 AND 28 THEN total_sales END) AS after_change
  FROM band)
  select before_change, after_change,(after_change - before_change) as vaiance,
  round(((after_change - before_change)/before_change)*100) as percent_change
  from band_2;
 
 
 -- Ques | What about the entire 12 weeks before and after?
 with band as (SELECT 
    week_date, 
    week_number, 
    SUM(sales) AS total_sales
  FROM clean_weekly_sales
  WHERE (week_number BETWEEN 12 AND 36) 
    AND (calendar_year = 2020)
  GROUP BY week_date, week_number),
 band_2 as (SELECT 
    SUM(CASE WHEN week_number BETWEEN 12 AND 24 THEN total_sales END) AS before_change,
    SUM(CASE WHEN week_number BETWEEN 25 AND 36 THEN total_sales END) AS after_change
  FROM band)
  select before_change, after_change,(after_change - before_change) as vaiance,
  round(((after_change - before_change)/before_change)*100) as percent_change
  from band_2
 
 --  from the above analysis it is obvious that the change that danny did has not been
 --  benifical for the organisation so far the sales have gone down for 
 -- demographic, and age_band for the most


  