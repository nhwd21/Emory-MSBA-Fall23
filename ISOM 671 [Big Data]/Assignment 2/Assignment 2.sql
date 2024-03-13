############################# PLEASE READ!!! ######################################
-- The StackExchange Data Explorer site we were instructed to use does not use 
-- the same flavor of (My)SQL we use in class to compose queries. I figured 
-- out the formatting from reading through the "queries" tab on the site
-- As a result, the queries for questions 1-5 will not work in the same MySQL
-- environments that we have been using in class; the queries I wrote for questions
-- 6-25 will, however, work just fine.
####################################################################################


# Question 1 -------------------------------------------------------------
SELECT 
    COUNT(*) AS num_posts,
    MIN(CreationDate) AS min_date,
    MAX(Creation_Date) AS max_date,
    AVG(Score) AS avg_score
FROM
    posts;
    
# Question 2 -------------------------------------------------------------
SELECT 
	DATEPART(YEAR, CreationDate) AS [Year],
	DATEPART(MONTH, CreationDate) AS [Month],
	COUNT(*) AS [Count]
FROM 
	Posts
GROUP BY 
	DATEPART(YEAR, CreationDate), 
    DATEPART(MONTH, CreationDate) 
ORDER BY 
	[Year] ASC, 
    [Month] ASC;
    
# Question 3 -------------------------------------------------------------
SELECT
	DATEPART(YEAR, CreationDate) as [Year],
	DATEPART(MONTH, CreationDate) AS [Month],
    PostTypeID,
    COUNT(*) AS cnt
FROM
	Posts
GROUP BY
	DATEPART(YEAR, CreationDate) as [Year],
	DATEPART(MONTH, CreationDate) AS [Month],
    PostTypeID
ORDER BY 
	cnt DESC,
    [Year] ASC,
    [Month] ASC,
    PostTypeID ASC;
    
# Question 4 -------------------------------------------------------------
SELECT 
    name, COUNT(*) AS cnt
FROM
    Badges
GROUP BY Name
HAVING COUNT(*) >= 20
ORDER BY cnt DESC;
    
# Question 5 -------------------------------------------------------------
SELECT 
    COUNT(DISTINCT ID) AS cnt
FROM
    Users
WHERE
    Location LIKE '%New York%'
        OR Location LIKE '%NY%'
        OR Location LIKE '%NYC%'
        OR Location LIKE '%New York City%'
        OR Location LIKE '%State of New York%'
        OR Location LIKE '%Empire State%'
        OR Location LIKE '%Big Apple%'
        OR Location LIKE '%NY State%'
        OR Location LIKE '%New Yorker%';
    
# Question 6 -------------------------------------------------------------
SELECT 
    c.category_name, p.product_name, p.list_price
FROM
    Categories c
        INNER JOIN
    Products p ON c.category_id = p.category_id
ORDER BY c.category_name ASC , p.product_name ASC;

# Question 7 -------------------------------------------------------------
SELECT 
    c.first_name,
    c.last_name,
    a.line1,
    a.city,
    a.state,
    a.zip_code
FROM
    Customers AS c
        JOIN
    Addresses AS a ON c.customer_id = a.customer_id
WHERE
    c.email_address = 'allan.sherwood@yahoo.com';
    
# Question 8 -------------------------------------------------------------
SELECT 
    c.first_name,
    c.last_name,
    a.line1,
    a.city,
    a.state,
    a.zip_code
FROM
    Customers AS c
        JOIN
    Addresses AS a ON c.customer_id = a.customer_id
WHERE
    c.shipping_address_id = a.address_id;
    
# Question 9 -------------------------------------------------------------
SELECT 
    c.last_name,
    c.first_name,
    o.order_date,
    p.product_name,
    oi.item_price,
    oi.discount_amount,
    oi.quantity
FROM
    Customers c
        INNER JOIN
    orders o ON c.customer_id = o.customer_id
        INNER JOIN
    order_items oi ON o.order_id = oi.order_id
        INNER JOIN
    products p ON oi.product_id = p.product_id
ORDER BY c.last_name , o.order_date , p.product_name;

# Question 10 ------------------------------------------------------------
SELECT
    p1.product_name,
    p1.list_price
FROM
    Products p1
JOIN
    Products p2 ON p1.list_price = p2.list_price
WHERE
    p1.product_id <> p2.product_id
ORDER BY
    p1.product_name;
    
# Question 11 ------------------------------------------------------------
SELECT 
    'SHIPPED' AS ship_status, order_id, order_date
FROM
    Orders
WHERE
    ship_date IS NOT NULL 
UNION SELECT 
    'NOT SHIPPED' AS ship_status, order_id, order_date
FROM
    Orders
WHERE
    ship_date IS NULL
ORDER BY order_date;

# Question 12 ------------------------------------------------------------
SELECT 
    c.category_name,
    COUNT(DISTINCT p.product_id) AS product_count,
    MAX(p.list_price) AS max_product_price
FROM
    categories c
        INNER JOIN
    products p ON c.category_id = p.category_id
GROUP BY c.category_id
ORDER BY product_count DESC;

