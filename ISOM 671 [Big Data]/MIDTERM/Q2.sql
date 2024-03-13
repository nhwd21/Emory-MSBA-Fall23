use sakila;
# 2.1. Check if a movie is in stock #######################################
SELECT inventory_id, store_id
FROM inventory
WHERE film_id = (
    SELECT film_id
    FROM film
    WHERE title = 'ACADEMY DINOSAUR'
)
AND inventory_id NOT IN (
    SELECT inventory_id
    FROM rental
    WHERE return_date IS NULL
)
LIMIT 5;

# 2.2 Checkout the movie for customer "Dwayne Olvera" ##############################
INSERT INTO rental(rental_date, inventory_id, customer_id, staff_id)
SELECT NOW(), inventory.inventory_id, customer.customer_id, 1
FROM inventory
JOIN film ON inventory.film_id = film.film_id
JOIN customer ON customer.store_id = inventory.store_id
WHERE film.title = 'ACADEMY DINOSAUR'
AND customer.first_name = 'DWAYNE'
AND customer.last_name = 'OLVERA'
AND inventory.inventory_id NOT IN (
    SELECT inventory_id
    FROM rental
    WHERE return_date IS NULL
)
LIMIT 1;

# Q2.3 Collect rental payment and add a row in the payment table ##########################################################
INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date, last_update)
VALUES (
    (SELECT customer_id 
     FROM customer 
     WHERE first_name = 'DWAYNE' AND last_name = 'OLVERA'),
    1,
    (SELECT rental_id 
     FROM rental 
     WHERE customer_id = (SELECT customer_id 
                           FROM customer 
                           WHERE first_name = 'DWAYNE' AND last_name = 'OLVERA')
     ORDER BY rental_date DESC 
     LIMIT 1),
    (SELECT rental_rate 
     FROM film 
     WHERE film_id = (
         SELECT film_id 
         FROM inventory 
         WHERE inventory_id = 1)),
    NOW(), NOW()
);
SELECT * FROM payment WHERE customer_id IN (SELECT customer_id FROM customer WHERE first_name = "DWAYNE" AND last_name = "OLVERA");

# 2.4 Overdue Movie List ##########################################################################
SELECT 
    film.title AS movie_title,
    rental.rental_date AS rental_date,
    rental.return_date AS return_date,
    film.rental_duration AS rental_duration,
    DATEDIFF('2006-02-18',
            DATE_ADD(rental_date,
                INTERVAL rental_duration DAY)) AS days_overdue
FROM
    rental
        JOIN
    inventory ON rental.inventory_id = inventory.inventory_id
        JOIN
    film ON inventory.film_id = film.film_id
WHERE
    return_date IS NULL
        AND rental_duration < DATEDIFF('2006-02-18', rental_date)
ORDER BY rental.rental_date DESC
LIMIT 5;