-- create external table nyTaxi
CREATE EXTERNAL TABLE IF NOT EXISTS nyTaxi (
    VendorID INT,
    lpep_pickup_datetime STRING,
    lpep_dropoff_datetime STRING,
    store_and_fwd_flag STRING,
    RatecodeID INT,
    PULocationID INT,
    DOLocationID INT,
    passenger_count INT,
    trip_distance DOUBLE,
    fare_amount DOUBLE,
    extra DOUBLE,
    mta_tax DOUBLE,
    tip_amount DOUBLE,
    tolls_amount DOUBLE,
    ehail_fee STRING,
    improvement_surcharge DOUBLE,
    total_amount DOUBLE,
    payment_type INT,
    trip_type INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION 's3://fm-ga2/tripdata.csv';

-- get distinct rate_code_id from the table
SELECT DISTINCT RatecodeID FROM nyTaxi;

-- show rows where rate_code_id = 1
SELECT * FROM nyTaxi WHERE RatecodeID = 1;