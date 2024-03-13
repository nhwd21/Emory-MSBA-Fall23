DROP SCHEMA IF EXISTS Nobel_key_value;
CREATE DATABASE Nobel_key_value;
USE Nobel_key_value;

CREATE TABLE key_value (
    `key` INT PRIMARY KEY,
    `value` JSON
);

INSERT INTO key_value (`key`, `value`)
VALUES 
(1, '{"awardYear": "1901", "category": {"en": "Chemistry", "no": "Kjemi", "se": "Kemi"}, "categoryFullName": {"en": "The Nobel Prize in Chemistry", "no": "Nobelprisen i kjemi", "se": "Nobelpriset i kemi"}, "prizeAmount": 150782, "prizeAmountAdjusted": 8567159, "links": {"rel": "nobelPrize", "href": "http://masterdataapi.nobelprize.org/2/nobelPrize/che/1901", "action": "Get", "types": "application/json"}, "laureates": [{"id": "160", "knownName": {"en": "Jacobus H. van \'t Hoff"}, "portion": "1", "sortOrder": "1", "motivation": {"en": "in recognition of the extraordinary services he has rendered by the discovery of the laws of chemical dynamics and osmotic pressure in solutions", "se": "såsom ett erkännande av den utomordentliga förtjänst han inlagt genom upptäckten av lagarna för den kemiska dynamiken och för det osmotiska trycket i lösningar"}, "links": {"rel": "laureate", "href": "http://masterdataapi.nobelprize.org/2/laureate/160", "action": "Get", "types": "application/json"}}]}'),
(2, '{"awardYear": "1901", "category": {"en": "Literature", "no": "Litteratur", "se": "Litteratur"}, "categoryFullName": {"en": "The Nobel Prize in Literature", "no": "Nobelprisen i litteratur", "se": "Nobelpriset i litteratur"}, "prizeAmount": 150782, "prizeAmountAdjusted": 8567159, "links": {"rel": "nobelPrize", "href": "http://masterdataapi.nobelprize.org/2/nobelPrize/lit/1901", "action": "Get", "types": "application/json"}, "laureates": [{"id": "569", "knownName": {"en": "Sully Prudhomme"}, "portion": "1", "sortOrder": "1", "motivation": {"en": "in special recognition of his poetic composition, which gives evidence of lofty idealism, artistic perfection and a rare combination of the qualities of both heart and intellect", "se": "såsom ett erkännande av hans utmärkta, jämväl under senare år ådagalagda förtjänster som författare och särskilt av hans om hög idealitet, konstnärlig fulländning samt sällspord förening av hjärtats och snillets egenskaper vittnande diktning"}}]}'),
(3, '{"awardYear": "1901", "category": {"en": "Peace", "no": "Fred", "se": "Fred"}, "categoryFullName": {"en": "The Nobel Peace Prize", "no": "Nobels fredspris", "se": "Nobels fredspris"}, "dateAwarded": "1901-12-10", "prizeAmount": 150782, "prizeAmountAdjusted": 8567159, "links": {"rel": "nobelPrize", "href": "http://masterdataapi.nobelprize.org/2/nobelPrize/pea/1901", "action": "Get", "types": "application/json"}, "laureates": [{"id": "462", "knownName": {"en": "Henry Dunant"}, "portion": "1/2", "sortOrder": "1", "motivation": {"en": "for his humanitarian efforts to help wounded soldiers and create international understanding", "no": "for sin humanitære innsats for å hjelpe sårede soldater og skape internasjonal forståelse"}}, {"id": "463", "knownName": {"en": "Frédéric Passy"}, "portion": "1/2", "sortOrder": "2", "motivation": {"en": "for his lifelong work for international peace conferences, diplomacy and arbitration", "no": "for sin  livslange innsats for internasjonale fredskonferanser, diplomati og voldgift"}}]}' );

DROP SCHEMA IF EXISTS Nobel_document;
CREATE DATABASE Nobel_document;
USE Nobel_document;

