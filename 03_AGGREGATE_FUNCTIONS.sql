-- COUNT
-- retorna a quantidade de linhas NÃO NULAS
SELECT COUNT(*) AS order_count
FROM orders;


-- SUM
-- retorna a soma de valores NÚMERICOS e NÃO NULOS
SELECT SUM(standard_qty) AS standard_qty
FROM orders;


-- 01 QUIZ

-- total de vendas de poster paper
SELECT SUM(poster_qty) total_poster_sales
FROM orders;

-- total de vendas de standard paper
SELECT SUM(standard_qty) total_standard_sales
FROM orders;

-- valor total vendido (USD)
SELECT SUM(total_amt_usd) total_dollar_sales
FROM orders;

-- valor total do standar e gloss paper (USD), separadamente
SELECT SUM(standard_amt_usd) standard_total, 
SUM(gloss_amt_usd) gloos_total
FROM orders;

-- preço por unidade do standard paper
SELECT SUM(standard_amt_usd)/ SUM(standard_qty) AS standard_price_per_unit
FROM orders;


-- MIN e MAX
-- retorna o mínimo e o máximo, respectivamente, da coluna indicada
-- pode receber como parâmetro um NÚMERO, uma DATA ou uma STRING (ordem alfabética)


-- AVG
-- retorna a média da coluna indicada, apenas valores NUMÉRICOS
-- ignora colunas NULL


-- 02 QUIZ

-- 01
-- pedido mais antigo
SELECT MIN(occurred_at)
FROM orders;

-- 02
-- mesma questão acima sem usar aggregation function
SELECT occurred_at
FROM orders
ORDER BY occurred_at
LIMIT 1;

-- 03
-- quando o web event mais recente ocorreu
SELECT MAX(occurred_at)
FROM web_events;

-- 04
-- mesma questão acima sem aggregation function
SELECT occurred_at
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1;

-- 05
-- média dos valores dos pedidos e média da quentidade pedida de cada tipo de papel
SELECT AVG(standard_amt_usd) avg_standard, AVG(gloss_amt_usd) avg_gloss, AVG(poster_amt_usd) avg_poster, 
       AVG(standard_qty) avg_standard_qty, AVG(gloss_qty) avg_gloss_qty, AVG(poster_qty) avg_poster_qty
FROM orders;

-- 06
-- mediana na gambiarra, SQL não calcula mediana
SELECT *
FROM (SELECT total_amt_usd
      FROM orders
      ORDER BY total_amt_usd
      LIMIT 3457) AS Table1  -- 3456 é metade dos valores
ORDER BY total_amt_usd DESC
LIMIT 2; -- pegamos o resultado e tiramos a média


-- GROUP BY

-- 03 QUIZ

-- 01
-- nome da conta que fez o pedido mais antigo
SELECT a.name, o.occurred_at
FROM accounts a
JOIN orders o
ON a.id = o.account_id
ORDER BY o.occurred_at
LIMIT 1;

-- 02
-- total de valor gasto por cada conta
SELECT a.name, SUM(o.total_amt_usd) total_amt_usd_per_account
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name

-- 03
-- qual canal e conta associada ao web event mais recente
SELECT w.occurred_at, w.channel, a.name
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
ORDER BY w.occurred_at DESC
LIMIT 1;

-- 04
-- quantas vezes cada canal dos eventos web foram usados
SELECT w.channel, COUNT(w.channel)
FROM web_events w
GROUP BY w.channel;

-- 05
-- o contato principal associado ao evento mais antigo
SELECT a.primary_poc
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
ORDER BY w.occurred_at
LIMIT 1

-- 06
-- valor mínimo pedido por cada conta, ordernar pelo menor valor
SELECT a.name, MIN(o.total_amt_usd) smallest_order
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY smallest_order;

-- 07
-- quantidade de representantes em cada região, ordernar da menor quantidade para a maior
SELECT r.name, COUNT(*) num_reps
FROM sales_reps s
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
ORDER BY num_reps;

-- 04 QUIZ

