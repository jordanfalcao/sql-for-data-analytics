-- <h1> Aula 01 </h1>

-- SELECT and FROM

-- selecionando as colunas 'id, account_id, occurred_at' da tabela 'orders'
SELECT id, account_id, occurred_at
FROM orders

-- ignora espaços em branco e linhas, mesmo comando de cima
SELECT id, account_id, occurred_at FROM orders

-- <h4>Limitando a quantidade de linhas visualizadas:</h4>
SELECT occurred_at, account_id, channel
FROM web_events
LIMIT 15;

-----------------------------------------------------------------------------
-- ORDENANDO BUSCA:

-- Ordenando a busca pelos mais recentes
SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at
LIMIT 10;

-- Ordenando as buscas pelos 5 mais caros
SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 5;

-- Ordenando as buscas pelos 20 mais baratos
SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY total_amt_usd
LIMIT 20;

-- Ordenando por mais de uma variável em sequência
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY account_id, total_amt_usd DESC;

-- Ordenando por mais de uma variável em sequência
SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC, account_id;


-- Buscando um valor específico com WHERE
SELECT id, account_id, total_amt_usd
FROM orders
WHERE account_id = 4251
ORDER BY occurred_at
LIMIT 1000;

-- Todas as colunas, 10 primeiras linhas da tabela 'orders' onde 'gloss_amt_usd < 500'
SELECT *
FROM orders
WHERE gloss_amt_usd < 500
LIMIT 10;

-- Aspas SIMPLES para query diferente de números
SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil';

--------------------------------------------------------------------------
-- NOVA COLUNA:

-- Criando nova coluna 'unit_price' que recebe 'standard_amt_usd / standard_qty'
SELECT id, account_id, standard_amt_usd / standard_qty AS unit_price
FROM orders
LIMIT 10;    --  limitando para evitar divisão por 0

-- nova coluna com a porcentagem de 'poster_amt_usd' sem usar o valor total (somamos todos os tipos)
SELECT id, account_id, poster_amt_usd / (poster_amt_usd + standard_amt_usd + gloss_amt_usd) AS poster_percentage
FROM orders
LIMIT 10;    --  limitando para evitar divisão por 0

-----------------------------------------------------------------------
-- OPERADORES LÓGICOS (LOGICAL OPERATORS):

-- LIKE:

-- selecionar todas as empresas que comecem com a letra 'C'
SELECT name
FROM accounts
WHERE name LIKE 'C%';  -- % indica que não importa a quantidade de caracteres após

-- todas as empresas que tem o trecho 'one' no nome
SELECT name
FROM accounts
WHERE name LIKE '%one%';  -- % indica que não importa a quantidade de caracteres antes ou depois

-- todas as empresas que terminam com a letra 's'
SELECT name
FROM accounts
WHERE name LIKE '%s'; -- % indica que não importa a quantidade de caracteres depois


-- IN:

-- empresas com nome igual a 'Walmart', 'Target' ou 'Nordstrom'
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom');

-- pessoas que foram conectadas pelos canais 'organic' ou 'adwords'
SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords');


-- NOT:

-- empresas com nome DIFERENTE a 'Walmart', 'Target' ou 'Nordstrom'
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name NOT IN ('Walmart', 'Target', 'Nordstrom');

-- selecionar todas as empresas que NÃO comecem com a letra 'C'
SELECT name
FROM accounts
WHERE name NOT LIKE 'C%'; 

-- todas as empresas que NÃO tem o trecho 'one' no nome
SELECT name
FROM accounts
WHERE name NOT LIKE '%one%';


-- AND & BETWEEN

-- pedidos com 'standard_qty > 1000' e 'poster_qty e gloss_qty = 0'
SELECT *
FROM orders
WHERE standard_qty > 1000 AND poster_qty = 0 AND gloss_qty = 0

-- empresas que NÃO comecem com a letra 'C' e terminem com a letra 's'
SELECT name
FROM accounts
WHERE name NOT LIKE 'C%' AND name LIKE '%s'; 

-- BETWEEN INCLUI os valores do intervalo [24, 29]
SELECT occurred_at, gloss_qty 
FROM orders
WHERE gloss_qty BETWEEN 24 AND 29;

-- pessoas contatadas via channel ('organic', 'adwords') AND no ano de 2016
SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords') AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01' -- em datas vai até 00h
ORDER BY occurred_at DESC;


-- OR

-- ID dos pedidos com 'gloss_qty > 4000' OU 'poster_qty > 4000'
SELECT id
FROM orders
WHERE gloss_qty > 4000 OR poster_qty > 4000;

-- empresas que comecem com 'C ou W' E o contato principal contenha 'Ana ou ana' mas NÃO 'eana'
SELECT *
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%')
AND ((primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%') AND primary_poc NOT LIKE '%eana%');