CREATE TABLE nobel_data (
    `id` INT PRIMARY KEY,
    `awardYear` INT,
    `category_en` VARCHAR(255),
    `category_no` VARCHAR(255),
    `category_se` VARCHAR(255),
    `categoryFullName_en` VARCHAR(255),
    `categoryFullName_no` VARCHAR(255),
    `categoryFullName_se` VARCHAR(255),
    `prizeAmount` INT,
    `prizeAmountAdjusted` INT,
    `links_rel` VARCHAR(255),
    `links_href` VARCHAR(255),
    `links_action` VARCHAR(255),
    `links_types` VARCHAR(255),
    `laureates_id` INT,
    `laureates_knownName_en` VARCHAR(255),
    `laureates_portion` VARCHAR(255),
    `laureates_sortOrder` VARCHAR(255),
    `laureates_motivation_en` TEXT,
    `laureates_motivation_no` TEXT,
    `laureates_links_rel` VARCHAR(255),
    `laureates_links_href` VARCHAR(255),
    `laureates_links_action` VARCHAR(255),
    `laureates_links_types` VARCHAR(255)
);

INSERT INTO nobel_data (`id`, `awardYear`, `category_en`, `category_no`, `category_se`, `categoryFullName_en`, `categoryFullName_no`, `categoryFullName_se`, `prizeAmount`, `prizeAmountAdjusted`, `links_rel`, `links_href`, `links_action`, `links_types`, `laureates_id`, `laureates_knownName_en`, `laureates_portion`, `laureates_sortOrder`, `laureates_motivation_en`, `laureates_motivation_no`, `laureates_links_rel`, `laureates_links_href`, `laureates_links_action`, `laureates_links_types`)
VALUES 
(1, 1901, 'Chemistry', 'Kjemi', 'Kemi', 'The Nobel Prize in Chemistry', 'Nobelprisen i kjemi', 'Nobelpriset i kemi', 150782, 8567159, 'nobelPrize', 'http://masterdataapi.nobelprize.org/2/nobelPrize/che/1901', 'Get', 'application/json', 160, 'Jacobus H. van \'t Hoff', '1', '1', 'in recognition of the extraordinary services he has rendered by the discovery of the laws of chemical dynamics and osmotic pressure in solutions', 'såsom ett erkännande av den utomordentliga förtjänst han inlagt genom upptäckten av lagarna för den kemiska dynamiken och för det osmotiska trycket i lösningar', 'laureate', 'http://masterdataapi.nobelprize.org/2/laureate/160', 'Get', 'application/json'),
(2, 1901, 'Literature', 'Litteratur', 'Litteratur', 'The Nobel Prize in Literature', 'Nobelprisen i litteratur', 'Nobelpriset i litteratur', 150782, 8567159, 'nobelPrize', 'http://masterdataapi.nobelprize.org/2/nobelPrize/lit/1901', 'Get', 'application/json', 569, 'Sully Prudhomme', '1', '1', 'in special recognition of his poetic composition, which gives evidence of lofty idealism, artistic perfection and a rare combination of the qualities of both heart and intellect', 'såsom ett erkännande av hans utmärkta, jämväl under senare år ådagalagda förtjänster som författare och särskilt av hans om hög idealitet, konstnärlig fulländning samt sällspord förening av hjärtats och snillets egenskaper vittnande diktning', 'laureate', 'http://masterdataapi.nobelprize.org/2/laureate/569', 'Get', 'application/json'),
(3, 1901, 'Peace', 'Fred', 'Fred', 'The Nobel Peace Prize', 'Nobels fredspris', 'Nobels fredspris', 150782, 8567159, 'nobelPrize', 'http://masterdataapi.nobelprize.org/2/nobelPrize/pea/1901', 'Get', 'application/json', 462, 'Henry Dunant', '1/2', '1', 'for his humanitarian efforts to help wounded soldiers and create international understanding', 'for sin humanitære innsats for å hjelpe sårede soldater og skape internasjonal forståelse', 'laureate', 'http://masterdataapi.nobelprize.org/2/laureate/462', 'Get', 'application/json'),
(4, 1901, 'Peace', 'Fred', 'Fred', 'The Nobel Peace Prize', 'Nobels fredspris', 'Nobels fredspris', 150782, 8567159, 'nobelPrize', 'http://masterdataapi.nobelprize.org/2/nobelPrize/pea/1901', 'Get', 'application/json', 463, 'Frédéric Passy', '1/2', '2', 'for his lifelong work for international peace conferences, diplomacy and arbitration', 'for sin  livslange innsats for internasjonale fredskonferanser, diplomati og voldgift', 'laureate', 'http://masterdataapi.nobelprize.org/2/laureate/463', 'Get', 'application/json');

