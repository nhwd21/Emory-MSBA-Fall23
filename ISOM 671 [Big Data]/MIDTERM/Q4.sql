# Q 4.1: Random row sample ############################################################
SELECT 
    id, `name`
FROM
    big_table
ORDER BY RAND()
LIMIT 5; # pick only five

# Q4.2: Employee Salaries (ETL error) #######################################
SELECT 
    e.first_name AS first_name,
    e.last_name AS last_name,
    e.salary AS salary
FROM
    employees e
        JOIN
    (SELECT 
        first_name, last_name, MAX(id) AS max_id
    FROM
        employees
    GROUP BY first_name , last_name) max_ids ON e.first_name = max_ids.first_name
        AND e.last_name = max_ids.last_name
        AND e.id = max_ids.max_id;

# 4.3. Monthly Customer Report #######################
SELECT 
    DATE_FORMAT(t.created_at, '%Y-%m-01') AS `month`,
    COUNT(DISTINCT u.id) AS num_customers,
    COUNT(DISTINCT t.id) AS num_orders,
    SUM(p.price * t.quantity) AS order_amt
FROM
    transactions t
        JOIN
    users u ON t.user_id = u.id
        JOIN
    products p ON t.product_id = p.id
GROUP BY `month`
ORDER BY `month` ASC;

# 4.4. Closest SAT Score ####################################################
SELECT 
    t1.student AS one_student,
    t2.student AS other_student,
    ABS(t1.score - t2.score) AS score_diff
FROM
    scores AS t1
        JOIN
    scores AS t2 ON t1.id < t2.id
ORDER BY score_diff ASC, t1.id ASC, t2.id ASC
LIMIT 1;

# 4.5. Product Recommendation (co-purchases) ################################################
SELECT 
    p1.`name` AS P1, 
    p2.`name` AS P2, 
    COUNT(*) AS count
FROM 
    transactions t1
JOIN 
    transactions t2 ON t1.user_id = t2.user_id AND t1.product_id < t2.product_id
JOIN 
    products p1 ON t1.product_id = p1.id
JOIN 
    products p2 ON t2.product_id = p2.id
GROUP BY 
    t1.product_id, t2.product_id
ORDER BY 
    COUNT(*) DESC
LIMIT 100;
