import mysql.connector
import pandas as pd

# store filepath to pastry inventory
file_path = "C:\\Users\\d_mos\\OneDrive\\Documents\\ISOM 671 [Big Data]\\Assignment 3\\coffee shop\\pastry inventory.csv"

# Read the CSV file into a DataFrame
pastry_inventory = pd.read_csv(file_path)

# My Server Login for our BIG DATA MySQL server
host = "msba2024-serverless-mysql-production.cluster-cqxikovybdnm.us-east-2.rds.amazonaws.com"
user = "DMOSDEN"
password = "BE3ZSCcmU7"
database = "STUDENT_DMOSDEN"

try:
    # Establish a connection to the MySQL server
    connection = mysql.connector.connect(
        host=host,
        user=user,
        password=password,
        database=database
    )
    if connection.is_connected():
        print("Connected to MySQL database")
        
        # If we connect, then perform database operations
        cur = connection.cursor()
        cur.execute("select database();")
        record = cur.fetchone()
        print("You're connected to database: ", record)
        cur.execute('DROP TABLE IF EXISTS pastry_inventory;')
        print('Creating table....')
        cur.execute("""CREATE TABLE `STUDENT_DMOSDEN`.`pastry_inventory` (
                            `sales_outlet_id` INT,
                            `transaction_date` TEXT,
                            `product_id` INT,
                            `start_of_day` INT,
                            `quantity_sold` INT,
                            `waste` INT,
                            `% waste` TEXT
                        );""")
        print("pastry_inventory table is created....")

        # store the insertion query (makes editing easier)
        insert_query = """INSERT INTO pastry_inventory (sales_outlet_id, transaction_date, product_id, start_of_day, quantity_sold, waste, `% waste`) VALUES (%s, %s, %s, %s, %s, %s, %s)"""

        # Iterate through the rows of the df with our pastry data, and insert data into our table in mysql
        print("Inserting data into pastry_inventory table...")
        for index, row in pastry_inventory.iterrows():
            values = (
                row['sales_outlet_id'],
                row['transaction_date'],
                row['product_id'],
                row['start_of_day'],
                row['quantity_sold'],
                row['waste'],
                row['% waste']
            )
            cur.execute(insert_query, values)
        print("pastry_inventory table has been filled with data in MySQL database")

        # now print some rows to make sure everything worked
        print("\nHere are the first 10 lines of the table:")
        select_query = "SELECT * FROM pastry_inventory LIMIT 10"     
        cur.execute(select_query) # Execute the SELECT query
        # Get column names from the cursor description
        columns = [desc[0] for desc in cur.description]
        result = cur.fetchall()
        # Create a DataFrame from the data, with column names
        result_df = pd.DataFrame(result, columns=columns)
        print(result_df) # print our sample rows to ensure everything works!

        # Commit the changes to the database
        connection.commit()

except mysql.connector.Error as error:
    print(f"Error: {error}")
finally:
    if 'connection' in locals():
        connection.close()
        print("\nConnection closed")