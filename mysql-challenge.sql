USE sakila;

-- 1A
SELECT	first_name,
		last_name
FROM actor;

-- 1B
SELECT UPPER(CONCAT(first_name, ' ', last_name)) AS 'Actor Name'
FROM actor;

-- 2A
SELECT	actor_id, 
		first_name, 
        last_name
FROM actor
WHERE first_name = 'Joe';

-- 2B
SELECT	actor_id, 
		first_name, 
        last_name
FROM actor
WHERE last_name LIKE '%GEN%';

-- 2C
SELECT	actor_id, 
		first_name, 
        last_name
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

-- 2D
SELECT	country_id,
		country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3A
ALTER TABLE actor
ADD COLUMN middle_name VARCHAR(20) AFTER first_name;

-- 3B
ALTER TABLE actor
MODIFY COLUMN middle_name BLOB;

-- 3C
ALTER TABLE actor
DROP COLUMN middle_name;

-- 4A
SELECT 	last_name,
		COUNT(last_name) AS count
FROM actor
GROUP BY last_name;

-- 4B
SELECT 	last_name,
		COUNT(last_name) AS count
FROM actor
GROUP BY last_name
HAVING count > 1;

-- 4C
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

-- 4D
UPDATE actor
SET first_name = IF(first_name = 'HARPO', 'GROUCHO', 'MUCHO GROUCHO')
WHERE actor_id = 172;

-- 5A
SHOW CREATE TABLE address;

-- 6A
SELECT 	first_name,
		last_name,
        address
FROM staff
JOIN address USING(address_id);

-- 6B
SELECT 	last_name,
		SUM(amount) AS total_amount
FROM payment
JOIN staff USING(staff_id)
WHERE payment_date >= STR_TO_DATE('20050801','%Y%m%d') AND payment_date < STR_TO_DATE('20050901','%Y%m%d')
GROUP BY last_name;

-- 6C
SELECT 	title,
		COUNT(actor_id) AS actor_count
FROM film_actor
INNER JOIN film USING(film_id)
GROUP BY title;

-- 6D
SELECT  title,
		COUNT(inventory_id) AS 'Number of Copies'
FROM inventory
JOIN film USING(film_id)
WHERE title = 'Hunchback Impossible';

-- 6E
SELECT  customer_id,
		first_name,
		last_name,
        SUM(amount) As total_paid
FROM payment
JOIN customer USING(customer_id)
GROUP BY customer_id
ORDER BY last_name;

-- 7A
SELECT title
FROM film
WHERE title  LIKE 'K%' OR 
	title LIKE 'Q%' AND
    language_id = (
		SELECT language_id
        FROM language 
        WHERE name = 'English'
        );

-- 7B
SELECT	first_name,
		last_name
FROM actor
WHERE actor_id IN (
	SELECT actor_id
    FROM film_actor
    WHERE film_id = (
		SELECT film_id
        FROM film
        WHERE title = 'Alone Trip'
        )
	);

-- 7C
SELECT 	first_name,
		last_name,
        email,
        country
FROM customer
JOIN address USING(address_id)
JOIN city USING (city_id)
JOIN country using (country_id)
WHERE country = 'Canada';

-- 7D
SELECT 	title,
		c.name AS category_name
FROM film
JOIN film_category USING(film_id)
JOIN category c USING(category_id)
WHERE c.name = 'Family';

-- 7E
SELECT 	title,
		COUNT(rental_date) AS rental_frequency
FROM rental
JOIN inventory USING(inventory_id)
JOIN film USING(film_id)
GROUP BY title
ORDER BY COUNT(rental_date) DESC;

-- 7F
SELECT 	store_id,
		SUM(amount) AS total_volume
FROM payment
JOIN staff USING(staff_id)
GROUP BY store_id;

-- 7G
SELECT 	store_id,
		city,
        country
FROM store
JOIN address USING(address_id)
JOIN city USING(city_id)
JOIN country USING(country_id);

-- 7H
SELECT  name AS genre,
		SUM(amount) AS gross_revenue
FROM payment
JOIN rental USING(rental_id)
JOIN inventory USING(inventory_id)
JOIN film_category USING(film_id)
JOIN category USING(category_id)
GROUP BY name
ORDER BY SUM(amount) DESC
LIMIT 5;

-- 8A
CREATE VIEW top_5_genres AS
	SELECT  name AS genre,
		SUM(amount) AS gross_revenue
	FROM payment
	JOIN rental USING(rental_id)
	JOIN inventory USING(inventory_id)
	JOIN film_category USING(film_id)
	JOIN category USING(category_id)
	GROUP BY name
	ORDER BY SUM(amount) DESC
	LIMIT 5;

-- 8B
SELECT * FROM top_5_genres;

-- 8C
DROP VIEW top_5_genres;
