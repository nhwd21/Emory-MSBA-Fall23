# Load Data ---------------------------------------------------------------
# Load the training, validation, and test datasets
train_data <- read.csv("GradedHW1-Train-Data.csv")
validation_data <- read.csv("GradedHW1-Validation-Data.csv")
test_data <- read.csv("GradedHW1-Test-Data.csv")


# Add Building.Age --------------------------------------------------------
library(dplyr)
train_data <- train_data %>% mutate(Building.Age = 2010 - Year.Built)
validation_data <- validation_data %>% mutate(Building.Age = 2010 - Year.Built)
test_data <- test_data %>% mutate(Building.Age = 2010 - Year.Built)

# Q2.1 --------------------------------------------------------------------
values <- c("Lot.Area", "Total.Bsmt.SF",
            "Gr.Liv.Area", "Full.Bath",
            "Bedroom.AbvGr", "Building.Age")

# For train_data
missing_vars_train <- colnames(train_data)[colSums(is.na(train_data)) > 0]
if (length(intersect(values, missing_vars_train)) > 0) {
  cat("Missing variables in train_data:\n")
  missing_vars_train <- sort(missing_vars_train)
  cat(intersect(values, missing_vars_train), sep = ", ")
} else {
  cat("No missing variables in train_data.\n")
}

# For validation_data
missing_vars_validation <- colnames(validation_data)[colSums(is.na(validation_data)) > 0]
if (length(intersect(values, missing_vars_validation)) > 0) {
  cat("Missing variables in validation_data:\n")
  missing_vars_validation <- sort(missing_vars_validation)
  cat(intersect(values, missing_vars_validation), sep = ", ")
} else {
  cat("\nNo missing variables in validation_data.\n")
}

# For test_data
missing_vars_test <- colnames(test_data)[colSums(is.na(test_data)) > 0]
if (length(intersect(values, missing_vars_test)) > 0) {
  cat("Missing variables in test_data:\n")
  missing_vars_test <- sort(missing_vars_test)
  cat(intersect(values, missing_vars_test), sep = ", ")
} else {
  cat("\nNo missing variables in test_data.\n")
}


# Q2.2 --------------------------------------------------------------------
# Load the library for skewness calculation
library(e1071)

# Create a function to identify variables with skewness and outliers
identify_skew_outliers <- function(data, var_names) {
  skewed_outliers <- character(0)
  for (var_name in var_names) {
    var <- data[[var_name]]
    if (is.numeric(var)) {
      skew <- skewness(var)
      q75 <- quantile(var, 0.75)
      iqr <- IQR(var)
      upper_outliers <- sum(var > q75 + 1.5 * iqr)
      if (skew > 1 && upper_outliers > 0) {
        skewed_outliers <- c(skewed_outliers, var_name)
      }
    }
  }
  return(skewed_outliers)
}

# List of potential variables
potential_vars <- c(
  "Lot.Area",
  "Total.Bsmt.SF",
  "Gr.Liv.Area",
  "Full.Bath",
  "Bedroom.AbvGr",
  "Building.Age"
)

# Identify variables with strong right skewness and upper tail outliers in training data
skewed_outliers_train <- identify_skew_outliers(train_data, potential_vars)

# Print the results
if (length(skewed_outliers_train) > 0) {
  cat("Variables in the training data with strong right skewness and upper tail outliers:\n")
  cat(skewed_outliers_train, sep = ", ")
} else {
  cat("No variables in the training data have strong right skewness with upper tail outliers.")
}

