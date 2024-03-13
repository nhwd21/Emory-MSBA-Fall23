# ATTEMPT 6

# SHOW VARIABLES LIKE "secure_file_priv";

use STUDENT_DMOSDEN;

DROP TABLE IF EXISTS airbnb_nyc;
CREATE TABLE airbnb_nyc (
	id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    name TEXT,
    host_id BIGINT,
    host_identity_verified TEXT,
    host_name VARCHAR(255),
    neighbourhood_group TEXT,
    neighbourhood TEXT,
    lat DOUBLE,
    `long` DOUBLE,
    instant_bookable TEXT,
    cancellation_policy TEXT,
    room_type TEXT,
    construction_year DOUBLE,
    price DOUBLE,
    service_fee DOUBLE,
    minimum_nights DOUBLE,
    number_of_reviews DOUBLE,
    last_review TEXT,
    reviews_per_month DOUBLE,
    review_rate_number DOUBLE,
    calculated_host_listings_count INT,
    availability_365 DOUBLE,
    house_rules TEXT
);

LOAD DATA LOCAL INFILE "C:\\Users\\d_mos\\OneDrive\\Documents\\ISOM 671 [Big Data]\\Assigment 1\\airbnb_nyc_clean.csv"
INTO TABLE airbnb_nyc
FIELDS TERMINATED BY ',' -- Use the appropriate delimiter
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'  -- Use '\r\n' for Windows
IGNORE 1 ROWS; -- Skip the header row if it exists

ALTER TABLE airbnb_nyc RENAME COLUMN id TO listing_id;

# Start from scratch -----------------------------------------------------------------------------
USE STUDENT_DMOSDEN;
DROP TABLE IF EXISTS listing;
DROP TABLE IF EXISTS location;
DROP TABLE IF EXISTS neighbourhood_table;
DROP TABLE IF EXISTS user;

# Create users table -----------------------------------------------------------------------------
DROP TABLE IF EXISTS user;
CREATE TABLE user (
	user_id BIGINT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    host_id BIGINT NOT NULL,
    host_name VARCHAR(255) NOT NULL,
    host_identity_verified TEXT,
	calculated_host_listings_count INT
);

INSERT INTO user (host_id, host_name, host_identity_verified, calculated_host_listings_count)
SELECT host_id, host_name, host_identity_verified, calculated_host_listings_count
FROM airbnb_nyc
GROUP BY host_id, host_name;

# create neighbourhoods table --------------------------------------------------------------------------
DROP TABLE IF EXISTS neighbourhood_table;
CREATE TABLE neighbourhood_table (
	neighbourhood varchar(100) PRIMARY KEY NOT NULL,
    neighbourhood_group TEXT
)
AS
SELECT neighbourhood, neighbourhood_group
FROM airbnb_nyc
GROUP BY neighbourhood, neighbourhood_group;

# create locations table -----------------------------------------------------------------------------
DROP TABLE IF EXISTS location;
CREATE TABLE location (
    lat DOUBLE NOT NULL,
    `long` DOUBLE NOT NULL,
    neighbourhood VARCHAR(100)
)
AS
SELECT lat, `long`, neighbourhood
FROM airbnb_nyc
GROUP BY lat, `long`, neighbourhood;

ALTER TABLE location ADD PRIMARY KEY (lat, `long`);

SET foreign_key_checks = 0;
ALTER TABLE location ADD CONSTRAINT
FOREIGN KEY (neighbourhood) REFERENCES neighbourhood_table(neighbourhood);
SET foreign_key_checks = 1;

# create main listing table ----------------------------------------------------------------------------
DROP TABLE IF EXISTS listing;
CREATE TABLE listing (
	listing_id BIGINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	`name` text,
    user_id BIGINT,
    lat DOUBLE,
    `long` DOUBLE,
    instant_bookable TEXT,
    cancellation_policy TEXT,
	room_type text,
	construction_year double,
	price double,
	service_fee double,
	minimum_nights double,
	availability_365 double,
	number_of_reviews double,
	last_review text,
	reviews_per_month double,
	review_rate_number double,
	house_rules text
);

SET foreign_key_checks = 0;
ALTER TABLE listing 
	ADD CONSTRAINT FOREIGN KEY (user_id) REFERENCES user(user_id),
	ADD CONSTRAINT FOREIGN KEY (lat, `long`) REFERENCES location(lat, `long`);
SET foreign_key_checks = 1;

INSERT INTO listing (listing_id, `name`, user_id, lat, `long`, instant_bookable, cancellation_policy, room_type, construction_year, price, service_fee, minimum_nights, availability_365, number_of_reviews, last_review, reviews_per_month, review_rate_number, house_rules)
SELECT
    b.listing_id,
    b.`name`,
    u.user_id,
    b.lat,
    b.`long`,
    b.instant_bookable,
    b.cancellation_policy,
    b.room_type,
    b.construction_year,
    b.price,
    b.service_fee,
    b.minimum_nights,
    b.availability_365,
    b.number_of_reviews,
    b.last_review,
    b.reviews_per_month,
    b.review_rate_number,
    b.house_rules
FROM
    airbnb_nyc AS b
JOIN
    `user` AS u ON b.host_id = u.host_id AND b.host_name = u.host_name;