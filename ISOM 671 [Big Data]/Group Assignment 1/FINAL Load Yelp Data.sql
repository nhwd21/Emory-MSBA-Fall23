SET GLOBAL local_infile=1;

DROP SCHEMA IF EXISTS yelp;
CREATE SCHEMA yelp;
USE yelp;

DROP TABLE IF EXISTS yelp_business;
CREATE TABLE `yelp_business` (
    `business_id` VARCHAR(255) PRIMARY KEY NOT NULL,
    `name` TEXT,
    `neighborhood` TEXT,
    `address` TEXT,
    `city` TEXT,
    `state` TEXT,
    `postal_code` VARCHAR(255) DEFAULT NULL,
    `latitude` DECIMAL(14,12),
    `longitude` DOUBLE,
    `stars` DOUBLE,
    `review_count` INT,
    `is_open` INT,
    `categories` TEXT
);
LOAD DATA LOCAL INFILE "yelp_business.csv"
INTO TABLE yelp_business
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES; 

DROP TABLE IF EXISTS yelp_business_attributes;
CREATE TABLE `yelp_business_attributes` (
    `business_id` VARCHAR(255) PRIMARY KEY NOT NULL,
    `AcceptsInsurance` TEXT,
    `ByAppointmentOnly` TEXT,
    `BusinessAcceptsCreditCards` TEXT,
    `BusinessParking_garage` TEXT,
    `BusinessParking_street` TEXT,
    `BusinessParking_validated` TEXT,
    `BusinessParking_lot` TEXT,
    `BusinessParking_valet` TEXT,
    `HairSpecializesIn_coloring` TEXT,
    `HairSpecializesIn_africanamerican` TEXT,
    `HairSpecializesIn_curly` TEXT,
    `HairSpecializesIn_perms` TEXT,
    `HairSpecializesIn_kids` TEXT,
    `HairSpecializesIn_extensions` TEXT,
    `HairSpecializesIn_asian` TEXT,
    `HairSpecializesIn_straightperms` TEXT,
    `RestaurantsPriceRange2` TEXT,
    `GoodForKids` TEXT,
    `WheelchairAccessible` TEXT,
    `BikeParking` TEXT,
    `Alcohol` TEXT,
    `HasTV` TEXT,
    `NoiseLevel` TEXT,
    `RestaurantsAttire` TEXT,
    `Music_dj` TEXT,
    `Music_background_music` TEXT,
    `Music_no_music` TEXT,
    `Music_karaoke` TEXT,
    `Music_live` TEXT,
    `Music_video` TEXT,
    `Music_jukebox` TEXT,
    `Ambience_romantic` TEXT,
    `Ambience_intimate` TEXT,
    `Ambience_classy` TEXT,
    `Ambience_hipster` TEXT,
    `Ambience_divey` TEXT,
    `Ambience_touristy` TEXT,
    `Ambience_trendy` TEXT,
    `Ambience_upscale` TEXT,
    `Ambience_casual` TEXT,
    `RestaurantsGoodForGroups` TEXT,
    `Caters` TEXT,
    `WiFi` TEXT,
    `RestaurantsReservations` TEXT,
    `RestaurantsTakeOut` TEXT,
    `HappyHour` TEXT,
    `GoodForDancing` TEXT,
    `RestaurantsTableService` TEXT,
    `OutdoorSeating` TEXT,
    `RestaurantsDelivery` TEXT,
    `BestNights_monday` TEXT,
    `BestNights_tuesday` TEXT,
    `BestNights_friday` TEXT,
    `BestNights_wednesday` TEXT,
    `BestNights_thursday` TEXT,
    `BestNights_sunday` TEXT,
    `BestNights_saturday` TEXT,
    `GoodForMeal_dessert` TEXT,
    `GoodForMeal_latenight` TEXT,
    `GoodForMeal_lunch` TEXT,
    `GoodForMeal_dinner` TEXT,
    `GoodForMeal_breakfast` TEXT,
    `GoodForMeal_brunch` TEXT,
    `CoatCheck` TEXT,
    `Smoking` TEXT,
    `DriveThru` TEXT,
    `DogsAllowed` TEXT,
    `BusinessAcceptsBitcoin` TEXT,
    `Open24Hours` TEXT,
    `BYOBCorkage` TEXT,
    `BYOB` TEXT,
    `Corkage` TEXT,
    `DietaryRestrictions_dairy-free` TEXT,
    `DietaryRestrictions_gluten-free` TEXT,
    `DietaryRestrictions_vegan` TEXT,
    `DietaryRestrictions_kosher` TEXT,
    `DietaryRestrictions_halal` TEXT,
    `DietaryRestrictions_soy-free` TEXT,
    `DietaryRestrictions_vegetarian` TEXT,
    `AgesAllowed` TEXT,
    `RestaurantsCounterService` TEXT,
    FOREIGN KEY (`business_id`) REFERENCES `yelp_business`(`business_id`)
);
LOAD DATA LOCAL INFILE "yelp_business_attributes.csv"
INTO TABLE yelp_business_attributes
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES; 

