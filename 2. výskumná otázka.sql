--2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

WITH TEMP_BASE_SALARY AS
(
SELECT 
	year, 
	AVG(avg_value) AS AVG_VALUE
FROM t_dana_lancaricova_project_SQL_primary_final
WHERE category = 'SALARY'
GROUP BY year
),

TEMP_BASE_PRICE AS
(
SELECT 
	year, 
	AVG_VALUE, 
	item_name
FROM t_dana_lancaricova_project_SQL_primary_final
WHERE 	category = 'ITEM' 
		AND ITEM_NAME 
		IN ('Chléb konzumní kmínový', 'Mléko polotučné pasterované')
)

SELECT 
	tbs.year, 
	tbp.ITEM_NAME, 
	round(tbs.AVG_VALUE / tbp.AVG_VALUE) AS count_item
FROM TEMP_BASE_SALARY tbs
INNER JOIN TEMP_BASE_PRICE tbp
	ON tbs.year = tbp.year

WHERE tbs.year IN 
		(SELECT max (tbp.year) 
FROM  TEMP_BASE_PRICE tbp
						 
UNION ALL 
		 
SELECT min (tbp.year) FROM  TEMP_BASE_PRICE tbp
						)
ORDER BY tbs.year, 
	 tbp.item_name;