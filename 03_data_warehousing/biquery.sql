-- Create the external table for yellow taxi data
CREATE OR REPLACE EXTERNAL TABLE `zoomcamp.external_yellow_tripdata`
  OPTIONS (
    format = 'CSV',
    uris = ['gs://kestra-atish-demo/yellow_tripdata_2019-*.csv','gs://kestra-atish-demo/yellow_tripdata_2020-*.csv','gs://kestra-atish-demo/yellow_tripdata_2021-*.csv']
);

-- Create the external table for green taxi data
CREATE OR REPLACE EXTERNAL TABLE `zoomcamp.external_green_tripdata` 
OPTIONS (
    format = 'CSV',
    uris = ['gs://kestra-atish-demo/green_tripdata_2019-*.csv','gs://kestra-atish-demo/green_tripdata_2020-*.csv','gs://kestra-atish-demo/green_tripdata_2021-*.csv']
);

-- Checking the external table
SELECT * FROM `zoomcamp.external_yellow_tripdata`
LIMIT 100;

SELECT * FROM `zoomcamp.external_green_tripdata`
LIMIT 100;

-- Creating a non partiitioned table from external table
CREATE OR REPLACE TABLE `zoomcamp.yellow_tripdata_non_partitioned` AS
SELECT * FROM `zoomcamp.external_yellow_tripdata`;

-- Creating the partitioned table
CREATE OR REPLACE TABLE `zoomcamp.yellow_tripdata_partitioned`
PARTITION BY 
  DATE(tpep_pickup_datetime) AS
SELECT * FROM `zoomcamp.external_yellow_tripdata`;

--- Impact of Partition
SELECT DISTINCT(VendorID)
FROM `zoomcamp.yellow_tripdata_non_partitioned`
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2019-06-30';

SELECT DISTINCT(VendorID)
FROM `zoomcamp.yellow_tripdata_partitioned`
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2019-06-30';

-- Exploring the partitions
SELECT table_name, partition_id, total_rows
FROM `zoomcamp.INFORMATION_SCHEMA.PARTITIONS`
WHERE table_name = 'yellow_tripdata_partitioned';

-- Partitioning and Clustering
CREATE OR REPLACE TABLE `zoomcamp.yellow_tripdata_partitioned_clustered`
PARTITION BY 
  DATE(tpep_pickup_datetime)
CLUSTER BY VendorID AS
SELECT * FROM `zoomcamp.external_yellow_tripdata`;

-- Query scans 1.1 GB
SELECT count(*) as trips
FROM `zoomcamp.yellow_tripdata_partitioned`
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2020-12-31'
  AND VendorID=1;

-- Query scans 864.5 MB
SELECT count(*) as trips
FROM `zoomcamp.yellow_tripdata_partitioned_clustered`
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2020-12-31'
  AND VendorID=1;

-- Limits of Partitions in BigQuery is 4000, and up to 4 clustering columns

