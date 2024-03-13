import mysql.connector
import decimal 

# Replace these values with your MySQL server's information
host = "big-data-rds.cqjkbf4mswjw.us-east-1.rds.amazonaws.com"
user = "dmosden"
password = "Wreath-Cherub8-Estate"
database = "sakila"

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
        
        # Create a cursor to run queries through
        cur = connection.cursor()
        cur.execute("select database();")
        record = cur.fetchone()
        print("You're connected to database: ", record) # confirm that we're connected to Sakila

        # query to find the top five film genres in gross revenue in descending order 
        cur.execute("""SELECT 
                            c.name AS 'Genre', SUM(amount) AS 'Total Sales'
                        FROM
                            payment p
                                JOIN
                            rental r ON (p.rental_id = r.rental_id)
                                JOIN
                            inventory i ON (r.inventory_id = i.inventory_id)
                                JOIN
                            film_category fc ON (i.film_id = fc.film_id)
                                JOIN
                            category c ON (fc.category_id = c.category_id)
                        GROUP BY c.name
                        ORDER BY SUM(amount) DESC
                        LIMIT 5;""")
        
        # Fetch and print the results
        result = cur.fetchall()
        rownum = 0
        print("\nThe top five film genres by gross revenue (in descending order):")
        for row in result:
            rownum += 1
            category, amount = row

            # format amount as USD
            formatted_amount = f"${amount:.2f}"

            print(f"{rownum}. {category}: {formatted_amount}")

        # Commit the changes to the database
        connection.commit()

except mysql.connector.Error as error:
    print(f"Error: {error}")
finally:
    if 'connection' in locals():
        connection.close()
        print("\nConnection closed")
