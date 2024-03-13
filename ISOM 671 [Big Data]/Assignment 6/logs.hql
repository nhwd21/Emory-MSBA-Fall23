-- create external table based on the weblog data we stored in hdfs using our pig script
CREATE EXTERNAL TABLE IF NOT EXISTS weblog_data (
    ipaddress STRING,
    `timestamp` STRING,
    request STRING,
    status_code INT,
    data_size INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION 'hdfs:/user/hadoop/weblog_clean';

-- query the number of times each ipaddress received a 404
SELECT ipaddress, COUNT(*) as error_count
FROM weblog_data
WHERE status_code = 404
GROUP BY ipaddress;