# Question 13 ------------------------------------------------------------
SELECT 
    c.email_address,
    COUNT(o.order_id) AS num_orders,
    SUM((oi.item_price - oi.discount_amount) * oi.quantity) AS total_amt
FROM
    customers c
        INNER JOIN
    orders o ON c.customer_id = o.customer_id
        INNER JOIN
    order_items oi ON oi.order_id = o.order_id
GROUP BY c.customer_id , c.email_address
HAVING COUNT(o.order_id) > 1
ORDER BY total_amt DESC;

# Question 14 ------------------------------------------------------------
SELECT 
    c.email_address,
    COUNT(DISTINCT oi.item_id) AS num_products_ordered
FROM
    customers c
        INNER JOIN
    orders o ON c.customer_id = o.customer_id
        INNER JOIN
    order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id , c.email_address
HAVING COUNT(DISTINCT oi.product_id) > 1
ORDER BY COUNT(DISTINCT oi.item_id);

# Question 15 ------------------------------------------------------------
SELECT DISTINCT
    product_name, list_price
FROM
    products
WHERE
    list_price > (SELECT 
            AVG(list_price)
        FROM
            products)
ORDER BY list_price DESC;

# Question 16 ------------------------------------------------------------
SELECT 
    c.category_name
FROM
    categories c
WHERE
    NOT EXISTS( SELECT 
            c.category_name
        FROM
            products p
        WHERE
            p.category_id = c.category_id);

# Question 17 ------------------------------------------------------------
SELECT 
    email_address, MAX(total_amt) AS biggest_order_amt
FROM
    (SELECT 
        c.email_address,
            o.order_id,
            SUM((oi.item_price - oi.discount_amount) * oi.quantity) AS total_amt
    FROM
        customers c
    INNER JOIN orders o ON c.customer_id = o.customer_id
    INNER JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY c.email_address , o.order_id) AS order_totals
GROUP BY email_address;

# Question 18 ------------------------------------------------------------
SELECT 
    product_name, discount_percent
FROM
    Products
WHERE
    discount_percent IN (SELECT 
            discount_percent
        FROM
            Products
        GROUP BY discount_percent
        HAVING COUNT(*) = 1)
ORDER BY product_name;

# Question 19 ------------------------------------------------------------
SELECT 
    list_price,
    FORMAT(list_price, 1),
    CONVERT( list_price , UNSIGNED),
    CAST(list_price AS UNSIGNED),
    date_added,
    CAST(date_added AS DATE),
    DATE_FORMAT(CAST(date_added AS DATE), '%Y-%m'),
    CAST(date_added AS TIME)
FROM
    products;
    
# Question 20 ------------------------------------------------------------
SELECT 
    card_number,
    LENGTH(card_number) AS card_num_length,
    RIGHT(card_number, 4) AS final_four,
    CONCAT('XXXX-XXXX-XXXX-', RIGHT(card_number, 4)) AS formatted_num
FROM
    Orders;

# Question 21 ------------------------------------------------------------
SELECT 
    n.`name` AS neighborhood_name
FROM
    neighborhoods n
        LEFT JOIN
    users u ON n.id = u.neighborhood_id
GROUP BY n.`name`
HAVING COUNT(u.id) = 0;

# Question 22 ------------------------------------------------------------
SELECT 
    u.`name` AS `name`, r.distance AS distance_traveled
FROM
    users u
        LEFT JOIN
    rides r ON u.id = r.passenger_user_id
GROUP BY u.id
ORDER BY r.distance DESC;

# Question 23 ------------------------------------------------------------
SELECT 
    CONCAT(CAST((COUNT(e.id) * 100 / d.total_employees) AS SIGNED),
            '%') AS percentage_over_100K,
    d.`name` AS department_name,
    COUNT(e.id) AS number_of_employees
FROM
    departments d
        JOIN
    (SELECT 
        department_id, COUNT(id) AS total_employees
    FROM
        employees
    GROUP BY department_id
    HAVING COUNT(id) >= 10) AS emps_100K ON d.id = emps_100K.department_id
        JOIN
    employees e ON d.id = e.department_id
        AND e.salary > 100000
GROUP BY d.`name`
ORDER BY percentage_over_100K DESC
LIMIT 3;

# Question 24 ------------------------------------------------------------
SELECT 
    df.`date` AS `date`,
    ad.paying_customer AS paying_customer,
    ROUND(AVG(df.downloads), 2) AS average_downloadss
FROM
    user_dimension ud
        INNER JOIN
    account_dimension ad ON ud.account_id = ad.account_id
        INNER JOIN
    download_facts df ON df.user_id = ud.user_id
GROUP BY df.`date` , ad.paying_customer
ORDER BY df.`date` , ad.paying_customer;

# Question 25 ------------------------------------------------------------
SELECT 
    COUNT(DISTINCT t1.user_id) AS num_of_upsold_customers
FROM
    transactions t1
        JOIN
    transactions t2 ON t1.user_id = t2.user_id
        AND t1.product_id != t2.product_id
        AND t1.id != t2.id
        AND DATE(t1.created_at) != DATE(t2.created_at);