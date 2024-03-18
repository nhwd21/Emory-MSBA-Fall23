import pandas as pd

# Replace 'path/to/your/file.csv' with the actual path to your CSV file
csv_file_path = 'C:\\Users\\foste\\OneDrive\\Documents\\ISOM 675 [Data Viz]\\Assignment 2\\MTA_Customer_Feedback_Data__Beginning_2014.csv'

# Replace 'path/to/your/output/average_complaints_per_quarter.csv' with the desired output path
output_csv_path = 'C:\\Users\\foste\\OneDrive\\Documents\\ISOM 675 [Data Viz]\\Assignment 2\\average_complaints_per_quarter.csv'


# Read the CSV file into a DataFrame
df = pd.read_csv(csv_file_path)

# Filter the DataFrame to include only complaints before the year 2019
filtered_df = df[(df['Commendation or Complaint'] == 'Complaint') & (df['Year'] < 2019)]

# Group by Year and Quarter, then sum the number of complaints for each group
quarterly_complaints = filtered_df.groupby(['Year', 'Quarter']).size().reset_index(name='Total Complaints')

# Group by Quarter and calculate the average number of complaints across all years
average_complaints_per_quarter = quarterly_complaints.groupby('Quarter')['Total Complaints'].mean().reset_index(name='Average Complaints')

print(quarterly_complaints)

print(average_complaints_per_quarter)

# Save the results to a new CSV file
average_complaints_per_quarter.to_csv(output_csv_path, index=False)

print(f"Results saved to {output_csv_path}")