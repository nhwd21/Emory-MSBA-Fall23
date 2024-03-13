from google.cloud import bigquery
from google.oauth2 import service_account
import pandas as pd
import matplotlib.pyplot as plt

## construct credentials from service account key file
credentials = service_account.Credentials.from_service_account_file(
    'C:\\workspace\\big-data-class\\gcp\\dmosden_bq\\dmosden-big-data-fall2023_srvacct.json') ## relative file path


# construct a BigQuery client object
client = bigquery.Client(credentials=credentials)

# SQL query to count patents with "covid" in the title for different time periods
query = """WITH Quarters AS (
  SELECT
    publication_date,
    title_text
  FROM (
    SELECT publication_number, title_localized_struct.text AS title_text, publication_date FROM `patents-public-data.patents.publications`,
    UNNEST(title_localized) AS title_localized_struct
    UNION ALL
    SELECT publication_number, title_localized_struct.text AS title_text, publication_date FROM `patents-public-data.patents.publications_202004`,
    UNNEST(title_localized) AS title_localized_struct
    UNION ALL
    SELECT publication_number, title_localized_struct.text AS title_text, publication_date FROM `patents-public-data.patents.publications_202007`,
    UNNEST(title_localized) AS title_localized_struct
    UNION ALL
    SELECT publication_number, title_localized_struct.text AS title_text, publication_date FROM `patents-public-data.patents.publications_202101`,
    UNNEST(title_localized) AS title_localized_struct
    UNION ALL
    SELECT publication_number, title_localized_struct.text AS title_text, publication_date FROM `patents-public-data.patents.publications_202105`,
    UNNEST(title_localized) AS title_localized_struct
    UNION ALL
    SELECT publication_number, title_localized_struct.text AS title_text, publication_date FROM `patents-public-data.patents.publications_202111`,
    UNNEST(title_localized) AS title_localized_struct
    UNION ALL
    SELECT publication_number, title_localized_struct.text AS title_text, publication_date FROM `patents-public-data.patents.publications_202204`,
    UNNEST(title_localized) AS title_localized_struct
    UNION ALL
    SELECT publication_number, title_localized_struct.text AS title_text, publication_date FROM `patents-public-data.patents.publications_202208`,
    UNNEST(title_localized) AS title_localized_struct
    UNION ALL
    SELECT publication_number, title_localized_struct.text AS title_text, publication_date FROM `patents-public-data.patents.publications_202212`,
    UNNEST(title_localized) AS title_localized_struct
    UNION ALL
    SELECT publication_number, title_localized_struct.text AS title_text, publication_date FROM `patents-public-data.patents.publications_202304`,
    UNNEST(title_localized) AS title_localized_struct
  ) AS combined_tables
  WHERE
    LOWER(title_text) LIKE '%covid%'
    AND publication_date BETWEEN 20200401 AND 20230430
)

SELECT
  SUBSTR(CAST(publication_date AS STRING), 1, 4) AS publication_year,
  CASE
    WHEN MOD(publication_date, 10000) BETWEEN 401 AND 630 THEN 'Q2'
    WHEN MOD(publication_date, 10000) BETWEEN 701 AND 930 THEN 'Q3'
    WHEN MOD(publication_date, 10000) BETWEEN 1001 AND 1231 THEN 'Q4'
    ELSE 'Q1'
  END AS publication_quarter,
  COUNT(*) AS num_patents_with_covid
FROM
  Quarters
GROUP BY
  publication_year, publication_quarter
ORDER BY
  publication_year, publication_quarter
"""

# Run the query and fetch the results
query_job = client.query(query)
result = query_job.result()

# Convert the result to a Pandas DataFrame
df = pd.DataFrame(result.to_dataframe())

# Print the results of our query as a df
print("Number of Patents with the word \"covid\" in the title across different quarters from 2020/04 to 2023/04:")
print(df)


# Visualizations
print('\nOpening windows with mathplotlib to show visualizations...')
# pivot table to aggregate data by year and quarter
pivot_table = df.pivot_table(index='publication_year', columns='publication_quarter', values='num_patents_with_covid')

# Bar plot
pivot_table.plot(kind='bar', stacked=True)
plt.title('Number of Patents with COVID by Year and Quarter')
plt.xlabel('Publication Year')
plt.ylabel('Number of Patents')
plt.legend(title='Quarter')
plt.show()

# avoid modifying the original df
df_with_quarter_year = df.copy()

# combine year and quarter columns into a single string for x-axis labels
df_with_quarter_year['quarter_year'] = df_with_quarter_year['publication_quarter'] + ' ' + df_with_quarter_year['publication_year'].astype(str)

# but also create a year-quarter column for easier sorting 
df_with_quarter_year['year_quarter'] = df_with_quarter_year['publication_year'].astype(str) + ' ' + df_with_quarter_year['publication_quarter']
# sort the df by the combined column for correct ordering
df_with_quarter_year = df_with_quarter_year.sort_values(by='year_quarter')

# Create a line plot
plt.figure(figsize=(10, 5))  
plt.plot(df_with_quarter_year['quarter_year'], df_with_quarter_year['num_patents_with_covid'], marker='o')
plt.title('Number of Patents with COVID by Quarter and Year')
plt.xlabel('Quarter and Year')
plt.ylabel('Number of Patents')
plt.xticks(rotation=45, ha='right')  # rotate x-axis labels for readability
plt.grid(True)
plt.tight_layout()
plt.show()