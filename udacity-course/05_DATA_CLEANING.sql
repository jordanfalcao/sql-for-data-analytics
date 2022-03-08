-- LEFT(column, number)     - retorna um número específico de caracteres, começando do início
-- RIGHT(column, number)    - retorna um número específico de caracteres, começando do fim
-- SUBSTR(column, from_number, to_number) - retorna um número específico de caracteres, de FROM a TO
-- LENGTH(column)           - retorna o número de caracteres de cada linha da coluna especificada

-- 01 QUIZ

-- 01
-- quantos de cada tipo diferentes de website existem na tabela 'account'
SELECT RIGHT(website, 3) AS address_type, COUNT(*)
FROM accounts a
GROUP BY 1;

-- 02
-- retorne a primeira letra de cada conta e veja a distribuição de empresas que começam com cada letra/número
SELECT LEFT(name, 1) AS first_letter, COUNT(*)
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;

-- 03
-- criar duas colunas, uma com as empresas que começam o nome com um número e outro que começa com letra
-- qual a proporção?
WITH t1 AS (  -- criamos duas colunas se é num ou não
    SELECT CASE WHEN LEFT(name, 1) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9') THEN 1 ELSE 0 END AS num,
           CASE WHEN LEFT(name, 1) IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9') THEN 0 ELSE 1 END AS letter
    FROM accounts
)    
SELECT SUM(num) AS total_num, SUM(letter) AS total_letter
FROM t1;

-- 04
-- quantas empresas começam com vogal e quantas começam com qualquer outro tipo
WITH t1 AS (
    SELECT CASE WHEN LEFT(name, 1) IN ('a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U') THEN 1 ELSE 0 END AS vowel,
           CASE WHEN LEFT(name, 1) IN ('a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U') THEN 0 ELSE 1 END AS not_vowel
FROM accounts
)
SELECT SUM(vowel) AS total_vowel, SUM(not_vowel) AS total_others
FROM t1;

------------------------------------------------------------------------
-- POSITION('' IN column) AS column_name  - retorna a POSIÇÃO do caractere especificado \ retornam o mesmo valor
-- STRPOS(column, '') AS column_name      - retorna a POSIÇÃO do caractere especificado / retornam o mesmo valor
-- LOWER(column) AS column_name   - torna todas as letras da coluna em minúsculas
-- UPPER(column) AS column_name   - torna todas as letras da coluna em maiúsculas

-- 02 QUIZ

-- 01
-- criar colunas 'first' e 'last' com os nomes do 'primary_poc' da tabela 'accounts'
SELECT LEFT(primary_poc, POSITION(' ' IN primary_poc) - 1) AS first, 
       RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc)) AS last
FROM accounts ;

-- 02
-- faça o mesmo para coluna 'name' de 'sales_reps'
SELECT LEFT(name, STRPOS(name, ' ') - 1) AS first, 
       RIGHT(name, LENGTH(name) - STRPOS(name, ' ')) AS last
FROM sales_reps;

------------------------------------------------------------------------
-- CONCAT(first_column, '', last_column) AS column_name  \    duas maneiras de concatenar strings
-- first_column || '' || last_column AS column_name      /    duas maneiras de concatenar strings  (piping)

-- 03 QUIZ

-- 01 
-- criar um email para cada 'primary_poc' sendo: firstname.lastname@companyname.com
WITH t1 AS (
    SELECT LEFT(LOWER(primary_poc), STRPOS(primary_poc, ' ') - 1) AS first,
           RIGHT(LOWER(primary_poc), LENGTH(primary_poc) - POSITION(' ' IN primary_poc)) AS last, name
    FROM accounts 
)
SELECT first || '.' || last || '@' || LOWER(name) || '.com'
FROM t1;                                       -- NÃO FICOU MUITO ROBERTO CARLOS

