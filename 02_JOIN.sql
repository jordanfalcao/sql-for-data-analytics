-- JOIN (INNER JOIN)

-- nome das contas e data de ocorrência do pedido (tabelas 'orders' e 'accounts')
SELECT accounts.name, orders.occurred_at -- selecionando o nome (accounts) e a data (orders)
FROM orders                         -- primeira tabela
JOIN accounts                       -- segunda tabela
ON orders.account_id = accounts.id; -- para vincular uma tabela a outra

-- TODAS as informações (colunas) das duas tabelas 'orders' e 'accounts'
SELECT *
FROM orders
JOIN accounts
ON orders.account_id = accounts.id; -- PK = FK

-- colunas esoecíficas de cada tabela
SELECT orders.standard_qty, orders.gloss_qty, orders.poster_qty, accounts.website, accounts.primary_poc
FROM orders
JOIN accounts
ON orders.account_id = accounts.id; -- PK = FK

-- JOIN e duas ou mais tabelas, sempre conectando os PK aos FK
SELECT *
FROM web_events
JOIN accounts
ON web_events.account_id = accounts.id  
JOIN orders
ON accounts.id = orders.account_id

-- podemos dar APELIDOS às tabelas
FROM tablename AS t1
JOIN tablename2 AS t2

-- também pode ser sem o AS
FROM tablename t1
JOIN tablename2 t2

-- podemos fazer o mesmo para as colunas das tabelas:
Select t1.column1 aliasname, t2.column2 aliasname2   -- sem o AS
FROM tablename AS t1
JOIN tablename2 AS t2

-- apenas os eventos associados ao nome Walmart
SELECT a.primary_poc, w.channel, w.occurred_at, a.name
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE a.name = 'Walmart';

-- neste caso, devemos RENOMEAR as colunas, pois elas tem o mesmo nome
SELECT r.name region, s.name rep, a.name accounts
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
ORDER BY a.name;

-- 3 colunas, join em 4 tabelas
SELECT r.name region, a.name account, o.total_amt_usd/(o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id;

------------------------------------------------------------------------------------------

-- LEFT OUTER JOIN (LEFT JOIN), RIGHT OUTER JOIN (RIGHT JOIN) e FULL OUTER JOIN (FULL JOIN):


-- AND substitui o WHERE, melhor a performance da busca. INNER JOIN
-- 01
 SELECT r.name RegionName, s.name SalesRepName, a.name AcountName
 FROM region r
 JOIN sales_reps s
 ON r.id = s.region_id
  AND r.name = 'Midwest'
 JOIN accounts a
 ON s.id = a.sales_rep_id
 ORDER BY a.name;

-- apenas vendedores com nome começando com a letra 'S' e na região 'Midwest'
-- 02
SELECT r.name RegionName, s.name SalesRepName, a.name AcountName
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
AND r.name = 'Midwest'
JOIN accounts a
ON s.id = a.sales_rep_id
AND s.name LIKE 'S%' 
ORDER BY a.name;

-- sobrenome começandoc com a letra 'K'
-- 03
SELECT r.name RegionName, s.name SalesRepName, a.name AcountName
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
AND r.name = 'Midwest'
JOIN accounts a
ON s.id = a.sales_rep_id
AND s.name LIKE '% K%' 
ORDER BY a.name;

-- nome da região, nome da conta e o preço unitário, se a quantidade > 100
-- 04
SELECT r.name region, a.name account, (o.total_amt_usd/o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
AND standard_qty > 100;

-- mesmo acima, com poster_qty > 50 e ordenado pelo preço unitário
-- 05
SELECT r.name region, a.name account, (o.total_amt_usd/o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
AND standard_qty > 100 AND poster_qty > 50
ORDER BY unit_price;

-- ordem decrescente do preço unitário
-- 06
SELECT r.name region, a.name account, (o.total_amt_usd/o.total + 0.01) unit_price
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
AND standard_qty > 100 AND poster_qty > 50
ORDER BY unit_price DESC;

--
-- 07
SELECT DISTINCT a.name, w.channel  -- DISTINCT, apenas valroes únicos
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
AND a.id = 1001;

-- 4 colunas, todos os pedidos feitos em 2015
-- 08
SELECT o.occurred_at, a.name, o.total, o.total_amt_usd
FROM accounts a
JOIN orders o
ON a.id = o.account_id
AND o.occurred_at BETWEEN '2015-01-01' AND '2016-01-01';