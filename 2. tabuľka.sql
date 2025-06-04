

CREATE TABLE t_dana_lancaricova_project_SQL_secondary_final AS 
 
SELECT 
	'SALARY' AS category,
	cp.payroll_year AS year, 
	AVG(cp.value) AS VALUE
FROM czechia_payroll cp
INNER JOIN czechia_payroll_value_type cpvt 
	ON cpvt.code = cp.value_type_code
	AND cpvt.code = '5958' -- Průměrná hrubá mzda na zaměstnance
INNER JOIN czechia_payroll_industry_branch cpib 
	ON cpib.code = CP.industry_branch_code
INNER JOIN czechia_payroll_calculation cpc 
	ON cpc.code = cp.calculation_code
	AND cpc.code = '100'
WHERE value IS NOT NULL 
GROUP BY  cp.payroll_year

UNION ALL

SELECT 
	'ITEM' AS category, 
	date_part('year',date_from) AS year, 
	AVG(prc.value) AS VALUE
FROM czechia_price prc
INNER JOIN czechia_price_category cat
	ON cat.code = prc.category_code
GROUP BY  date_part('year',date_from)

UNION ALL

SELECT 
	'GDP' AS category,
	year,
	GDP AS VALUE
FROM economies
WHERE country = 'Czech Republic'
	AND GDP IS NOT NULL;


