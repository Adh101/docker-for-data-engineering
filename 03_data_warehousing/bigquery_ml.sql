-- BigQuery ML on yellow_taxidata_2024
-- SELECT THE COLUMS (Features)
SELECT passenger_count, trip_distance, PULocationID, DOLocationID, payment_type, fare_amount, tolls_amount, tip_amount
FROM `ny_taxi.yellow_taxidata_2024`
WHERE fare_amount != 0;

-- Create a ML table to train the model on
CREATE OR REPLACE TABLE `ny_taxi.yellow_tripdata_ml` (
`passenger_count` INTEGER,
`trip_distance` FLOAT64,
`PULocationID` STRING,
`DOLocationID` STRING,
`payment_type` STRING,
`fare_amount` FLOAT64,
`tolls_amount` FLOAT64,
`tip_amount` FLOAT64
) AS (
SELECT passenger_count, trip_distance, cast(PULocationID AS STRING), CAST(DOLocationID AS STRING),
CAST(payment_type AS STRING), fare_amount, tolls_amount, tip_amount
FROM `ny_taxi.yellow_taxidata_2024` WHERE fare_amount != 0
);

-- CREATE THE MODEL WITH DEFAULT SETTINGS
CREATE OR REPLACE MODEL `ny_taxi.tip_model`
OPTIONS (
            model_type = 'linear_reg',
            input_label_cols = ['tip_amount'],
            DATA_SPLIT_METHOD = 'AUTO_SPLIT'
        ) AS
        SELECT *
        FROM `ny_taxi.yellow_tripdata_ml`
        WHERE tip_amount IS NOT NULL;


-- MODEL FEATURES
SELECT *
FROM ML.FEATURE_INFO(MODEL `ny_taxi.tip_model`);

-- EVALUATE THE MODEL
SELECT *
FROM ML.EVALUATE(MODEL `ny_taxi.tip_model`, 
                                            (
                                              SELECT * FROM `ny_taxi.yellow_tripdata_ml`
                                              WHERE tip_amount IS NOT NULL
                                            )
);

-- PREDICT THE MODEL
SELECT *
FROM ML.PREDICT(MODEL `ny_taxi.tip_model`, 
                                            (
                                              SELECT * FROM `ny_taxi.yellow_tripdata_ml`
                                              WHERE tip_amount IS NOT NULL
                                            )
);

-- PREDICT AND EXPLAIN
SELECT *
FROM ML.EXPLAIN_PREDICT(MODEL `ny_taxi.tip_model`, 
                                            (
                                              SELECT * FROM `ny_taxi.yellow_tripdata_ml`
                                              WHERE tip_amount IS NOT NULL
                                            ),
                                            STRUCT(3 AS top_k_features)
);

-- HYPER PARAMETER TUNING
CREATE OR REPLACE MODEL `ny_taxi.tip_hyperparam_model`
OPTIONS (
          model_type = 'linear_reg',
          input_label_cols = ['tip_amount'],
          DATA_SPLIT_METHOD = 'AUTO_SPLIT',
          num_trials = 5,
          max_parallel_trials = 2,
          l1_reg = hparam_range(0,20),
          l2_reg = hparam_candidates([0,0.1,1,10])
) AS
      SELECT *
      FROM `ny_taxi.yellow_tripdata_ml`
      WHERE tip_amount IS NOT NULL;

-- MODEL FEATURES
SELECT *
FROM ML.FEATURE_INFO(MODEL `ny_taxi.tip_hyperparam_model`);

-- EVALUATE THE MODEL
SELECT *
FROM ML.EVALUATE(MODEL `ny_taxi.tip_hyperparam_model`, 
                                            (
                                              SELECT * FROM `ny_taxi.yellow_tripdata_ml`
                                              WHERE tip_amount IS NOT NULL
                                            )
);

-- PREDICT THE MODEL
SELECT *
FROM ML.PREDICT(MODEL `ny_taxi.tip_hyperparam_model`, 
                                            (
                                              SELECT * FROM `ny_taxi.yellow_tripdata_ml`
                                              WHERE tip_amount IS NOT NULL
                                            )
);

-- PREDICT AND EXPLAIN
SELECT *
FROM ML.EXPLAIN_PREDICT(MODEL `ny_taxi.tip_hyperparam_model`, 
                                            (
                                              SELECT * FROM `ny_taxi.yellow_tripdata_ml`
                                              WHERE tip_amount IS NOT NULL
                                            ),
                                            STRUCT(3 AS top_k_features)
);