-- 01
-- média de pedidos de cada tipo de papel e a conta associada
SELECT a.name, AVG(standard_qty) AS avg_standard, AVG(poster_qty) AS avg_poster, AVG(gloss_qty) AS avg_gloss
FROM accounts AS a
JOIN orders AS o
ON a.id = o.account_id
GROUP BY a.name;

-- 02
-- média dos valores gastos em cada tipo de papel e a conta associada
SELECT a.name, AVG(standard_amt_usd) AS avg_amt_standard, AVG(poster_amt_usd) AS avg_amt_poster, 
       AVG(gloss_amt_usd) AS avg_amt_gloss
FROM accounts AS a
JOIN orders AS o
ON a.id = o.account_id
GROUP BY a.name;

-- 03
-- quantidade de vezes que um 'channel' foi usado num 'web_event' para cada 'sales_rep'
-- ordenar pelo maior número de ocorrência
SELECT s.name, w.channel, COUNT(w.channel) AS num_events
FROM sales_reps AS s
JOIN accounts AS a
ON s.id = a.sales_rep_id
JOIN web_events AS w
ON a.id = w.account_id
GROUP BY s.name, w.channel
ORDER BY num_events DESC;

-- 04
-- quantidade de vezes que um 'channel' foi usado num 'web_event' para cada 'region'
-- ordenar pelo maior número de ocorrência
SELECT r.name, w.channel, COUNT(w.channel) AS num_events
FROM sales_reps AS s
JOIN accounts AS a
ON s.id = a.sales_rep_id
JOIN web_events AS w
ON a.id = w.account_id
JOIN region AS r
ON r.id = s.region_id
GROUP BY r.name, w.channel
ORDER BY num_events DESC;


-- 05 QUIZ

-- 01
-- usar o DISTINCT para verificar se cada conta é associada a mais de uma região
SELECT DISTINCT a.name AS account_name, r.name AS region_name, a.id AS account_id, r.id AS region_id
FROM accounts AS a
JOIN sales_reps AS s
ON s.id = a.sales_rep_id
JOIN region AS r
ON r.id = s.region_id;       -- 351 linhas

SELECT DISTINCT id, name
FROM accounts;               -- 351 linhas
-- As duas query tem o mesmo númerode linhas (351), logo, cada conta é associada a apenas uma região

-- também poderíamos contar e imprimir em ordem crescente, o mínimo e o máximo de região é '1'
SELECT a.id as "account id", r.id as "region id", 
a.name as "account name", r.name as "region name", COUNT(*) num_region
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id
GROUP BY a.id, r.id, a.name, r.name
ORDER BY num_region;


-- 02
-- há 'sales_rep' associados a mais de uma 'conta'?
SELECT DISTINCT s.id AS sales_rep_id, a.id AS account_id, s.name AS sales_rep_name, a.name AS account_name
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id;   -- 351 linhas

SELECT DISTINCT id, name
FROM sales_reps;            -- 50 linhas
-- Cada representante está associado a mais de uma conta

-- também poderíamos contabilizar e notar que cada 'sales_rep' é associado a pelo menos 3 'contas'
SELECT s.id AS sales_rep_id, s.name AS sales_rep_name, COUNT(*) AS num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
ORDER BY num_accounts;


-- HAVING
-- Funciona como o WHERE, com condições lógicas, porém, é utilizado em AGGREGATE FUNCTIONS
-- HAVING aparece após o GROUP BY e antes do ORDER BY

-- 06 QUIZ

-- 01
-- quantos 'sales_rep' gerenciam mais de 5 contas
SELECT s.id, s.name, COUNT(*) AS num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
HAVING COUNT(*) > 5
ORDER BY num_accounts;   -- 34 'sales_rep' rows

-- podemos realizar uma SUBQUERY, que retornará apenas uma coluna 'num_reps_above5' com o valor 34
SELECT COUNT(*) num_reps_above5
FROM(SELECT s.id, s.name, COUNT(*) num_accounts
     FROM accounts a
     JOIN sales_reps s
     ON s.id = a.sales_rep_id
     GROUP BY s.id, s.name
     HAVING COUNT(*) > 5
     ORDER BY num_accounts) AS Table1;


