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


# Perform Scaling ---------------------------------------------------------

# Define a custom function for min-max scaling
min_max_scale <- function(x) {
  min_val <- min(x)
  max_val <- max(x)
  scaled <- (x - min_val) / (max_val - min_val)
  return(scaled)
}

# Apply Min-Max Scaling to train_data_x, validation_data_x, and test_data_x
train_data_x_z <- apply(train_data_x, 2, min_max_scale)
validation_data_x_z <- apply(validation_data_x, 2, min_max_scale)
test_data_x_z <- apply(test_data_x, 2, min_max_scale)


# Shift Data --------------------------------------------------------------

# Create new matrices to store transformed data
train_data_x_z_t <- train_data_x_z
validation_data_x_z_t <- validation_data_x_z
test_data_x_z_t <- test_data_x_z

# Correct columns with zeroes present
# Add 1/3 to every value in the selected column
train_data_x_z_t[, "Gr.Liv.Area"] <- train_data_x_z_t[, "Gr.Liv.Area"] + 1/3
train_data_x_z_t[, "Building.Age"] <- train_data_x_z_t[, "Building.Age"] + 1/3
train_data_x_z_t[, "Total.Bsmt.SF"] <- train_data_x_z_t[, "Total.Bsmt.SF"] + 1/3
train_data_x_z_t[, "Lot.Area"] <- train_data_x_z_t[, "Lot.Area"] + 1/3

validation_data_x_z_t[, "Gr.Liv.Area"] <- validation_data_x_z_t[, "Gr.Liv.Area"] + 1/3
validation_data_x_z_t[, "Building.Age"] <- validation_data_x_z_t[, "Building.Age"] + 1/3
validation_data_x_z_t[, "Total.Bsmt.SF"] <- validation_data_x_z_t[, "Total.Bsmt.SF"] + 1/3
validation_data_x_z_t[, "Lot.Area"] <- validation_data_x_z_t[, "Lot.Area"] + 1/3

test_data_x_z_t[, "Gr.Liv.Area"] <- test_data_x_z_t[, "Gr.Liv.Area"] + 1/3
test_data_x_z_t[, "Building.Age"] <- test_data_x_z_t[, "Building.Age"] + 1/3
test_data_x_z_t[, "Total.Bsmt.SF"] <- test_data_x_z_t[, "Total.Bsmt.SF"] + 1/3
test_data_x_z_t[, "Lot.Area"] <- test_data_x_z_t[, "Lot.Area"] + 1/3

# Transform The Variables -------------------------------------------------

# Apply log(x) transformation to all continuous columns
train_data_x_z_t[, "Gr.Liv.Area"] <- log(train_data_x_z_t[, "Gr.Liv.Area"])
train_data_x_z_t[, "Building.Age"] <- log(train_data_x_z_t[, "Building.Age"])
train_data_x_z_t[, "Total.Bsmt.SF"] <- log(train_data_x_z_t[, "Total.Bsmt.SF"])
train_data_x_z_t[, "Lot.Area"] <- log(train_data_x_z_t[, "Lot.Area"])

validation_data_x_z_t[, "Gr.Liv.Area"] <- log(validation_data_x_z_t[, "Gr.Liv.Area"])
validation_data_x_z_t[, "Building.Age"] <- log(validation_data_x_z_t[, "Building.Age"])
validation_data_x_z_t[, "Total.Bsmt.SF"] <- log(validation_data_x_z_t[, "Total.Bsmt.SF"])
validation_data_x_z_t[, "Lot.Area"] <- log(validation_data_x_z_t[, "Lot.Area"])

test_data_x_z_t[, "Gr.Liv.Area"] <- log(test_data_x_z_t[, "Gr.Liv.Area"])
test_data_x_z_t[, "Building.Age"] <- log(test_data_x_z_t[, "Building.Age"])
test_data_x_z_t[, "Total.Bsmt.SF"] <- log(test_data_x_z_t[, "Total.Bsmt.SF"])
test_data_x_z_t[, "Lot.Area"] <- log(test_data_x_z_t[, "Lot.Area"])


# Post-Transformation Skew Plots ------------------------------------------

# Load necessary libraries
library(ggplot2)
library(stats)

# Iterate through columns in train_data_x_z_t
for (col_name in colnames(train_data_x_z_t)) {
  column_data <- train_data_x_z_t[, col_name]
  
  # Create a histogram
  hist_plot <- ggplot(data = data.frame(x = column_data), aes(x = x)) +
    geom_histogram(bins = 15) +
    labs(title = paste("Histogram -", col_name))
  
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
  out <- knn.reg(train=train_data_x_z_t,test=validation_data_x_z_t,y=train_data_y,k=k)
  RMSE[k] <- sqrt(mean((validation_data_y - out$pred)^2))
}

# Q10.2 -------------------------------------------------------------------

# Find the best k (k with the lowest RMSE)
BestK <- which.min(RMSE)
cat("The best k =",BestK,"\n")


# Q10.3 -------------------------------------------------------------------

# run k-NN on the test data this time to get root MSE for k=12 (aka BestK)
out <- knn.reg(train=train_data_x_z_t,test=test_data_x_z_t,y=train_data_y,k=BestK)
rmse_bestK <- sqrt(mean((test_data_y - out$pred)^2))

# Round RMSE to two decimal places
rmse_bestK_rounded <- round(rmse_bestK, 2)

# Print the RMSE for best k
cat("Root MSE (best k):", rmse_bestK_rounded, "\n")
