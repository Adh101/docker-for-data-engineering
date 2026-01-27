# Module 1 Homework: Docker & SQL

## Question 1. Understanding Docker images

Run docker with the `python:3.13` image. Use an entrypoint `bash` to interact with the container.

What's the version of `pip` in the image?

- 25.3
- 24.3.1
- 24.2.1
- 23.3.1

### Solution:
To run the docker container with 'python:3.13' image:
`docker run -t --rm --entrypoint=bash python:3.13`

To check the `pip` version:
`pip --version`

## Question 3. For the trips in November 2025, how many trips had a trip_distance of less than or equal to 1 mile? 
### Solution:

```
SELECT COUNT(*)
FROM trips_2025_11
WHERE (DATE(lpep_pickup_datetime) >= DATE '2025-11-01' AND DATE(lpep_pickup_datetime) < DATE '2025-12-01')
	AND trip_distance <= 1;
```

## Question 4. Which was the pick up day with the longest trip distance? Only consider trips with trip_distance less than 100 miles. 
### Solution:

`SELECT MAX(trip_distance) AS max_distance,
		lpep_pickup_datetime
FROM trips_2025_11
WHERE trip_distance < 100
GROUP BY 2
ORDER BY 1 DESC;`

## Question 5. Which was the pickup zone with the largest total_amount (sum of all trips) on November 18th, 2025?
### Solution:
`WITH trips AS(
	SELECT *
	FROM trips_2025_11
	WHERE DATE(lpep_pickup_datetime) = DATE '2025-11-18'
	)
SELECT
	z."Zone" AS pickup_zone,
	SUM(t."total_amount") AS total_amount
FROM trips AS t
	JOIN taxi_zones AS z
	ON t."PULocationID" = z."LocationID"
WHERE z."Zone" = "East Harlem North"
GROUP BY 1
ORDER BY 2 DESC;`

## Question 6. For the passengers picked up in the zone named "East Harlem North" in November 2025, which was the drop off zone that had the largest tip? 
### Solution:
`WITH nov_trips AS (
    SELECT *
    FROM trips_2025_11
    WHERE DATE("lpep_pickup_datetime") >= DATE '2025-11-01'
      AND DATE("lpep_pickup_datetime") < DATE '2025-12-01'
)
SELECT
    z."Zone" AS drop_off_zone,
    MAX(t."tip_amount") AS largest_tip
FROM nov_trips AS t
JOIN taxi_zones AS z
    ON t."DOLocationID" = z."LocationID"
WHERE z."Zone" = 'East Harlem North'
GROUP BY 1
ORDER BY 2 DESC;`
