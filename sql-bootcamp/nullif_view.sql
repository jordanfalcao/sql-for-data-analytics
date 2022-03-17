-- NULLIF: 2 PARAMETERS, RETURNS NULL IF BOTH ARE EQUAL, ELSE RETURN THE FIRST ONE

-- CREATE A NEW TABLE IN A NEW DATABASE 
CREATE TABLE depts(
	first_name VARCHAR(50),
	department VARCHAR(50)
)

-- INSERT 3 ROWS
INSERT INTO depts(
	first_name,
	department
)
VALUES
('Vinton', 'A'),
('Lauren', 'A'),
('Claire', 'B');

-- DELETE ROW CORRESPONDING TO DEPARTMENT B
DELETE FROM depts
WHERE department = 'B'

-- ADD 'NULLIF' TO AVOID ERROR, BECAUSE THERE ISN'T DIVISION BY 0
SELECT (
SUM(CASE WHEN department = 'A' THEN 1 ELSE 0 END)/
NULLIF(SUM(CASE WHEN department = 'B' THEN 1 ELSE 0 END), 0) -- if both parameters are equal, return NULL, ELSE return the first one
) AS department_ratio
FROM depts

------------------------------------------------------------------------------------------------------------------------------------

-- VIEW: CREATE A VIRTUAL QUERY YOU NEED USE VERY OFTEN OR A COMPLEX QUERY:
CREATE VIEW customer_info AS
SELECT first_name, last_name, address
FROM customer AS c
JOIN address AS a
ON c.address_id = a.address_id

-- NOW, YOU CAN RETURN BACK THE SAME OUTPUT SIMPLY:
SELECT * FROM customer_info

-- CHANGE OR REPLACE THE VIEW
CREATE OR REPLACE VIEW customer_info AS
SELECT first_name, last_name, address, district -- add a new column
FROM customer AS c
JOIN address AS a
ON c.address_id = a.address_id

-- REMOVING A VIEW:
DROP VIEW customer_info
-- or
DROP VIEW IF EXISTS customer_info -- AVOID ERROR

-- ALTER NAME
ALTER VIEW customer_info  RENAME TO c_info