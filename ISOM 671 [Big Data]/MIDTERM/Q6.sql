DROP SCHEMA IF EXISTS midtermq6;
CREATE SCHEMA midtermq6;
use midtermq6;
CREATE TABLE Dim_Time (
    Time_ID INT PRIMARY KEY AUTO_INCREMENT,
    DayOfWeek VARCHAR(20),
    HourOfDay INT
);
CREATE TABLE Dim_Location (
    Location_ID INT PRIMARY KEY AUTO_INCREMENT,
    Country VARCHAR(50),
    City VARCHAR(50)
);
CREATE TABLE Dim_OpenAI_Feature (
    Feature_ID INT PRIMARY KEY AUTO_INCREMENT,
    FeatureName VARCHAR(50)
);
CREATE TABLE Fact_OpenAI_Usage (
    OpenAI_Usage_ID INT PRIMARY KEY AUTO_INCREMENT,
    Time_ID INT,
    Location_ID INT,
    Feature_ID INT,
    Usage_Count INT,
    FOREIGN KEY (Time_ID) REFERENCES Dim_Time(Time_ID),
    FOREIGN KEY (Location_ID) REFERENCES Dim_Location(Location_ID),
    FOREIGN KEY (Feature_ID) REFERENCES Dim_OpenAI_Feature(Feature_ID)
);