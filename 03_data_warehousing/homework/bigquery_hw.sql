-- Create external table for 2024 NY Taxi Data from parquet files
CREATE OR REPLACE EXTERNAL TABLE `ny_taxi.external_yellow_taxidata_2024`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://de-zoomcamp-hw3-atish/yellow_tripdata_2024-*.parquet']
);

-- Create table for 2024 Yellow TAXI DATA from external table
CREATE OR REPLACE TABLE `ny_taxi.yellow_taxidata_2024` AS
SELECT * FROM `ny_taxi.external_yellow_taxidata_2024`;

SELECT * FROM `ny_taxi.yellow_taxidata_2024`
LIMIT 10;

-- Count of records for 2024 Yellow Taxi Data
SELECT COUNT(*)
FROM `ny_taxi.yellow_taxidata_2024`;

-- Query to count distinct number of PULocationIDs
-- External Table
SELECT COUNT( DISTINCT PULocationID)
FROM `ny_taxi.external_yellow_taxidata_2024`;

-- Regular Table
SELECT COUNT( DISTINCT PULocationID)
FROM `ny_taxi.yellow_taxidata_2024`;

-- Retrieving from regular table
SELECT DISTINCT PULocationID
FROM `ny_taxi.yellow_taxidata_2024`;

SELECT DISTINCT PULocationID, DOLocationID
FROM `ny_taxi.yellow_taxidata_2024`;


-- Count of records having fare_amount = 0
SELECT COUNT(*)
FROM `ny_taxi.yellow_taxidata_2024`
WHERE fare_amount = 0;

-- Best strategy if your query will always filter based on tpep_dropoff_datetime and order the results by VendorID
-- Partition by tpep_dropoff_datetime and cluster by VendorID 
CREATE OR REPLACE TABLE `ny_taxi.yellow_taxidata_2024_partitioned_clusterd`
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID AS
  SELECT * FROM `ny_taxi.external_yellow_taxidata_2024`;

-- query to retrieve the distinct VendorIDs between tpep_dropoff_datetime 2024-03-01 and 2024-03-15 (inclusive)
-- From regular table
SELECT DISTINCT VendorID
FROM `ny_taxi.yellow_taxidata_2024`
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15';

-- From partitioned and clustered table
SELECT DISTINCT VendorID
FROM `ny_taxi.yellow_taxidata_2024_partitioned_clusterd`
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15';

-- Count of records in regular table
SELECT COUNT(*)
FROM `ny_taxi.yellow_taxidata_2024`;