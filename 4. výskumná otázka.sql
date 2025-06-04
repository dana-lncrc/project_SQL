--4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

WITH TEMP_BASE AS
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
SELECT year, 
	AVG(avg_value) as AVG_VALUE
FROM t_dana_lancaricova_project_SQL_primary_final
WHERE category = 'ITEM'
GROUP BY year
),

TEMP_PRICE_PCT AS
(
SELECT 
	TEMP_BASE_PRICE__1.YEAR, 
	((TEMP_BASE_PRICE__1.AVG_VALUE - TEMP_BASE_PRICE__0.AVG_VALUE) / TEMP_BASE_PRICE__0.AVG_VALUE)  * 100 AS percentage_price_increase
FROM 
	TEMP_BASE_PRICE          
	TEMP_BASE_PRICE__0
INNER JOIN TEMP_BASE_PRICE          
		   TEMP_BASE_PRICE__1
	ON TEMP_BASE_PRICE__0.year + 1 = TEMP_BASE_PRICE__1.year
),

TEMP_SALARY_PCT AS
(
SELECT 
	TEMP_BASE__1.year AS YEAR, 
	((TEMP_BASE__1.AVG_VALUE - TEMP_BASE__0.AVG_VALUE) / TEMP_BASE__0.AVG_VALUE) * 100 AS percentage_SALARY_increase
FROM TEMP_BASE          
	 TEMP_BASE__0
INNER JOIN TEMP_BASE          
		   TEMP_BASE__1
	ON TEMP_BASE__0.year + 1 = TEMP_BASE__1.year
)

SELECT aa.*, 
	CASE WHEN percentage_price_increase > percentage_SALARY_increase + 10
		THEN 'ano rastli viac ako o 10% oproti mzdam'
		ELSE 'nie - ceny potravin nerastli viac ako o 10% oproti mzdam'
		END result
FROM 
(
SELECT 
	TEMP_PRICE_PCT.year,
	TEMP_PRICE_PCT.percentage_price_increase, TEMP_SALARY_PCT.percentage_SALARY_increase 
FROM TEMP_PRICE_PCT   
INNER JOIN TEMP_SALARY_PCT    TEMP_SALARY_PCT
	ON TEMP_PRICE_PCT.year = TEMP_SALARY_PCT.year
) aa
ORDER BY 1 DESC;
