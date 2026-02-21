-- Count of records in fct_monthly_zone_revenue
SELECT COUNT(*)
FROM `dbt_atish.fct_monthly_zone_revenue`;

-- Zone with highest revenue for Green taxis in 2020
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

-- Total trips for Green taxis in October 2019
SELECT
  COUNT(*)
FROM `dbt_atish.fct_trips`
WHERE service_type = 'Green'
  AND (DATE(pickup_datetime) >= DATE '2019-10-01'
        AND DATE(pickup_datetime) < DATE '2019-11-01');

-- Count of records in stg_fhv_tripdata (filter dispatching_base_num IS NULL)
SELECT COUNT(*)
FROM `dbt_atish.stg_fhv_tripdata`
WHERE dispatching_base_num IS NOT NULL;


