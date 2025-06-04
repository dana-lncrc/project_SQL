CREATE TABLE t_dana_lancaricova_project_SQL_primary_final AS 

SELECT 
	'SALARY' AS category,
	cp.payroll_year AS year, 
	AVG(cp.value) AS avg_value, 
	cpib.NAME AS industry_name, 
	NULL AS item_name
FROM czechia_payroll cp
INNER JOIN czechia_payroll_value_type cpvt 
	ON cpvt.code = cp.value_type_code
	AND cpvt.code = '5958' -- Průměrná hrubá mzda na zaměstnance
INNER JOIN czechia_payroll_industry_branch cpib 
	ON cpib.code = cp.industry_branch_code
INNER JOIN czechia_payroll_calculation cpc 
	ON cpc.code = cp.calculation_code
	AND cpc.code = '100' 
WHERE value IS NOT NULL 
GROUP BY  cp.payroll_year, cpib.name

UNION ALL

SELECT 
	'ITEM' AS category, 
	date_part('year',date_from) AS year, 
	AVG(prc.value) AS avg_value, 
	NULL AS industry_name,
	cat.NAME AS item_name
FROM czechia_price prc
INNER JOIN czechia_price_category cat
	ON cat.code = prc.category_code
GROUP BY  date_part('year',date_from), 
          cat.name;
