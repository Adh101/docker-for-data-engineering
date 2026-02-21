# Module 4 Homework: Analytics Engineering
## Question 1:
Q1: dbt run --select int_trips_unioned builds which models?
Ans: stg_green_tripdata, stg_yellow_tripdata, and int_trips_unioned`

## Question 2:
Q2: New value 6 appears in payment_type. What happens on dbt test? </br> 
Ans: dbt fails the test with non-zero exit code

## Question 3:
Q3: Count of records in fct_monthly_zone_revenue?
```
-- Count of records in fct_monthly_zone_revenue
SELECT COUNT(*)
FROM `dbt_atish.fct_monthly_zone_revenue`;
```
## Question 4:
Zone with highest revenue for Green taxis in 2020??
```
SELECT 
  pickup_zone,
  SUM(total_amount) as revenue
FROM `dbt_atish.fct_trips`
WHERE service_type = 'Green'
 AND (EXTRACT(YEAR FROM DATE(pickup_datetime))= 2020
 )
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;
```

## Question 5:
Total trips for Green taxis in October 2019
```
SELECT
  COUNT(*)
FROM `dbt_atish.fct_trips`
WHERE service_type = 'Green'
  AND (DATE(pickup_datetime) >= DATE '2019-10-01'
        AND DATE(pickup_datetime) < DATE '2019-11-01');
```

## Question 6:
Count of records in stg_fhv_tripdata (filter dispatching_base_num IS NULL)</br>
```
SELECT COUNT(*)
FROM `dbt_atish.stg_fhv_tripdata`
WHERE dispatching_base_num IS NOT NULL;
```
