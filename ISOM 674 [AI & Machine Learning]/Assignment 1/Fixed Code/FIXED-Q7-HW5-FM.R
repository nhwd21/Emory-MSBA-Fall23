# Load Data ---------------------------------------------------------------

# Load required library
library(class)
library(FNN)
library(dplyr)
library(tidyr)
# Load the training, validation, and test datasets


# FIXED Setup -------------------------------------------------------------

VarsWanted <- c("SalePrice","Lot.Area","Total.Bsmt.SF","Gr.Liv.Area",
                "Full.Bath","Bedroom.AbvGr","Year.Built")

TrainData <- TrainData[,VarsWanted]
ValData <- ValData[,VarsWanted]
TestData <- TestData[,VarsWanted]

TrainData$Age <- 2010 - TrainData$Year.Built
ValData$Age <- 2010 - ValData$Year.Built
TestData$Age <- 2010 - TestData$Year.Built

# Get rid of Year.Build
TrainData$Year.Built <- NULL
ValData$Year.Built <- NULL
TestData$Year.Built <- NULL


# FIXED Transform Vars ----------------------------------------------------

ValData$Log.Lot.Area <- log(ValData$Lot.Area)
ValData$Sqrt.Total.Bsmt.SF <- sqrt(ValData$Total.Bsmt.SF)
ValData$Log.Gr.Liv.Area <- log(ValData$Gr.Liv.Area)
ValData$Sqrt.Age <- sqrt(ValData$Age)
ValData$Log.SalePrice <- log(ValData$SalePrice)


# Matrix, select columns --------------------------------------------------

train_data <- train_data[,c("SalePrice", "Lot.Area", "Total.Bsmt.SF", "Gr.Liv.Area", "Full.Bath", "Bedroom.AbvGr", "Building.Age")]
train_data <- na.omit(train_data)
train_data_x <- train_data[,2:7]
train_data_y <- train_data[,1]

validation_data <- validation_data[,c("SalePrice", "Lot.Area", "Total.Bsmt.SF", "Gr.Liv.Area", "Full.Bath", "Bedroom.AbvGr", "Building.Age")]
validation_data <- na.omit(validation_data)
validation_data_x <- validation_data[,2:7]
validation_data_y <- validation_data[,1]

test_data <- test_data[,c("SalePrice", "Lot.Area", "Total.Bsmt.SF", "Gr.Liv.Area", "Full.Bath", "Bedroom.AbvGr", "Building.Age")]
test_data <- na.omit(test_data)
test_data_x <- test_data[,2:7]
test_data_y <- test_data[,1]

# Shift The Variables -------------------------------------------------

# create new matrices to store transformed data
train_data_x_t <- train_data_x
validation_data_x_t <- validation_data_x
test_data_x_t <- test_data_x

# Correct columns with zeroes present
# Add 1/3 to every value in the selected column
train_data_x_t[, "Building.Age"] <- train_data_x_t[, "Building.Age"] + 1/3
train_data_x_t[, "Total.Bsmt.SF"] <- train_data_x_t[, "Total.Bsmt.SF"] + 1/3

validation_data_x_t[, "Building.Age"] <- validation_data_x_t[, "Building.Age"] + 1/3
validation_data_x_t[, "Total.Bsmt.SF"] <- validation_data_x_t[, "Total.Bsmt.SF"] + 1/3

test_data_x_t[, "Building.Age"] <- test_data_x_t[, "Building.Age"] + 1/3
test_data_x_t[, "Total.Bsmt.SF"] <- test_data_x_t[, "Total.Bsmt.SF"] + 1/3

# Transform The Variables -------------------------------------------------


# Apply log(x) transformation to all continuous columns
train_data_x_t[, "Gr.Liv.Area"] <- log(train_data_x_t[, "Gr.Liv.Area"])
train_data_x_t[, "Building.Age"] <- log(train_data_x_t[, "Building.Age"])
train_data_x_t[, "Total.Bsmt.SF"] <- log(train_data_x_t[, "Total.Bsmt.SF"])
train_data_x_t[, "Lot.Area"] <- log(train_data_x_t[, "Lot.Area"])

validation_data_x_t[, "Gr.Liv.Area"] <- log(validation_data_x_t[, "Gr.Liv.Area"])
validation_data_x_t[, "Building.Age"] <- log(validation_data_x_t[, "Building.Age"])
validation_data_x_t[, "Total.Bsmt.SF"] <- log(validation_data_x_t[, "Total.Bsmt.SF"])
validation_data_x_t[, "Lot.Area"] <- log(validation_data_x_t[, "Lot.Area"])

test_data_x_t[, "Gr.Liv.Area"] <- log(test_data_x_t[, "Gr.Liv.Area"])
test_data_x_t[, "Building.Age"] <- log(test_data_x_t[, "Building.Age"])
test_data_x_t[, "Total.Bsmt.SF"] <- log(test_data_x_t[, "Total.Bsmt.SF"])
test_data_x_t[, "Lot.Area"] <- log(test_data_x_t[, "Lot.Area"])



# Post-Transformation Skew Plots ------------------------------------------

# Load necessary libraries
library(ggplot2)
library(stats)

# Iterate through columns in train_data_x_t
for (col_name in colnames(train_data_x_t)) {
  column_data <- train_data_x_t[, col_name]
  
#  # Create a histogram
#  hist_plot <- ggplot(data = data.frame(x = column_data), aes(x = x)) +
#    geom_histogram(bins = 15) +
#    labs(title = paste("Histogram -", col_name))
  
  # Create a QQ plot
  qq_plot <- ggplot(data = data.frame(x = column_data), aes(sample = x)) +
    stat_qq() +
    labs(title = paste("QQ Plot -", col_name))
  
  # Display the Histogram and QQ Plot
#  print(hist_plot)
  print(qq_plot)
}

# RMSE Setup --------------------------------------------------------------------

# Calculate sqrt(mse) for k = 1 through k = 40
MaxK <- 40
RMSE <- rep(NA, MaxK)
for (k in 1:MaxK) {
  out <- knn.reg(train=train_data_x_t,test=validation_data_x_t,y=train_data_y,k=k)
  RMSE[k] <- sqrt(mean((validation_data_y - out$pred)^2))
}

# Plot sqrt(mse) against k
plot(RMSE, xlab = "k")
title("RMSE vs. k\nQ7: Variables Transformed, but Not Standardized")