DROP SCHEMA IF EXISTS Nobel_column;
CREATE DATABASE Nobel_column;
USE Nobel_column;

# Create multiple tables representing different column families, each with a row key and associated columns.
CREATE TABLE chemistry_awards (
    `id` INT PRIMARY KEY,
    `awardYear` INT,
    `prizeAmount` INT,
    `laureate_id` INT,
    `laureate_knownName_en` VARCHAR(255),
    `laureate_motivation_en` TEXT
);

CREATE TABLE literature_awards (
    `id` INT PRIMARY KEY,
    `awardYear` INT,
    `prizeAmount` INT,
    `laureate_id` INT,
    `laureate_knownName_en` VARCHAR(255),
    `laureate_motivation_en` TEXT
);

CREATE TABLE peace_awards (
    `id` INT PRIMARY KEY,
    `awardYear` INT,
    `prizeAmount` INT,
    `laureate_id` INT,
    `laureate_knownName_en` VARCHAR(255),
    `laureate_motivation_en` TEXT
);

# Insert data into respective tables.
INSERT INTO chemistry_awards (`id`, `awardYear`, `prizeAmount`, `laureate_id`, `laureate_knownName_en`, `laureate_motivation_en`)
VALUES (1, 1901, 150782, 160, 'Jacobus H. van \'t Hoff', 'in recognition of the extraordinary services he has rendered by the discovery of the laws of chemical dynamics and osmotic pressure in solutions');

INSERT INTO literature_awards (`id`, `awardYear`, `prizeAmount`, `laureate_id`, `laureate_knownName_en`, `laureate_motivation_en`)
VALUES (1, 1901, 150782, 569, 'Sully Prudhomme', 'in special recognition of his poetic composition, which gives evidence of lofty idealism, artistic perfection and a rare combination of the qualities of both heart and intellect');

INSERT INTO peace_awards (`id`, `awardYear`, `prizeAmount`, `laureate_id`, `laureate_knownName_en`, `laureate_motivation_en`)
VALUES (1, 1901, 150782, 462, 'Henry Dunant', 'for his humanitarian efforts to help wounded soldiers and create international understanding');

INSERT INTO peace_awards (`id`, `awardYear`, `prizeAmount`, `laureate_id`, `laureate_knownName_en`, `laureate_motivation_en`)
VALUES (2, 1901, 150782, 463, 'Frédéric Passy', 'for his lifelong work for international peace conferences, diplomacy and arbitration');

# Query Results for the assignment
USE Nobel_key_value;
SELECT JSON_EXTRACT(`value`, '$.category.en') AS award_type, 
       JSON_EXTRACT(`value`, '$.laureates[0].knownName.en') AS award_winner 
FROM key_value 
WHERE JSON_EXTRACT(`value`, '$.awardYear') = '1901';

USE Nobel_document;
SELECT `category_en` AS award_type, 
       `laureates_knownName_en` AS award_winner 
FROM nobel_data 
WHERE `awardYear` = 1901;

USE Nobel_column;
SELECT `awardYear` AS award_year, 
       `laureate_knownName_en` AS award_winner 
FROM chemistry_awards 
WHERE `awardYear` = 1901;

SELECT `awardYear` AS award_year, 
       `laureate_knownName_en` AS award_winner 
FROM literature_awards 
WHERE `awardYear` = 1901;

SELECT `awardYear` AS award_year, 
       `laureate_knownName_en` AS award_winner 
FROM peace_awards 
WHERE `awardYear` = 1901;
