import seaborn as sn
import pandas as pd
import numpy as np
import urllib.request
from sklearn import linear_model, neighbors
from sklearn.model_selection import train_test_split
from sklearn.metrics import confusion_matrix, precision_score, recall_score, f1_score, classification_report
import matplotlib.pyplot as plt
from sklearn.preprocessing import StandardScaler

print("Step 1: Data Loading and Exploration")
# Step 1: Load the data and explore it
url = "http://archive.ics.uci.edu/ml/machine-learning-databases/breast-cancer-wisconsin/wdbc.data"
column_names = ["ID", "Diagnosis", 
                "radius_mean",  "texture_mean",  "perimeter_mean",  "area_mean",  "smoothness_mean",  "compactness_mean",  "concavity_mean",  "concavePoints_mean",  "symmetry_mean",  "fractalDimension_mean", 
                "radius_se",    "texture_se",    "perimeter_se",    "area_se",    "smoothness_se",    "compactness_se",    "concavity_se",    "concavePoints_se",    "symmetry_se",    "fractalDimension_se", 
                "radius_worst", "texture_worst", "perimeter_worst", "area_worst", "smoothness_worst", "compactness_worst", "concavity_worst", "concavePoints_worst", "symmetry_worst", "fractalDimension_worst"
                ]
data = pd.read_csv(urllib.request.urlopen(url), header=None, names=column_names)

# Replace "M" with 1 and "B" with 0 in the "Diagnosis" column
data["Diagnosis"] = data["Diagnosis"].replace({"M": 1, "B": 0})

print("Data Loaded and processed")

# Summary statistics
summary_stats = data.describe()
print("Summary Statistics:")
print(summary_stats)

# Graphical correlation matrix
print("Now generating graphic correlation matrix...")
df = pd.DataFrame(data)
corr_matrix = df.corr()
plt.figure(figsize=(32,32))
sn.heatmap(corr_matrix, annot=True)
plt.show()
print("Done generating graphic")


print("Step 1: Data Loading and Exploration is COMPLETE")

# Step 2: Split the data and build models
# Splitting data into features (X) and target (y)
X = data.iloc[:, 2:]
y = data["Diagnosis"]

# Splitting data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=1, stratify=y)

print("\nDistribution of the target variable:")
# Distribution Target Variable
# Count how many data points we have for each label of the target variable
# bincount counts number of occurrences of each value in an array.
print('Labels counts in y:', np.bincount(y))
print('Labels counts in y_train:', np.bincount(y_train))
print('Labels counts in y_test:', np.bincount(y_test))
print("")


############################################# Normalization/Standardization ###################################
# Instantiate StandardScaler
sc = StandardScaler()
# Fitting the StandardScaler
sc.fit(X_train)

# Transforming the datasets
X_train = sc.transform(X_train)
X_test = sc.transform(X_test)


############################################# Train the Logistic Regression Model #############################################
# print("\nTrain the Logistic Regression Model:")
# logistic regression model
clf = linear_model.LogisticRegression(multi_class='auto', # accomondates multi-class categorical target variable
                                      C=1, # smaller C values specify stronger regularization
                                      solver = 'lbfgs',   # default is ‘lbfgs’ optimization algorithm to use in the optimization problem.
                                      max_iter=100)       # maximum number of iterations taken for the solvers to converge. default is 100


# Train our logistic regression model
# takes as input two arrays: an array X, sparse or dense,
clf = clf.fit(X_train, y_train)                             # model induction using the train data

#################################### Apply the Logistic Regression Model ####################################
# print("\nApply the Logistic Regression model:")
# We now apply the trained logistic regression model to the test set
y_pred = clf.predict(X_test)             # generate classification prediction and store them in y_pred; in scikit-learn's LogisticRegression the default threshold for the .predict() method is 0.5
y_pred_prob = clf.predict_proba(X_test)  # estimate class probabilities

################################### Evaluate the Logistic Regression Model ##################################
print('\033[1m' + '\nLogistic Regression Model Evaluation:' + '\033[0m')

# For Logistic Regression model calculate confusion matrix
cm_lr = confusion_matrix(y_test, y_pred)
print("Confusion Matrix (Logistic Regression):")
print(cm_lr)

class_names = ["M", "B"]  # List of class names
# Build a text report showing the main classification metrics (out-of-sample performance)
print("\nClassification Report (logistic regresssion):\n", classification_report(y_test, y_pred, target_names=class_names)) # builds a text report showing the main classification metrics (such as precision, recall, f1-score)


############################################# k-NN Model Training ###################################
# k-NN model
knn = neighbors.KNeighborsClassifier(n_neighbors=3, 
                                     p=2, # standard euclidean distance
                                     metric='minkowski', # default metric used by kNN algorithm
                                     n_jobs=-1,
                                     weights='uniform')

# Train our k-NN model
knn.fit(X_train, y_train)

############################################# Evaluate the k-NN Model #############################################
print('\033[1m' + '\nk-NN Model Evaluation:' + '\033[0m')# For k-NN model
# Estimate the predicted values by applying the kNN algorithm
y_pred = knn.predict(X_test)            # make predictions for test set

# Calculate and print additional evaluation metrics
precision_knn = precision_score(y_test, y_pred)
recall_knn = recall_score(y_test, y_pred)

class_names = ["M", "B"] 

print("Precision (k-NN):", precision_knn)
print("Recall (k-NN):", recall_knn)
print('F1 score (k-NN): ', f1_score(y_test, y_pred, average='macro'))           # average='macro' calculate metrics for each label, and find their unweighted mean

# Calculate confusion matrix
cm_knn = confusion_matrix(y_test, y_pred)
print("Confusion Matrix (k-NN):")
print(cm_knn)

class_names = ["M", "B"]  # List of class names
# Build a text report showing the main classification metrics (out-of-sample performance)
print("\nClassification Report (k-NN):\n", classification_report(y_test, y_pred, target_names=class_names)) # builds a text report showing the main classification metrics (such as precision, recall, f1-score)