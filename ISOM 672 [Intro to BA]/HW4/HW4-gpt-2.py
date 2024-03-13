# Import necessary libraries
import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split, cross_val_score, ShuffleSplit
from sklearn.linear_model import LinearRegression, Lasso, Ridge
from sklearn.neighbors import KNeighborsRegressor
from sklearn.tree import DecisionTreeRegressor
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import mean_squared_error, mean_absolute_error

# Read data with binary columns specified
binary_cols = ['US', 'Web_order', 'Gender=mal', 'Address_is_res', 'Purchase']  # Binary columns

# Create a list of valid column identifiers by combining binary_cols and the range of integers
valid_cols = binary_cols + list(range(2, 24))

# Read the Excel file, specifying the 'usecols' parameter with the valid column list
try:
    df = pd.read_excel('C:\\Users\\d_mos\\OneDrive\\Documents\\ISOM 672 [Intro to BA]\\HW4\\HW4.xlsx', sheet_name='All Data', usecols=valid_cols)
    # Rest of your data processing code here
except ValueError as e:
    print(f"An error occurred: {e}")


# Define the target variable
target_col = 'Spending'

# Ensure reproducibility
np.random.seed(42)

# Data Exploration
print(df.describe())

# Visualize the distribution of the target variable 'Spending'
plt.figure(figsize=(8, 6))
sns.histplot(df[target_col], kde=True)
plt.title('Distribution of Spending')
plt.xlabel('Spending')
plt.ylabel('Frequency')
plt.show()

# Select features and target variable
X = df.drop(columns=[target_col]).values
y = df[target_col].values

# Train-test split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)

# Modeling - Linear Regression
slr = LinearRegression()
slr.fit(X_train, y_train)
y_train_pred = slr.predict(X_train)
y_test_pred = slr.predict(X_test)

# Evaluate Linear Regression Model
def evaluate_model(model, X, y, name):
    mse = mean_squared_error(y, model.predict(X))
    rmse = np.sqrt(mse)
    mae = mean_absolute_error(y, model.predict(X))
    print(f'{name} - MSE: {mse:.3f}, RMSE: {rmse:.3f}, MAE: {mae:.3f}')

evaluate_model(slr, X_train, y_train, 'Linear Regression (Train)')
evaluate_model(slr, X_test, y_test, 'Linear Regression (Test)')

# Cross-validation with Linear Regression
cv = ShuffleSplit(n_splits=10, test_size=0.3, random_state=42)
scores_mse = -cross_val_score(slr, X, y, cv=cv, scoring='neg_mean_squared_error', n_jobs=1)
scores_rmse = -cross_val_score(slr, X, y, cv=cv, scoring='neg_root_mean_squared_error', n_jobs=1)
print('Linear Regression - Nested MSE score:', scores_mse.mean(), "+/-", scores_mse.std())
print('Linear Regression - Nested RMSE score:', scores_rmse.mean(), "+/-", scores_rmse.std())

# Feature Engineering
# You can experiment with feature engineering for binary variables or create interaction terms.

# Parameter Tuning for Ridge Regression
ridge = Ridge(alpha=1.0)
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)
ridge.fit(X_train_scaled, y_train)

# Evaluate Ridge Regression Model
evaluate_model(ridge, X_train_scaled, y_train, 'Ridge Regression (Train)')
evaluate_model(ridge, X_test_scaled, y_test, 'Ridge Regression (Test)')

# Cross-validation with Ridge Regression
scores_mse = -cross_val_score(ridge, scaler.transform(X), y, cv=cv, scoring='neg_mean_squared_error', n_jobs=1)
scores_rmse = -cross_val_score(ridge, scaler.transform(X), y, cv=cv, scoring='neg_root_mean_squared_error', n_jobs=1)
print('Ridge Regression - Nested MSE score:', scores_mse.mean(), "+/-", scores_mse.std())
print('Ridge Regression - Nested RMSE score:', scores_rmse.mean(), "+/-", scores_rmse.std())

# Parameter Tuning for K-NN Regression
knn_regressor = KNeighborsRegressor(n_neighbors=3)
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)
knn_regressor.fit(X_train_scaled, y_train)

# Evaluate K-NN Regression Model
evaluate_model(knn_regressor, X_train_scaled, y_train, 'K-NN Regression (Train)')
evaluate_model(knn_regressor, X_test_scaled, y_test, 'K-NN Regression (Test)')

# Cross-validation with K-NN Regression
scores_mse = -cross_val_score(knn_regressor, scaler.transform(X), y, cv=cv, scoring='neg_mean_squared_error', n_jobs=1)
scores_rmse = -cross_val_score(knn_regressor, scaler.transform(X), y, cv=cv, scoring='neg_root_mean_squared_error', n_jobs=1)
print('K-NN Regression - Nested MSE score:', scores_mse.mean(), "+/-", scores_mse.std())
print('K-NN Regression - Nested RMSE score:', scores_rmse.mean(), "+/-", scores_rmse.std())

# Parameter Tuning for Decision Tree Regression
tree = DecisionTreeRegressor(criterion='mse', max_depth=3, random_state=42)
tree.fit(X_train, y_train)

# Evaluate Decision Tree Regression Model
evaluate_model(tree, X_train, y_train, 'Decision Tree Regression (Train)')
evaluate_model(tree, X_test, y_test, 'Decision Tree Regression (Test)')

# Cross-validation with Decision Tree Regression
scores_rmse = -cross_val_score(tree, X, y, cv=cv, scoring='neg_root_mean_squared_error', n_jobs=1)
print('Decision Tree Regression - Nested RMSE score:', scores_rmse.mean(), "+/-", scores_rmse.std())
