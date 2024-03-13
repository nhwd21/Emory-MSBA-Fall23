DROP SCHEMA IF EXISTS happiness;
CREATE SCHEMA happiness;
use happiness;

DROP TABLE IF EXISTS `2015`;
CREATE TABLE `happiness`.`2015` (
    `Country` TEXT,
    `Region` TEXT,
    `HappinessRank` INT NOT NULL PRIMARY KEY,
    `HappinessScore` DOUBLE,
    `StandardError` DOUBLE,
    `Economy` DOUBLE,
    `Family` DOUBLE,
    `Health` DOUBLE,
    `Freedom` DOUBLE,
    `Trust` DOUBLE,
    `Generosity` DOUBLE,
    `DystopiaResidual` DOUBLE
);
LOAD DATA LOCAL INFILE 'C:/Users/foste/Downloads/worldhappiness/2015.csv'
INTO TABLE `happiness`.`2015`
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; 

DROP TABLE IF EXISTS `2016`;
CREATE TABLE `happiness`.`2016` (
    `Country` TEXT,
    `Region` TEXT,
    `HappinessRank` INT NOT NULL PRIMARY KEY,
    `HappinessScore` DOUBLE,
    `LowerConfidenceInterval` DOUBLE,
    `UpperConfidenceInterval` DOUBLE,
    `Economy` DOUBLE,
    `Family` DOUBLE,
    `Health` DOUBLE,
    `Freedom` DOUBLE,
    `Trust` DOUBLE,
    `Generosity` DOUBLE,
    `DystopiaResidual` DOUBLE
);
LOAD DATA LOCAL INFILE 'C:/Users/foste/Downloads/worldhappiness/2016.csv'
INTO TABLE `happiness`.`2016`
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

DROP TABLE IF EXISTS `2017`;
CREATE TABLE `happiness`.`2017` (
    `Country` TEXT,
    `HappinessRank` INT NOT NULL PRIMARY KEY,
    `HappinessScore` DOUBLE,
    `WhiskerHigh` DOUBLE,
    `WhiskerLow` DOUBLE,
    `Economy` DOUBLE,
    `Family` DOUBLE,
    `Health` DOUBLE,
    `Freedom` DOUBLE,
    `Generosity` DOUBLE,
    `Trust` DOUBLE,
    `DystopiaResidual` DOUBLE
);
LOAD DATA LOCAL INFILE 'C:\\Users\\foste\\Downloads\\worldhappiness\\2017.csv'
INTO TABLE `happiness`.`2017`
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

DROP TABLE IF EXISTS `2018`;
CREATE TABLE `happiness`.`2018` (
    `OverallRank` INT NOT NULL PRIMARY KEY,
    `CountryOrRegion` TEXT,
    `Score` DOUBLE,
    `GDPPerCapita` DOUBLE,
    `SocialSupport` DOUBLE,
    `HealthyLifeExpectancy` DOUBLE,
    `Freedom` DOUBLE,
    `Generosity` DOUBLE,
    `PerceptionOfCorruption` DOUBLE NULL
);
LOAD DATA LOCAL INFILE 'C:\\Users\\foste\\Downloads\\worldhappiness\\2018.csv'
INTO TABLE `happiness`.`2018`
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

DROP TABLE IF EXISTS `2019`;
CREATE TABLE `happiness`.`2019` (
    `OverallRank` INT NOT NULL PRIMARY KEY,
    `CountryOrRegion` TEXT,
    `Score` DOUBLE,
    `GDPPerCapita` DOUBLE,
    `SocialSupport` DOUBLE,
    `HealthyLifeExpectancy` DOUBLE,
    `Freedom` DOUBLE,
    `Generosity` DOUBLE,
    `PerceptionsOfCorruption` DOUBLE
);
LOAD DATA LOCAL INFILE 'C:\\Users\\foste\\Downloads\\worldhappiness\\2019.csv'
INTO TABLE `happiness`.`2019`
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
