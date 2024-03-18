# Load Data ---------------------------------------------------------------

# Load required library
library(class)
library(FNN)
library(dplyr)
library(tidyr)
# Load the training, validation, and test datasets
train_data <- read.csv("GradedHW1-Train-Data.csv")
validation_data <- read.csv("GradedHW1-Validation-Data.csv")
test_data <- read.csv("GradedHW1-Test-Data.csv")

# Add Building.Age --------------------------------------------------------

library(dplyr)
train_data <- train_data %>% mutate(Building.Age = 2010 - Year.Built)
validation_data <- validation_data %>% mutate(Building.Age = 2010 - Year.Built)
test_data <- test_data %>% mutate(Building.Age = 2010 - Year.Built)


# Matrix, select columns --------------------------------------------------

train_data <- train_data[,c("SalePrice", "Lot.Area", "Total.Bsmt.SF", "Gr.Liv.Area", "Full.Bath", "Bedroom.AbvGr", "Building.Age")]
train_data <- na.omit(train_data)
train_data <- as.matrix(train_data)
train_data_x <- train_data[,2:7]
train_data_y <- train_data[,1]

validation_data <- validation_data[,c("SalePrice", "Lot.Area", "Total.Bsmt.SF", "Gr.Liv.Area", "Full.Bath", "Bedroom.AbvGr", "Building.Age")]
validation_data <- na.omit(validation_data)
validation_data <- as.matrix(validation_data)
validation_data_x <- validation_data[,2:7]
validation_data_y <- validation_data[,1]

test_data <- test_data[,c("SalePrice", "Lot.Area", "Total.Bsmt.SF", "Gr.Liv.Area", "Full.Bath", "Bedroom.AbvGr", "Building.Age")]
test_data <- na.omit(test_data)
test_data <- as.matrix(test_data)
test_data_x <- test_data[,2:7]
test_data_y <- test_data[,1]

# RMSE Setup --------------------------------------------------------------------

# Calculate sqrt(mse) for k = 1 through k = 40
MaxK <- 40
RMSE <- rep(NA, MaxK)
for (k in 1:MaxK) {
  out <- knn.reg(train=train_data_x,test=validation_data_x,y=train_data_y,k=k)
  RMSE[k] <- sqrt(mean((validation_data_y - out$pred)^2))
}

# Plot sqrt(mse) against k
plot(RMSE, xlab = "k")
title("RMSE vs. k\nQ3: Variables Not Transformed or Standardized")

# Q3.1 --------------------------------------------------------------------
# Calculate RMSE for k = 1
rmse_k1 <- RMSE[1]

# Round RMSE to two decimal places
rmse_k1_rounded <- round(rmse_k1, 2)

# Print the RMSE for k = 1
cat("Root MSE (k = 1):", rmse_k1_rounded, "\n")

# Q3.2 --------------------------------------------------------------------
# Calculate RMSE for k = 20
rmse_k20 <- RMSE[20]

# Round RMSE to two decimal places
rmse_k20_rounded <- round(rmse_k20, 2)

# Print the RMSE for k = 20
cat("Root MSE (k = 20):", rmse_k20_rounded, "\n")

