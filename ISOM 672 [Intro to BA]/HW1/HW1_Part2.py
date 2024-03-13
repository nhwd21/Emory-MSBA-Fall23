import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier, plot_tree
from sklearn.metrics import accuracy_score, confusion_matrix, classification_report
import matplotlib.pyplot as plt

# Load the data
file_path = r'C:\Users\d_mos\OneDrive\Documents\ISOM 672 [Analytics]\HW1\HW1_Data.csv'
data = pd.read_csv(file_path)

# Handle missing values if any
data = data.fillna(0)

# Encode categorical variables if needed (e.g., webcap, marryyes, travel, pcown, creditcd)

# Split the data into training and testing sets
X = data.drop(columns=["churndep"])
y = data["churndep"]
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Create a decision tree classifier with entropy criterion
tree_entropy = DecisionTreeClassifier(criterion="entropy", random_state=42)

# Fit the model on the training data
tree_entropy.fit(X_train, y_train)

# Predict on the test data
y_pred_entropy = tree_entropy.predict(X_test)

# Visualize the decision tree
plt.figure(figsize=(12, 6))
plot_tree(tree_entropy, filled=True, feature_names=X.columns, class_names=["No Churn", "Churn"])
plt.show()

# Evaluate the decision tree with entropy criterion
accuracy_entropy = accuracy_score(y_test, y_pred_entropy)
confusion_matrix_entropy = confusion_matrix(y_test, y_pred_entropy)
classification_report_entropy = classification_report(y_test, y_pred_entropy)

# Compare the performance of the two models
print("Decision Tree with Entropy Criterion:")
print(f"Accuracy: {accuracy_entropy}")
print("Confusion Matrix:")
print(confusion_matrix_entropy)
print("Classification Report:")
print(classification_report_entropy)