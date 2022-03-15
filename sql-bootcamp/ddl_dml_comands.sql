-- DATA DEFINITION LANGUAGE (DDL) AND DATA MANIPULATION LANGUAGE (DML):
-- CREATE, INSERT, UPDATE, DELETE, ALTER, DROP


-- CREATING TABLES IN THE 'LEARNING DATABASE' (AN EMPTY ONE) - 3 EXAMPLES:
CREATE TABLE account(
	user_id SERIAL PRIMARY KEY,
	username VARCHAR(50) UNIQUE NOT NULL,
	password VARCHAR(50) NOT NULL,
	email VARCHAR(250) UNIQUE NOT NULL,
	created_on TIMESTAMP NOT NULL,
	last_login TIMESTAMP
);

CREATE TABLE job (
	job_id SERIAL PRIMARY KEY,
	job_name VARCHAR(200) UNIQUE NOT NULL
);

CREATE TABLE account_job(
	user_id INTEGER REFERENCES account(user_id),
	job_id INTEGER REFERENCES job(job_id),
	hire_date TIMESTAMP 
);


CREATE TABLE information(
	info_id SERIAL PRIMARY KEY,
	title VARCHAR(500) NOT NULL,
	person VARCHAR(50) NOT NULL UNIQUE
);


-------------------------------------------------------------------------------------------------------
-- INSERTING A ROW INTO ACCOUNT TABLE:
INSERT INTO account(username, password, email, created_on) -- user_id is SERIAL, automatically filled
VALUES
('Jose', 'password', 'jose@mail.com', CURRENT_TIMESTAMP);


-- INSERTING ROWS INTO JOB TABLE:
INSERT INTO job(job_name) -- job_id is SERIAL, automatically filled
VALUES
('Astronaut');

INSERT INTO job(job_name) -- job_id is SERIAL, automatically filled
VALUES
('President');


-- INSERTING 'JOB-ACCOUNT' FOREIGN KEY:
INSERT INTO account_job(user_id, job_id, hire_date)
VALUES
(1, 1, 	CURRENT_TIMESTAMP) -- ASSOCIATING 'JOSE' WITH 'ASTRONAUT';


------------------------------------------------------------------------------------------------------
-- UPDATING 'LAST_LOGIN' COLUMN ON 'ACCOUNT' TABLE
UPDATE account
SET last_login = CURRENT_TIMESTAMP;

UPDATE account
SET last_login = created_on;


-- UPDATING 'ACCOUNT_JOB' TABLE BASED ON 'ACCOUNT' TABLE
UPDATE account_job aj
SET hire_date =  a.created_on
FROM account a
WHERE aj.user_id = a.user_id;


-- UPDATE WITH RETURNING: SHOWS UP THE SELECTED ROWS
UPDATE account
SET last_login = CURRENT_TIMESTAMP
RETURNING email, created_on, last_login;


--------------------------------------------------------------------------------------------------
-- DELETE AND RETURN THE DELETED ROW
DELETE FROM job
WHERE job_name = 'Cowboy'
RETURNING job_id, job_name;


----------------------------------------------------------------------------------------------
-- ALTER TABLE NAME
ALTER TABLE information
RENAME TO new_info;

-- ALTER COLUMN NAME
ALTER TABLE new_info
RENAME COLUMN person TO people;

-- ALTER COLUMN CONSTRAINT
ALTER TABLE new_info
ALTER COLUMN people DROP NOT NULL; -- remove NOT NULL constraint from people column

-- DROP A COLUMN
ALTER TABLE new_info
DROP COLUMN people;

-- DROP A COLUMN IF EXISTS - NOT RETURNS ERROR IF THE COLUMN DOESN'T EXIST.
ALTER TABLE new_info
DROP COLUMN IF EXISTS people;


--------------------------------------------------------------------------------------------
-- CREATE A TABLE WITH CHECK CONSTRAINT - RETURN ERROR IF YOU TRY INSERT SOME VALUE OUT OF THE RANGE
CREATE TABLE employees(
	emp_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	birthdate DATE CHECK (birthdate > '1900-01-01'),
	hire_date DATE CHECK (hire_date > birthdate),
	salary INTEGER CHECK (salary > 0)
);

