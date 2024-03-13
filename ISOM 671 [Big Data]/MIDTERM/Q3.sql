USE yelp;
SET GLOBAL local_infile=1;

# 3.1 Load Positive and Negative Words Data into Separate Tables: ######################################################################################
DROP TABLE IF EXISTS pos_words;
CREATE TABLE pos_words (words VARCHAR(255) PRIMARY KEY);
LOAD DATA LOCAL INFILE 'C:\\Users\\d_mos\\OneDrive\\Documents\\ISOM 671 [Big Data]\\MIDTERM\\Sentiment\\positive-words.txt' INTO TABLE pos_words FIELDS TERMINATED BY '\n';
DROP TABLE IF EXISTS neg_words;
CREATE TABLE neg_words (words VARCHAR(255) PRIMARY KEY);
LOAD DATA LOCAL INFILE 'C:\\Users\\d_mos\\OneDrive\\Documents\\ISOM 671 [Big Data]\\MIDTERM\\Sentiment\\negative-words.txt' INTO TABLE neg_words FIELDS TERMINATED BY '\n';

# 3.2 Write MySQL User-Defined Functions: ###################################################################################################################
DROP FUNCTION IF EXISTS `yelp`.`CountPositiveWords`;
DELIMITER //
CREATE FUNCTION CountPositiveWords(input_text LONGTEXT) RETURNS INT DETERMINISTIC
BEGIN
    DECLARE word_count INT DEFAULT 0;
    DECLARE positive_word VARCHAR(255);
    DECLARE done INT DEFAULT 0;
    
    -- Declare a cursor to fetch positive words
    DECLARE positive_words_cursor CURSOR FOR
        SELECT words FROM pos_words;
    
    -- Continue fetching words and counting positive words
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN positive_words_cursor;
    
    read_loop: LOOP
        FETCH positive_words_cursor INTO positive_word;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Check if the positive word is present in the input text
        IF LOCATE(positive_word, input_text) > 0 THEN
            SET word_count = word_count + 1;
        END IF;
    END LOOP;
    
    CLOSE positive_words_cursor;
    
    RETURN word_count;
END//
DELIMITER ;

DROP FUNCTION IF EXISTS `yelp`.`CountNegativeWords`;
DELIMITER //

CREATE FUNCTION CountNegativeWords(input_text LONGTEXT) RETURNS INT DETERMINISTIC 
BEGIN
    DECLARE word_count INT DEFAULT 0;
    DECLARE current_word VARCHAR(255);
    DECLARE done INT DEFAULT 0;
    DECLARE neg_word_cursor CURSOR FOR 
        SELECT words FROM neg_words;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Remove punctuation and split input_text into words
    SET input_text = REGEXP_REPLACE(input_text, '[[:punct:]]', ' ');
    SET input_text = TRIM(BOTH ' ' FROM input_text);
    SET input_text = CONCAT(' ', input_text, ' ');

    OPEN neg_word_cursor;

    word_loop: LOOP
        FETCH neg_word_cursor INTO current_word;
        IF done THEN
            LEAVE word_loop;
        END IF;

        -- Check if the negative word exists in the input_text
        IF INSTR(input_text, CONCAT(' ', current_word, ' ')) > 0 THEN
            SET word_count = word_count + 1;
        END IF;
    END LOOP;

    CLOSE neg_word_cursor;

    RETURN word_count;
END //

DELIMITER ;


DROP FUNCTION IF EXISTS `yelp`.`wordcount`;

# this function is credited to user Outis on StackExchange
DELIMITER $$
CREATE FUNCTION wordcount(str LONGTEXT)
       RETURNS INT
       DETERMINISTIC
       SQL SECURITY INVOKER
       NO SQL
  BEGIN
    DECLARE wordCnt, idx, maxIdx INT DEFAULT 0;
    DECLARE currChar, prevChar BOOL DEFAULT 0;
    SET maxIdx=char_length(str);
    SET idx = 1;
    WHILE idx <= maxIdx DO
        SET currChar=SUBSTRING(str, idx, 1) RLIKE '[[:alnum:]]';
        IF NOT prevChar AND currChar THEN
            SET wordCnt=wordCnt+1;
        END IF;
        SET prevChar=currChar;
        SET idx=idx+1;
    END WHILE;
    RETURN wordCnt;
  END
$$
DELIMITER ;

# 3.3 Find Top 5 Businesses with Highest Average Positive and Negative Words: ####################################################################################
# I created a table with the first 1000 entries in yelp_review. 
# Given the massive size of the yelp_review table, the query would take far too long to finish in today's allotted time
DROP TABLE IF EXISTS yelp_review_small;
CREATE TABLE `yelp_review_small` (
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
INSERT INTO `yelp_review_small`
SELECT * FROM `yelp_review`
LIMIT 1000;

# Now, test my code using the smaller yelp_review table
SELECT business_id, sentiment, avg_words
FROM (
    (SELECT business_id, 'positive' as sentiment, AVG(CountPositiveWords(text)) AS avg_words
    FROM yelp_review_small
    GROUP BY business_id
    ORDER BY avg_words DESC
    LIMIT 5)
    
    UNION ALL
    
    (SELECT business_id, 'negative' as sentiment, AVG(CountNegativeWords(text)) AS avg_words
    FROM yelp_review_small
    GROUP BY business_id
    ORDER BY avg_words DESC
    LIMIT 5)
) AS subquery;


# 3.4 Calculate Sentiment for Each Review: #########################################################################################################################
-- Calculate sentiment for each review
SELECT 
    review_id,
    `text`,
    (COUNTPOSITIVEWORDS(`text`) - COUNTNEGATIVEWORDS(`text`)) / WORDCOUNT(`text`) AS sentiment
FROM
    yelp_review;