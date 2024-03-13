import pandas as pd

# 1: load tsv into df
file_path = 'C:\\Users\\d_mos\\OneDrive\\Documents\\ISOM 672\\foodorders.tsv'
data = pd.read_csv(file_path, sep='\t')

# 2: display the first five records
print("First 5 records:")
print(data.head(5))

print("")

# 3: report num of rows and columns
print("Number of rows and columns:", data.shape)

print(" ")

# 4: identify the most frequently ordered item, order count
item_order_counts = data.groupby('item_name')['quantity'].sum().reset_index(name='total_quantity')
max_order_count = item_order_counts['total_quantity'].max()
most_freq_item = item_order_counts.loc[item_order_counts['total_quantity'] == max_order_count, "item_name"].tolist()
print("Most frequently ordered item(s):", *most_freq_item)
print("Order count:", max_order_count)

print(" ")

# 5: calculate total revenue
def convert_dollar_to_float(dollar_amount):
    numeric_part = dollar_amount.replace('$', '')
    return float(numeric_part)

data['revenue'] = data['quantity'] * data['item_price'].apply(convert_dollar_to_float)
total_revenue = data['revenue'].sum()
print("Total revenue: $" + str(round(total_revenue, 2)))

print(" ")

# 6: Determine the average amount spent per order
num_orders = data['order_id'].nunique()
avg_spent = total_revenue / num_orders
print("Average amount spent per order: $" + str(round(avg_spent, 2)))

print(" ")

# 7: Count the number of unique items ordered from the dataset
num_unique_items = data['item_name'].nunique()
print("Number of unique items ordered:", num_unique_items)
