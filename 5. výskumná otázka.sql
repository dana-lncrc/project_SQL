
--5. Má výška HDP vliv na změny ve mzdách a cenách potravin? 
--Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

WITH TEMP_TABLE AS
(
SELECT TEMP_BASE__1.YEAR, 
	TEMP_BASE__1.CATEGORY,
((TEMP_BASE__1.VALUE - TEMP_BASE__0.VALUE) / TEMP_BASE__0.VALUE)  * 100 AS percentage_increase
FROM t_dana_lancaricova_project_SQL_secondary_final          TEMP_BASE__0
INNER JOIN t_dana_lancaricova_project_SQL_secondary_final          TEMP_BASE__1
		ON TEMP_BASE__0.year + 1 = TEMP_BASE__1.YEAR
		AND TEMP_BASE__0.CATEGORY = TEMP_BASE__1.CATEGORY
)

SELECT 	TEMP_TABLE_SALARY.year, 
		TEMP_TABLE_GDP.percentage_increase AS PCT_GDP,
		TEMP_TABLE_ITEM.percentage_increase AS PCT_ITEM,
		TEMP_TABLE_SALARY.percentage_increase AS PCT_SALARY
FROM TEMP_TABLE    TEMP_TABLE_SALARY
INNER JOIN TEMP_TABLE   TEMP_TABLE_ITEM
		ON TEMP_TABLE_ITEM.YEAR = TEMP_TABLE_SALARY.YEAR
		AND TEMP_TABLE_ITEM.CATEGORY = 'ITEM'
INNER JOIN TEMP_TABLE   TEMP_TABLE_GDP
		ON TEMP_TABLE_GDP.YEAR = TEMP_TABLE_SALARY.YEAR
		AND TEMP_TABLE_GDP.CATEGORY = 'GDP'
WHERE TEMP_TABLE_SALARY.CATEGORY = 'SALARY'
ORDER BY TEMP_TABLE_SALARY.year

;


WITH TEMP_TABLE AS
(
SELECT 	TEMP_BASE__1.YEAR, 
	TEMP_BASE__1.CATEGORY,
((TEMP_BASE__1.VALUE - TEMP_BASE__0.VALUE) / TEMP_BASE__0.VALUE)  * 100 AS percentage_increase
FROM t_dana_lancaricova_project_SQL_secondary_final          TEMP_BASE__0
INNER JOIN t_dana_lancaricova_project_SQL_secondary_final    TEMP_BASE__1
	ON TEMP_BASE__0.year + 1 = TEMP_BASE__1.YEAR
	AND TEMP_BASE__0.CATEGORY = TEMP_BASE__1.CATEGORY
)

SELECT year, 
MAX(CASE WHEN CATEGORY = 'GDP' THEN percentage_increase END) AS PCT_GDP,
MAX(CASE WHEN CATEGORY = 'ITEM' THEN percentage_increase  END) AS PCT_ITEM,
MAX(CASE WHEN CATEGORY = 'SALARY' THEN percentage_increase  END) AS PCT_SALARY
FROM TEMP_TABLE
GROUP BY YEAR
ORDER BY year
;