-- 02
-- quantas 'accounts' tem mais de 20 'orders'
SELECT COUNT(*) AS num_accounts_above_20
FROM(SELECT a.id, a.name, COUNT(*) AS num_orders
     FROM accounts a
     JOIN orders o
     ON a.id = o.account_id
     GROUP BY a.id, a.name
     HAVING COUNT(*) > 20
     ORDER BY num_orders) AS t1;   -- 120


-- 03
-- qual conta tem o maior número de 'orders'
SELECT a.id, a.name, COUNT(*) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY num_orders DESC
LIMIT 1;

-- se quiséssemos apenas a maior quantidade de pedidos
SELECT MAX(num_orders)
FROM(SELECT a.id, a.name, COUNT(*) AS num_orders
	FROM accounts a
	JOIN orders o
	ON a.id = o.account_id
	GROUP BY a.id, a.name
	ORDER BY num_orders DESC) AS t1;   -- 71


-- 04
-- quais 'contas' gastaram mais de USD 30.000 com todos os pedidos
SELECT a.id, a.name, SUM(o.total_amt_usd) AS total_amt_per_account
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY total_amt_per_account;


-- 05
-- quais contas gastaram menos de USD 1.000 com todos os pedidos
SELECT a.id, a.name, SUM(o.total_amt_usd) AS total_amt_per_account
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) < 1000
ORDER BY total_amt_per_account;

-- 06
-- qual conta gastou MAIS
SELECT a.id, a.name, SUM(o.total_amt_usd) AS total_amt_per_account
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_amt_per_account DESC
LIMIT 1;

-- 07
-- qual conta gastou MENOS
SELECT a.id, a.name, SUM(o.total_amt_usd) AS total_amt_per_account
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_amt_per_account
LIMIT 1;

-- 08
-- quais 'contas' usaram 'facebook' como 'channel' para contatar cliente mais de 6 vezes
SELECT a.name, w.channel, COUNT(*) AS num_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
AND w.channel = 'facebook'
GROUP BY a.name, w.channel
HAVING COUNT(*) > 6

-- 09
-- qual conta usou o 'channel' 'facebook' mais vezes
SELECT a.name, w.channel, COUNT(*) AS num_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
AND w.channel = 'facebook'
GROUP BY a.name, w.channel
HAVING COUNT(*) > 6
ORDER BY num_channel DESC
LIMIT 1;

-- 10
--
SELECT w.channel, COUNT(*) AS num_channel
FROM web_events w
GROUP BY w.channel
HAVING COUNT(*) > 6
ORDER BY num_channel DESC
LIMIT 1;               -- direct

----------------------------------------------------------------------------------

-- DATE FUNCTIONS (DATAS)

-- DATE_TRUNC('time', column):  time = 'day', 'month', 'year', 'second', etc.
-- trunca a data no tempo escolhido
SELECT DATE_TRUNC('day', occurred_at) AS day, SUM(standard_qty) AS standard_qty_sum
FROM orders
GROUP BY DATE_TRUNC('day', occurred_at)
ORDER BY DATE_TRUNC('day', occurred_at)

-- DATE_PART
-- seleciona apenas uma parte específica da data

-- 'dow' -> day of the week (0,  6) -> (domingo, sábado) - usado junto com DATE_PART


-- 07 QUIZ

-- 01
-- total de vendas para cada ano, ordenar do maior para o menor
SELECT DATE_PART('year', occurred_at), SUM(total_amt_usd)
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

-- 02
-- qual mês vende mais em termo de dólar
SELECT DATE_PART('month', occurred_at) AS month, SUM(total_amt_usd) AS total_month_sales
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'  -- eliminamos 12/2013 e 01/2017
GROUP BY 1
ORDER BY 2 DESC;

-- 03
-- qual ano teve mais 'orders'
SELECT DATE_PART('year', occurred_at), COUNT(*) AS num_orders
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

