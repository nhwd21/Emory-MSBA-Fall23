AllData <- read.table("GradedHW1-All-Data.csv",header=T,sep=",",
                      stringsAsFactors = F,na.strings="")

AllData <- AllData[AllData$Bldg.Type=="1Fam",]

RPerm <- sample(nrow(AllData))
AllData <- AllData[RPerm,]

TrainInd <- ceiling(nrow(AllData)/2)
ValInd <- ceiling((nrow(AllData)-TrainInd)/2)+TrainInd

TrainData <- AllData[1:TrainInd,]
ValData <- AllData[(TrainInd+1):ValInd,]
TestData <- AllData[(ValInd+1):nrow(AllData),]



# Q2.1
# Check for missing values in the training data set
missing_train <- colSums(is.na(TrainData))
missing_train_vars <- names(TrainData)[missing_train > 0]
print("Missing values in training data:")
print(missing_train_vars)

# Check for missing values in the validation data set
missing_val <- colSums(is.na(ValData))
missing_val_vars <- names(ValData)[missing_val > 0]
print("Missing values in validation data:")
print(missing_val_vars)

# Check for missing values in the test data set
missing_test <- colSums(is.na(TestData))
missing_test_vars <- names(TestData)[missing_test > 0]
print("Missing values in test data:")



# Q2.2
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
  "Building Age"
)

# Identify variables with strong right skewness and upper tail outliers in training data
skewed_outliers_train <- identify_skew_outliers(TrainData, potential_vars)

# Print the results
if (length(skewed_outliers_train) > 0) {
  cat("Variables in the training data with strong right skewness and upper tail outliers:\n")
  cat(skewed_outliers_train, sep = ", ")
} else {
  cat("No variables in the training data have strong right skewness with upper tail outliers.")
}

