import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error
from sklearn.metrics import mean_absolute_error
from sklearn.model_selection import cross_val_score
from sklearn import neighbors
from sklearn.preprocessing import MinMaxScaler
from math import sqrt
from sklearn.tree import DecisionTreeRegressor

# read data
import pandas as pd
import numpy as np

df = pd.read_excel('HW4.xlsx', sheet_name='All Data')

# Whenever applicable use random state 42 (10 points).
np.random.seed(42) # ensure reproducability

# Create a new DataFrame for feature engineering
df_new = df.copy()

# 1. Add a new column that bins "Freq" into the categories low, medium, and high
bins = [0, 50, 200, float('inf')]  # Define the bin edges
labels = ['Low', 'Medium', 'High']  # Define bin labels
df_new['Freq_category'] = pd.cut(df_new['Freq'], bins=bins, labels=labels)

# 2. Extract the month and year from the last_update_days_ago and 1st_update_days_ago features
df_new['Last_Update_Month'] = pd.to_datetime(df_new['last_update_days_ago'], unit='D').dt.month
df_new['Last_Update_Year'] = pd.to_datetime(df_new['last_update_days_ago'], unit='D').dt.year
df_new['First_Update_Month'] = pd.to_datetime(df_new['1st_update_days_ago'], unit='D').dt.month
df_new['First_Update_Year'] = pd.to_datetime(df_new['1st_update_days_ago'], unit='D').dt.year

# 3. Create a new column that captures the time between the first and last update
df_new['Update_Time_Difference'] = df_new['last_update_days_ago'] - df_new['1st_update_days_ago']

# Split the data into features (X) and target variable (y)
X = df_new.drop(columns=['Spending'])
y = df_new['Spending']

# Split the data into train and test sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)

# Continue with modeling code, using the modified DataFrame 'df_new'

# Fit a Linear Regression Model
slr2 = LinearRegression()
slr2.fit(X_train, y_train)
y_train_pred = slr2.predict(X_train)
y_test_pred = slr2.predict(X_test)
print('Slope: %.3f', slr2.coef_)                       # estimated coefficients for the linear regression model

# Evaluate Linear Regression model
from sklearn.metrics import mean_absolute_error # mean absolute error regression loss
from sklearn.metrics import mean_squared_error  # mean squared error regression loss

# See all regression metrics here http://scikit-learn.org/stable/modules/model_evaluation.html#regression-metrics
print('MSE train: %.3f, test: %.3f' % ( # mean_absolute_error
        mean_squared_error(y_train, y_train_pred),
        mean_squared_error(y_test, y_test_pred)))  # y_test: Ground truth (correct) target values
                                                   # y_test_pred: Estimated target values

print('RMSE train: %.3f, test: %.3f' % ( #RMSE
        sqrt(mean_squared_error(y_train, y_train_pred)),
        sqrt(mean_squared_error(y_test, y_test_pred))))

print('MAE train: %.3f, test: %.3f' % ( # mean_squared_error
        mean_absolute_error(y_train, y_train_pred),
        mean_absolute_error(y_test, y_test_pred))) # y_test: Ground truth (correct) target values
                                                   # y_test_pred: Estimated target values

# Use cross-validation with 10 folds to estimate the generalization performance
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import ShuffleSplit

cv = ShuffleSplit(n_splits=10,          # number of re-shuffling & splitting iterations
                  test_size=0.3
                  ,random_state=42)

scores = cross_val_score(estimator=slr2,              # 10-fold cross validation
                            X=X,
                            y=y,
                            cv=cv,
                            scoring = 'neg_mean_squared_error',
                            n_jobs=1)
print('Nested MSE score:', scores.mean(), " +/- ", scores.std())
scores = cross_val_score(estimator=slr2,              # 10-fold cross validation
                            X=X,
                            y=y,
                            cv=cv,
                            scoring = 'neg_root_mean_squared_error',
                            n_jobs=1)
print('Nested RMSE score:', scores.mean(), " +/- ", scores.std())


# Example: kNN Regressor
sc = MinMaxScaler(feature_range=(0, 1))
sc.fit(X_train)
x_train_scaled = sc.transform(X_train)
x_test_scaled = sc.transform(X_test)

knn_regressor = neighbors.KNeighborsRegressor(n_neighbors=3)
knn_regressor.fit(x_train_scaled, y_train)
pred = knn_regressor.predict(x_test_scaled)
error = sqrt(mean_squared_error(y_test, pred))

# Use cross-validation
# ...

# Example: Decision Tree Regressor
tree = DecisionTreeRegressor(criterion='mse', max_depth=3, random_state=42)
tree.fit(X_train, y_train)

# Use cross-validation
# ...

# Continue with the rest of your modeling and evaluation code using the 'df_new' DataFrame.