-- 02
-- mesmo caso acima RETIRANDO todos os espaços
WITH t1 AS (
    SELECT LEFT(LOWER(primary_poc), STRPOS(primary_poc, ' ') - 1) AS first,
           RIGHT(LOWER(primary_poc), LENGTH(primary_poc) - POSITION(' ' IN primary_poc)) AS last, 
           name
    FROM accounts 
)
SELECT first || '.' || last || '@' || REPLACE(LOWER(name),' ', '') || '.com' AS email   -- REPLACE
FROM t1;


-- 03
-- criar uma SENHA INICIAL: primeira letra do 1º nome (minúscula), última letra do 1º nome (minúscula), 
-- primeira letra do último nome (minúscula), última letra do último nome (minúscula), 
-- o número de letas do 1º nome, o número de letras do último nome
-- nome da empresa na qual trabalham (MAIÚSCULA) e SEM espaços
WITH t1 AS (
    SELECT LEFT(LOWER(primary_poc), STRPOS(primary_poc, ' ') - 1) AS first,
       RIGHT(LOWER(primary_poc), LENGTH(primary_poc) - POSITION(' ' IN primary_poc)) AS last,
       name
    FROM accounts 
)
SELECT first || '.' || last || '@' || REPLACE(LOWER(name), ' ', '') || '.com' AS email,
    CONCAT(LEFT(first, 1), RIGHT(first, 1), LEFT(last, 1), RIGHT(last, 1), 
            LENGTH(first), LENGTH(last), REPLACE(UPPER(name), ' ', '')) AS initial_password
FROM t1;

------------------------------------------------------------------------------
-- função CAST converte de um tipo para outro
-- CAST(year_column || '-' || month_column || '-' || day_column AS DATE)  -- converte um formato de data p outro \ igual
-- (year_column || '-' || month_column || '-' || day_column)::DATE  -- converte um formato de data p outro       / igual
-- TO_DATE(column, 'chosen_part'), 'chosen_part' = 'year', 'month'.. converte uma 'date string' em 'date integer'
-- https://www.postgresqltutorial.com/postgresql-cast/

-- 04  QUIZ

-- 01
-- transformar do formato 'mm/dd/yyyy' para 'yyyy-mm-dd'
SELECT (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2))::DATE AS date_sql
FROM sf_crime_data


-------------------------------------------------------------------------------
-- função COALESCE(column, 'chosen_name') AS nem_column  -- atribui o valor escolhido a cada linha nula


-- 05 QUIZ

-- 01
-- preencher as colunas com os valores indicados no problema
SELECT COALESCE(a.id, o.id) AS filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id,
       COALESCE(o.account_id, a.id) AS account_id, o.occurred_at, COALESCE(o.standard_qty, 0) AS standard_qty,
       COALESCE(o.gloss_qty, 0) AS gloss_qty, COALESCE(o.poster_qty, 0) AS poster_qty, COALESCE(o.total, 0) AS total,
       COALESCE(o.standard_amt_usd, 0) AS standard_amt_usd, COALESCE(o.gloss_amt_usd, 0) AS gloss_amt_usd,
       COALESCE(o.poster_amt_usd, 0) AS poster_amt_usd, COALESCE(o.total_amt_usd, 0) AS total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

-- COUNT a quantidade de 'id' sem o WHERE
SELECT COUNT(*)
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id

-- run sem o WHERE
SELECT COALESCE(a.id, o.id) AS filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id,
       COALESCE(o.account_id, a.id) AS account_id, o.occurred_at, COALESCE(o.standard_qty, 0) AS standard_qty,
       COALESCE(o.gloss_qty, 0) AS gloss_qty, COALESCE(o.poster_qty, 0) AS poster_qty, COALESCE(o.total, 0) AS total,
       COALESCE(o.standard_amt_usd, 0) AS standard_amt_usd, COALESCE(o.gloss_amt_usd, 0) AS gloss_amt_usd,
       COALESCE(o.poster_amt_usd, 0) AS poster_amt_usd, COALESCE(o.total_amt_usd, 0) AS total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id