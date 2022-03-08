-- FULL OUTER JOIN
-- FULL OUTER JOIN Table_B ON Table_A.column_name = Table_B.column_name;

-- quando se quer apenas os que não atendem a condição do ON:
-- WHERE Table_A.column_name IS NULL OR Table_B.column_name IS NULL

-- 01 QUIZ

-- 01
-- cada 'account' que tem um 'sales_rep' e vice-versa
SELECT a.name AS account, s.name AS sales_reps
FROM accounts a 
FULL JOIN sales_reps s 
ON s.id = a.sales_rep_id    -- todas as contas tem representante

-- 02
-- cada 'account' que NÃO tem um 'sales_rep' e vice-versa
SELECT a.name AS account, s.name AS sales_reps
FROM accounts a 
FULL JOIN sales_reps s 
ON s.id = a.sales_rep_id
WHERE (s.id IS NULL OR a.sales_rep_id IS NULL)  -- vazio


-- 02 QUIZ


-- 01
-- QUERY com LEFT JOIN das 'accounts' com a tabela 'sales_reps', junte isso usando 'accounts.primary_poc < sales_reps.name'
SELECT a.name AS account, a.primary_poc, s.name AS sales_reps 
FROM accounts a 
LEFT JOIN sales_reps s 
ON s.id = a.sales_rep_id
AND a.primary_poc < s.name  -- apenas as contas com o 'primary_poc' alfabeticamente antes do s.name

-----------------------------------------------------------------------------------------------------------
-- SELF JOIN: join com a própria tabela, útil quando querermos comparar informações da mesma tabela em 
-- datas diferentes.

-- 03  QUIZ

-- 01
-- modificar a QUERY do video para 'web_events' ocorridos no máximo 1 dia após do outro
SELECT w1.id AS w1_id,
       w1.account_id AS w1_account_id,
       w1.occurred_at AS w1_occurred_at,
       w1.channel AS w1_channel,
       w2.id AS w2_id,
       w2.account_id AS w2_account_id,
       w2.occurred_at AS w2_occurred_at,
       w2.channel AS w2_channel
  FROM web_events w1
 LEFT JOIN web_events w2
   ON w1.account_id = w2.account_id
  AND w2.occurred_at > w1.occurred_at
  AND w2.occurred_at <= w1.occurred_at + INTERVAL '1 days'
ORDER BY w1.account_id, w1.occurred_at 

--------------------------------------------------------------------------------------
-- UNION - junta dois ou mais QUERIES, tem que ter mesma quantidade de colunas e os
-- tipos de dados devem ser iguais para colunas correspondentes
-- as linhas duplicadas da tabela anexada serão excluídas, a não ser que use-se UNION ALL

/* EXEMPLO
SELECT *
FROM table_1

UNION

-- SELECT *
FROM table_2
*/

-- 04 QUIZ

-- 01 
--escreva uma QUERY usando UNION ALL na tabela accounts
SELECT *
FROM accounts

UNION ALL

SELECT *
FROM accounts
-- caso tivéssemos usado apenas UNION, retornaria metade dos resultados, pois UNION exclui as linhas duplicadas

-- 02
-- reescrever a QUERY acima adicionando WHERE name = 'Walmart' na tabela 1 e WHERE name = 'Disney' na tabela 2
SELECT *
FROM accounts
WHERE name = 'Walmart'

UNION ALL

SELECT *
FROM accounts
WHERE name = 'Disney'

-- 03
-- transforme a 1ª QUERY numa tabela e conte quantas vezes cada nome aparece nesta tabela
WITH double_accounts AS (
    SELECT *
FROM accounts

UNION ALL

SELECT *
FROM accounts
)

SELECT DISTINCT name, COUNT(*)
FROM double_accounts
GROUP BY 1      -- resultado = 2, 1 nome para cada tabela

-----------------------------------------------------------------------------
-- PERFORMANCE TUNING
-- Limitar o conjunto de dados buscado, com LIMIT, <, >, etc.
-- quando usamos AGGREGATE FUNCTIONS, usar LIMIT não melhora a performance da query, pois a agregação é feita antes
-- nesse caso, devemos usar uma SUBQUERY com LIMIT e só depois realizar a agregação

-- também podemos reduzir os dados usados no JOIN, realizamos um SUBQUERY antes de unir tabelas

-- usando a função EXPLAIN antes da QUERY, retornará um passo a passo sequencial da busca e também um valor estimado de tempo

