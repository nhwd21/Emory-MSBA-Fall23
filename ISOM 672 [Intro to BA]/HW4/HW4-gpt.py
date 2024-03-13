import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.model_selection import cross_val_score, train_test_split, GridSearchCV
from sklearn.linear_model import LinearRegression
from sklearn.neighbors import KNeighborsRegressor
from sklearn.tree import DecisionTreeRegressor

# Load the dataset
data = pd.read_excel('C:\\Users\\d_mos\\OneDrive\\Documents\\ISOM 672 [Intro to BA]\HW4\HW4.xlsx', sheet_name='All Data')

# Data Exploration
print("Data Exploration:")
print("Descriptive Statistics:")
print(data.describe())
print("\nTarget Variable Distribution:")
plt.hist(data['Spending'], bins=30, edgecolor='k')
plt.xlabel('Spending')
plt.ylabel('Frequency')
plt.show()

# Split data into features (X) and target (y)
X = data.drop('Spending', axis=1)
y = data['Spending']

# Initial Models
models = {
    "Linear Regression": LinearRegression(),
    "k-NN": KNeighborsRegressor(),
    "Regression Tree": DecisionTreeRegressor(random_state=42)
}

# Cross-validation with 10 folds
for model_name, model in models.items():
    scores = cross_val_score(model, X, y, cv=10, scoring='neg_mean_squared_error')
    rmse = np.sqrt(-scores)
    print(f"\n{model_name} - RMSE: {rmse.mean()}")

# Feature Engineering
# Example: You can add new features here based on your domain knowledge.

# Parameter Tuning
param_grid = {
    "Linear Regression": {
        "fit_intercept": [True, False],
        "normalize": [True, False]
    },
    "k-NN": {
        "n_neighbors": [3, 5, 7],
        "weights": ['uniform', 'distance']
    },
    "Regression Tree": {
        "max_depth": [None, 5, 10, 15],
        "min_samples_split": [2, 5, 10]
    }
}

for model_name, model in models.items():
    if model_name in param_grid:
        grid_search = GridSearchCV(model, param_grid[model_name], cv=10, scoring='neg_mean_squared_error')
        grid_search.fit(X, y)
        best_params = grid_search.best_params_
        best_rmse = np.sqrt(-grid_search.best_score_)
        print(f"\n{model_name} Best Parameters: {best_params}")
        print(f"{model_name} Best RMSE: {best_rmse}")

# Discussion
# Discuss the performance of each model, feature engineering impact, and parameter tuning results.