DROP TABLE IF EXISTS yelp_business_hours;
CREATE TABLE `yelp_business_hours` (
    `business_id` VARCHAR(255) PRIMARY KEY NOT NULL,
    `monday` TEXT,
    `tuesday` TEXT,
    `wednesday` TEXT,
    `thursday` TEXT,
    `friday` TEXT,
    `saturday` TEXT,
    `sunday` TEXT,
    FOREIGN KEY (`business_id`) REFERENCES `yelp_business`(`business_id`)
);
LOAD DATA LOCAL INFILE "yelp_business_hours.csv"
INTO TABLE yelp_business_hours
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES; 

DROP TABLE IF EXISTS yelp_checkin;
CREATE TABLE `yelp_checkin` (
    `business_id` VARCHAR(255) NOT NULL,
    `weekday` VARCHAR(3) NOT NULL,
    `hour` TIME NOT NULL,
    `checkins` INT,
    PRIMARY KEY (`business_id`, `weekday`, `hour`),
    FOREIGN KEY (`business_id`) REFERENCES `yelp_business`(`business_id`)
);
LOAD DATA LOCAL INFILE "yelp_checkin.csv"
INTO TABLE yelp_checkin
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES; 

DROP TABLE IF EXISTS yelp_user;
CREATE TABLE `yelp_user` (
	`user_id` VARCHAR(255) PRIMARY KEY NOT NULL, 
	`name` text, 
    `review_count` int, 
    `yelping_since` text, 
    `friends` LONGTEXT, 
    `useful` int, 
    `funny` int, 
    `cool` int, 
    `fans` int, 
    `elite` text, 
    `average_stars` double, 
    `compliment_hot` int, 
    `compliment_more` int, 
    `compliment_profile` int, 
    `compliment_cute` int, 
    `compliment_list` int, 
    `compliment_note` int, 
    `compliment_plain` json, 
    `compliment_cool` int, 
    `compliment_funny` int, 
    `compliment_writer` int, 
    `compliment_photos` int
);
LOAD DATA LOCAL INFILE "yelp_user.csv"
INTO TABLE yelp_user
FIELDS TERMINATED BY ',' 
ENCLOSED BY '\"'
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES; 

SET @@global.sql_mode= '';
DROP TABLE IF EXISTS yelp_review;
CREATE TABLE `yelp_review` (
    `review_id` VARCHAR(255) PRIMARY KEY NOT NULL,
    `user_id` VARCHAR(255) NOT NULL,
    `business_id` VARCHAR(255) NOT NULL,
    `stars` INT NULL,
    `date` TEXT NULL,
    `text` LONGTEXT NULL,
    `useful` TEXT NULL,
    `funny` TEXT NULL,
    `cool` TEXT NULL,
    FOREIGN KEY (`user_id`) REFERENCES `yelp_user`(`user_id`),
    FOREIGN KEY (`business_id`) REFERENCES `yelp_business`(`business_id`)
);
LOAD DATA LOCAL INFILE "yelp_review.csv"
INTO TABLE yelp_review
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES; 

DROP TABLE IF EXISTS yelp_tip;
CREATE TABLE `yelp_tip` (
    `text` LONGTEXT DEFAULT NULL,
    `date` DATE DEFAULT NULL,
    `likes` INT DEFAULT NULL,
    `business_id` VARCHAR(255) NOT NULL,
    `user_id` VARCHAR(255) NOT NULL,
    FOREIGN KEY (`business_id`) REFERENCES `yelp_business`(`business_id`),
    FOREIGN KEY (`user_id`) REFERENCES `yelp_user`(`user_id`)
);
LOAD DATA LOCAL INFILE "yelp_tip.csv"
INTO TABLE yelp_tip
FIELDS TERMINATED BY ',' 
ENCLOSED BY '\"'
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES; 