-- 04
-- qual mês possui o maior número de pedidos
SELECT DATE_PART('month', occurred_at), COUNT(*) AS num_orders
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'  -- eliminamos 12/2013 e 01/2017
GROUP BY 1
ORDER BY 2 DESC;

-- 05
-- em qual mês de qual ano 'Walmart' gastou maior quantidade em USD com 'gloss paper'
SELECT DATE_TRUNC('month', occurred_at), a.name, SUM(gloss_amt_usd) AS total_gloss_amt_usd
FROM accounts a
JOIN orders o
ON a.id = o.account_id
AND a.name = 'Walmart'
GROUP BY 1, 2
ORDER BY 3 DESC;


-- CASE, WHEN, THEN, ELSE
-- CASE sempre vai na aba SELECT
-- exemplo
SELECT id, CASE WHEN channel = 'facebook' THEN 'yes' ELSE 'no' END AS is_facebook

-- exemplo
SELECT account_id, occurred_at, total,
    CASE WHEN total > 500 THEN 'Over 500'
         WHEN total > 300 AND total <= 500 THEN '301 - 500'
         WHEN total > 100 AND total <= 300 THEN '101 - 300'
         ELSE '100 or under' END AS total_group
FROM orders


-- 08 QUIZ

-- 01
-- retornar o 'account id', o 'total_amt' associado e se é do tipo 'Large' ou 'Small', se >= 3000
SELECT a.id, o.total_amt_usd, CASE WHEN o.total_amt_usd >= 3000 THEN 'Large' ELSE 'Small' END AS order_level
FROM accounts a
JOIN orders o
ON a.id = o.account_id;

-- 02
-- número de pedidos em cada categoria (x >= 2000, 1000 <= x < 2000, x < 1000), para o 'total' de pedido
SELECT CASE WHEN total >= 2000 THEN 'At Least 2000'
			WHEN total BETWEEN 1000 AND 1999 THEN 'Between 1000 and 2000'
            ELSE 'Less than 1000' END AS category,
COUNT(*) AS num_orders
FROM orders
GROUP BY 1;

-- 03
-- categorizar os clientes com base no total gasto (USD) 0 - 100.000 - 200.000, ordenar do maior para o menor
SELECT a.name, SUM(o.total_amt_usd) AS total_spent,
	CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'top'
    	 WHEN SUM(o.total_amt_usd) BETWEEN 100000 AND 200000 THEN 'middle'
         ELSE 'low' END AS level_account
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC;

-- 04
-- mesmo caso acima, porém, apenas os pedidos feitos em 2016 e 2017
SELECT a.name, SUM(o.total_amt_usd) AS total_spent,
	CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'top'
    	 WHEN SUM(o.total_amt_usd) BETWEEN 100000 AND 200000 THEN 'middle'
         ELSE 'low' END AS level_account
FROM accounts a
JOIN orders o
ON a.id = o.account_id
AND occurred_at > '2015-12-31'
GROUP BY 1
ORDER BY 2 DESC;

-- 05
-- identificar os 'sales_rep' com melhor performance, > 200 pedidos ou não, ordenar do maior pro menor
SELECT s.name, COUNT(*) AS num_order,
	CASE WHEN COUNT(*) > 200 THEN 'top'
    	 ELSE 'not' END AS sales_rep_performing
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC;

-- 06
-- top: > 200 'orders' ou > USD 750.000, middle: 200 >= 'orders' >= 150 ou USD 750.000 > sales > USD 500.000
SELECT s.name, COUNT(*) AS num_order, SUM(o.total_amt_usd) AS total_sales_usd,
	CASE WHEN COUNT(*) > 200 OR SUM(o.total_amt_usd) > 750000  THEN 'top'
    	 WHEN (COUNT(*) BETWEEN 150 AND 200) OR (SUM(o.total_amt_usd) BETWEEN 500000 AND 750000)  THEN 'middle'
    	 ELSE 'low' END AS sales_rep_performing
FROM sales_reps s
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 3 DESC, 2 DESC;