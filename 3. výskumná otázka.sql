-- 3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 

WITH TEMP_BASE_PRICE AS
(
SELECT 
	year, 
	avg_value, 
	item_name
FROM t_dana_lancaricova_project_SQL_primary_final
WHERE 
	category = 'ITEM'
),

TEMP_FIRST_PERIOD AS
(
SELECT  
	tbp.item_name, 
	tbp.avg_value, 
	tbp.year
FROM TEMP_BASE_PRICE tbp
WHERE tbp.year 
	  IN (SELECT min (tbp.year) 
FROM  TEMP_BASE_PRICE tbp)
),

TEMP_LAST_PERIOD AS
(
SELECT  
	tbp.item_name, 
	tbp.avg_value, 
	tbp.year
FROM TEMP_BASE_PRICE tbp
WHERE tbp.year 
	  IN (SELECT MAX (aa.year) 
FROM  TEMP_BASE_PRICE aa)
)

SELECT *
FROM 
(
SELECT 
	first_year.item_name,
	((last_year.avg_value - first_year.avg_value) / first_year.avg_value) / (SELECT count(DISTINCT year) 
	FROM TEMP_BASE_PRICE) * 100 AS percentage_price_increase
FROM TEMP_FIRST_PERIOD   first_year
INNER JOIN TEMP_LAST_PERIOD  last_year
		ON first_year.item_name = last_year.item_name
ORDER BY 2 ASC 
)
LIMIT 1;
