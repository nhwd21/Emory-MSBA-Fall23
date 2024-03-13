CREATE SCHEMA midtermq5;
USE midtermq5;

# Q 5.1 - 3NF

# Assumptions:
# Each sport has only one head coach.
# Each game is played at one facility.
# Each team plays in one sport.
# Each game is between two teams.
# Each customer can buy multiple tickets for a game or multiple season tickets.
# The price for a game ticket can vary for each transaction.
# Each game is associated with one specific sport.
# Each facility hosts multiple games.

CREATE TABLE Sports (
    SportID INT PRIMARY KEY,
    SportName VARCHAR(255),
    Description TEXT,
    YearEstablished INT
);

CREATE TABLE HeadCoaches (
    CoachID INT PRIMARY KEY,
    SportID INT,
    CoachName VARCHAR(255),
    StartDate DATE,
    EndDate DATE,
    FOREIGN KEY (SportID) REFERENCES Sports(SportID)
);

CREATE TABLE Facilities (
    FacilityID INT PRIMARY KEY,
    FacilityName VARCHAR(255),
    Capacity INT,
    DateOfConstruction DATE,
    Location VARCHAR(255),
    LastInspectionDate DATE
);

CREATE TABLE Teams (
    TeamID INT PRIMARY KEY,
    TeamName VARCHAR(255),
    SportID INT,
    FacilityID INT,
    FOREIGN KEY (SportID) REFERENCES Sports(SportID),
    FOREIGN KEY (FacilityID) REFERENCES Facilities(FacilityID)
);

CREATE TABLE Games (
    GameID INT PRIMARY KEY,
    GameDate DATE,
    FinalScoreEmory INT,
    FinalScoreOpponent INT,
    IsHomeGame BOOLEAN,
    SportID INT,
    TeamID INT,
    FacilityID INT,
    GameType VARCHAR(50),
    Attendance INT,
    FOREIGN KEY (SportID) REFERENCES Sports(SportID),
    FOREIGN KEY (TeamID) REFERENCES Teams(TeamID),
    FOREIGN KEY (FacilityID) REFERENCES Facilities(FacilityID)
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    StreetAddress VARCHAR(255),
    City VARCHAR(255),
    State VARCHAR(255),
    Zip VARCHAR(10),
    Email VARCHAR(255),
    Telephone VARCHAR(20)
);

CREATE TABLE SeasonTickets (
    SeasonTicketID INT PRIMARY KEY,
    CustomerID INT,
    SportID INT,
    NumberOfTickets INT,
    Price DECIMAL(10, 2),  -- Assuming price is in decimal format
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (SportID) REFERENCES Sports(SportID)
);

CREATE TABLE GameTickets (
    GameTicketID INT PRIMARY KEY,
    CustomerID INT,
    GameID INT,
    NumberOfTickets INT,
    PricePerTicket DECIMAL(10, 2),  -- Assuming price is in decimal format
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (GameID) REFERENCES Games(GameID)
);

# Q 5.2 -  STAR Schema ########################################################################################################################################
-- In this model, the GameTicketSales fact table captures individual ticket sale transactions at the granularity of each ticket sold. 
-- The fact table is linked to various dimension tables through foreign key relationships, allowing for multi-dimensional analysis based 
-- on different attributes like sport, opponent, facility, customer details, and game specifics.
-- This schema enables the Emory University analytics team to easily conduct ad hoc analyses and answer the specified questions 
-- related to ticket sales for different sports games.

-- Creating Sport Dimension Table
CREATE TABLE Sport_dim (
    SportID INT PRIMARY KEY,
    SportName VARCHAR(255)
);

-- Creating Opponent Dimension Table
CREATE TABLE Opponent_dim (
    OpponentID INT PRIMARY KEY,
    OpponentName VARCHAR(255)
);

-- Creating Facility Dimension Table
CREATE TABLE Facility_dim (
    FacilityID INT PRIMARY KEY,
    FacilityName VARCHAR(255),
    Capacity INT,
    Location VARCHAR(255),
    DateOfConstruction DATE,
    DateOfLastInspection DATE
);

-- Creating Customer Dimension Table
CREATE TABLE Customer_dim (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(255),
    LastName VARCHAR(255),
    StreetAddress VARCHAR(255),
    City VARCHAR(255),
    State VARCHAR(255),
    ZipCode VARCHAR(10),
    Email VARCHAR(255),
    Telephone VARCHAR(20)
);

-- Creating Game Dimension Table
CREATE TABLE Game_dim (
    GameID INT PRIMARY KEY,
    SportID INT,
    GameDate DATETIME,
    IsHomeGame BOOLEAN,
    GameType VARCHAR(50),
    FOREIGN KEY (SportID) REFERENCES Sport_dim(SportID)
);

-- Creating GameTicketSales Fact Table
CREATE TABLE GameTicketSales_fact (
    TicketSaleID INT PRIMARY KEY,
    GameID INT,
    CustomerID INT,
    OpponentID INT,
    SaleDate DATETIME,
    SaleAmount DECIMAL(10, 2),
    NumberOfTickets INT,
    FacilityID INT,
    PurchaseAdvanceDays INT,
    FOREIGN KEY (GameID) REFERENCES Game_dim(GameID),
    FOREIGN KEY (CustomerID) REFERENCES Customer_dim(CustomerID),
    FOREIGN KEY (OpponentID) REFERENCES Opponent_dim(OpponentID),
    FOREIGN KEY (FacilityID) REFERENCES Facility_dim(FacilityID)
);
