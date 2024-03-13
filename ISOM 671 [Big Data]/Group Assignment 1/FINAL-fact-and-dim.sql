USE yelp;

DROP TABLE IF EXISTS Dim_business;
CREATE TABLE Dim_Business (
    business_id VARCHAR(255) PRIMARY KEY NOT NULL,
    `name` TEXT,
    neighborhood TEXT,
    address TEXT,
    city TEXT,
    state TEXT,
    postal_code VARCHAR(255),
    latitude DOUBLE,
    longitude DOUBLE,
    stars DOUBLE,
    review_count INT,
    is_open INT,
    categories TEXT
);
INSERT INTO Dim_Business (business_id, name, neighborhood, address, city, state, postal_code, latitude, longitude, stars, review_count, is_open, categories)
SELECT business_id, name, neighborhood, address, city, state, postal_code, latitude, longitude, stars, review_count, is_open, categories
FROM yelp_business;


DROP TABLE IF EXISTS Dim_Checkin;
CREATE TABLE Dim_Checkin (
    checkin_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    business_id VARCHAR(255) NOT NULL,
    `weekday` TEXT,
    hour_start VARCHAR(50) DEFAULT NULL,
    hour_end VARCHAR(50) DEFAULT NULL,
    checkins INT,
    FOREIGN KEY (business_id) REFERENCES Dim_Business(business_id)
);
INSERT INTO Dim_Checkin (business_id, `weekday`, hour_start, hour_end, checkins)
SELECT
    ybh.business_id,
    CASE
        WHEN ybh.monday IS NOT NULL THEN 'Monday'
        WHEN ybh.tuesday IS NOT NULL THEN 'Tuesday'
        WHEN ybh.wednesday IS NOT NULL THEN 'Wednesday'
        WHEN ybh.thursday IS NOT NULL THEN 'Thursday'
        WHEN ybh.friday IS NOT NULL THEN 'Friday'
        WHEN ybh.saturday IS NOT NULL THEN 'Saturday'
        WHEN ybh.sunday IS NOT NULL THEN 'Sunday'
    END AS weekday,
    SUBSTRING_INDEX(ybh.monday, '-', 1) AS hour_start,
    COALESCE(NULLIF(SUBSTRING_INDEX(ybh.monday, '-', -1), ''), '24:00') AS hour_end,
    COUNT(*) AS checkins
FROM
    yelp_business_hours ybh
WHERE
    ybh.monday IS NOT NULL OR
    ybh.tuesday IS NOT NULL OR
    ybh.wednesday IS NOT NULL OR
    ybh.thursday IS NOT NULL OR
    ybh.friday IS NOT NULL OR
    ybh.saturday IS NOT NULL OR
    ybh.sunday IS NOT NULL
GROUP BY
    ybh.business_id,
    weekday,
    hour_start,
    hour_end;

DROP TABLE IF EXISTS Dim_User;
CREATE TABLE Dim_User (
    user_id VARCHAR(255) PRIMARY KEY NOT NULL,
    name TEXT,
    review_count INT,
    yelping_since TEXT,
    friends LONGTEXT,
    useful INT,
    funny INT,
    cool INT,
    fans INT,
    elite TEXT,
    average_stars DOUBLE,
    compliment_hot INT,
    compliment_more INT,
    compliment_profile INT,
    compliment_cute INT,
    compliment_list INT,
    compliment_note INT,
    compliment_plain JSON,
    compliment_cool INT,
    compliment_funny INT,
    compliment_writer INT,
    compliment_photos INT
);
INSERT INTO Dim_User (user_id, `name`, review_count, yelping_since, friends, useful, funny, cool, fans, elite, average_stars, compliment_hot, compliment_more, compliment_profile, compliment_cute, compliment_list, compliment_note, compliment_plain, compliment_cool, compliment_funny, compliment_writer, compliment_photos)
SELECT user_id, `name`, review_count, yelping_since, friends, useful, funny, cool, fans, elite, average_stars, compliment_hot, compliment_more, compliment_profile, compliment_cute, compliment_list, compliment_note, compliment_plain, compliment_cool, compliment_funny, compliment_writer, compliment_photos
FROM yelp_user;

DROP TABLE IF EXISTS Dim_Review;
CREATE TABLE Dim_Review (
    review_id VARCHAR(255) PRIMARY KEY NOT NULL,
    user_id VARCHAR(255) NOT NULL,
    business_id VARCHAR(255) NOT NULL,
    stars INT,
    `date` TEXT,
    `text` LONGTEXT,
    useful TEXT,
    funny TEXT,
    cool TEXT,
    FOREIGN KEY (user_id) REFERENCES Dim_User(user_id),
    FOREIGN KEY (business_id) REFERENCES Dim_Business(business_id)
);
INSERT INTO Dim_Review (review_id, user_id, business_id, stars, `date`, `text`, useful, funny, cool)
SELECT review_id, user_id, business_id, stars, `date`, `text`, useful, funny, cool
FROM yelp_review;

DROP TABLE IF EXISTS Fact_FootTraffic;
CREATE TABLE Fact_FootTraffic (
    business_id VARCHAR(255) NOT NULL,
    review_id VARCHAR(255) NOT NULL,
    checkin_id INT NOT NULL,
    user_id VARCHAR(255) NOT NULL,
    `date` TEXT,
    stars DOUBLE,
    checkins INT,
    PRIMARY KEY (business_id, review_id, checkin_id, user_id),
    FOREIGN KEY (business_id) REFERENCES Dim_Business(business_id),
    FOREIGN KEY (review_id) REFERENCES Dim_Review(review_id),
    FOREIGN KEY (checkin_id) REFERENCES Dim_Checkin(checkin_id),
    FOREIGN KEY (user_id) REFERENCES Dim_User(user_id)
);
INSERT INTO Fact_FootTraffic (business_id, review_id, checkin_id, user_id, `date`, stars, checkins)
SELECT b.business_id, r.review_id, ch.checkin_id, u.user_id, r.`date`, r.stars, ch.checkins
FROM dim_business b
JOIN dim_review r ON r.business_id = b.business_id
JOIN dim_checkin ch ON ch.business_id = b.business_id
JOIN dim_user u ON u.user_id = r.user_id;