-- CASE 

-- GENERAL CASE: CLASSIFY 100 FIRST COSTUMERS AS PREMIUM
SELECT customer_id,
CASE 
	WHEN (customer_id <= 100) THEN 'Premium'
	WHEN (customer_id BETWEEN 101 AND 200) THEN 'Plus'
	ELSE 'Normal'
END
FROM customer;

-- EXPRESSION CASE: LESSE FLEXIBLE THEN ABOVE 'GENERAL CASE'
SELECT customer_id,
CASE customer_id                    -- expression to be matched
	WHEN 2 THEN 'Winner'            -- we only grab EQUALITY
	WHEN 5 THEN 'Second Place'
	ELSE 'Normal'
END AS raffle_results
FROM customer;



-- USING AGGREGATE FUNCTIONS WITH CASE:

-- JUST CREATING A COLUMN THAT SET 1 WHEN 'rental_rate' IS EQUAL TO 0.99
SELECT rental_rate,
CASE rental_rate
	WHEN 0.99 THEN 1
	ELSE 0
END
FROM film;

-- NOW: SUMMING (COUNT) HOW MANY ROWS IS EQUAL TO 0.99
SELECT
SUM(CASE rental_rate
	WHEN 0.99 THEN 1
	ELSE 0
END) AS numer_of_bargains
FROM film;

-- 2 DIFFERENTS COLUMNS: FIRST ONE IS THE SAME AS LAST EXAMPLE AND THE SECOND ONE COUNT THE 2.99 CUSTOMERS
SELECT
SUM(CASE rental_rate
	WHEN 0.99 THEN 1
	ELSE 0
END) AS bargains,
SUM(CASE rental_rate
	WHEN 2.99 THEN 1
	ELSE 0
END) AS regular
FROM film;

----------------------------------------------------------------------------------------------------------

-- WE WANT TO KNOW AND COMPARE THE VARIOUS AMOUNTS OF FILMS WE HAVE PER MOVING RATE
-- USE 'CASE' AND THE dvdrental DATABASE TO COUNT THE 'R', 'PG' AND 'PG-13' RATING
SELECT
SUM(CASE rating
	WHEN 'R' THEN 1
	ELSE 0
END) AS r,
SUM(CASE rating
	WHEN 'PG' THEN 1
	ELSE 0
END) AS pg,
SUM(CASE rating
	WHEN 'PG-13' THEN 1
	ELSE 0
END) AS pg13
FROM film;

-----------------------------------------------------------------------------------------------------

-- COALESCE: RETURN FIRST NON NULL VALUE



----------------------------------------------------------------------------------------------------

-- CAST: CHANGE VARIABLE TYPE

-- COUNT THE NUMBER OF DIGITS FROM inventory_id
SELECT CHAR_LENGTH(CAST(inventory_id AS VARCHAR))  -- first convert to varchar and then count characters
FROM rental;

-- SAME THING, BUT ONLY IN POSTGRESQL
SELECT CHAR_LENGTH(inventory_id::VARCHAR)
FROM rental;