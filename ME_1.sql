--1
SELECT 	continent,
		COUNT(company_id) AS count_company
FROM unicorn_companies
GROUP BY continent
ORDER BY count_company DESC

--2
SELECT 	country,
		COUNT(company_id) AS count_company
FROM unicorn_companies
GROUP BY country
HAVING COUNT(company_id) > 100
ORDER BY count_company DESC

--3
SELECT	ui.industry,
		SUM(funding) AS total_funding,
		ROUND(AVG(valuation), 2) AS average_valuation
FROM unicorn_industries ui
	JOIN unicorn_funding uf ON ui.company_id = uf.company_id
GROUP BY ui.industry
ORDER BY total_funding DESC

--4
SELECT	DATE_PART('year', ud.date_joined) AS year_joined,
		COUNT(uc.company_id) AS count_company
FROM unicorn_dates ud
	JOIN unicorn_companies uc ON uc.company_id = ud.company_id
	JOIN unicorn_industries ui ON ui.company_id = ud.company_id
WHERE ui.industry LIKE ('Fintech')
GROUP BY year_joined
HAVING DATE_PART('year', ud.date_joined) > 2015 AND DATE_PART('year', ud.date_joined) < 2023
ORDER BY year_joined DESC

--5
SELECT 	uc.company,
		uc.city,
		uc.country,
		uc.continent,
		ui.industry,
		uf.valuation
FROM unicorn_companies uc
	JOIN unicorn_industries ui ON uc.company_id = ui.company_id
	JOIN unicorn_funding uf ON ui.company_id = uf.company_id
GROUP BY uc.company, uc.city, uc.country, uc.continent, ui.industry, uf.valuation
ORDER BY uf.valuation DESC

--sub 5 (J&T Express)
SELECT 	uc.company,
		uc.city,
		uc.country,
		uc.continent,
		ui.industry,
		uf.valuation
FROM unicorn_companies uc
	JOIN unicorn_industries ui ON uc.company_id = ui.company_id
	JOIN unicorn_funding uf ON ui.company_id = uf.company_id
WHERE country LIKE ('Indonesia')
GROUP BY uc.company, uc.city, uc.country, uc.continent, ui.industry, uf.valuation
ORDER BY uf.valuation DESC

--6
SELECT 	uc.company,
		(DATE_PART('year', ud.date_joined) - ud.year_founded) AS datediff
FROM unicorn_companies uc
	JOIN unicorn_dates ud ON ud.company_id = uc.company_id
GROUP BY uc.company, ud.date_joined, ud.year_founded
ORDER BY datediff DESC

--7
SELECT 	uc.company,
		(DATE_PART('year', ud.date_joined) - ud.year_founded) AS datediff,
		uc.country
FROM unicorn_companies uc
	JOIN unicorn_dates ud ON ud.company_id = uc.company_id
WHERE ud.year_founded BETWEEN 1960 AND 2000
GROUP BY uc.company, ud.date_joined, ud.year_founded, uc.country
ORDER BY datediff DESC

--8
SELECT	COUNT(DISTINCT company_id) AS count_company
FROM unicorn_funding
WHERE LOWER(select_investors) LIKE ('%venture%')

--8-2
SELECT	COUNT(DISTINCT CASE WHEN (LOWER(select_investors) LIKE '%venture%') THEN company_id END) AS count_venture,
		COUNT(DISTINCT CASE WHEN (LOWER(select_investors) LIKE '%capital%') THEN company_id END) AS count_capital,
		COUNT(DISTINCT CASE WHEN (LOWER(select_investors) LIKE '%partner%') THEN company_id END) AS count_partner
FROM unicorn_funding

--9
SELECT 	COUNT(DISTINCT CASE WHEN (continent LIKE 'Asia') THEN uc.company_id END) AS count_company_asia,
		COUNT(DISTINCT CASE WHEN (country LIKE 'Indonesia') THEN uc.company_id END) AS count_company_indonesia
FROM unicorn_companies uc
	JOIN unicorn_industries ui ON ui.company_id = uc.company_id
WHERE LOWER(ui.industry) LIKE ('%logistics%')

--10
SELECT 	uc.country,
		COUNT(DISTINCT uc.company_id) AS count_company
FROM unicorn_industries ui
	JOIN unicorn_companies uc ON ui.company_id = uc.company_id
WHERE (continent LIKE 'Asia')
GROUP BY uc.country
ORDER BY count_company DESC

SELECT 	ui.industry,
		COUNT(DISTINCT uc.company_id) AS count_company,
		uc.country
FROM unicorn_industries ui
	JOIN unicorn_companies uc ON ui.company_id = uc.company_id
WHERE (continent LIKE 'Asia') AND (country NOT IN ('China', 'India', 'Israel'))
GROUP BY ui.industry, uc.country
ORDER BY count_company DESC

--11
SELECT 	ui.industry,
		COUNT(DISTINCT uc.company_id) AS count_company
FROM unicorn_industries ui
	JOIN unicorn_companies uc ON ui.company_id = uc.company_id
WHERE country LIKE 'India'
GROUP BY ui.industry
ORDER BY count_company ASC

SELECT 	ui.industry
FROM unicorn_industries ui
	JOIN unicorn_companies uc ON ui.company_id = uc.company_id
WHERE industry NOT IN ('Travel', 'Data management & analytics', 'Mobile & telecommunications', 'Health', 'Other',
											   'Auto & transportation', 'Edtech', '"Supply chain, logistics, & delivery"', 'Fintech',
											   'E-commerce & direct-to-consumer', 'Internet software & services')
GROUP BY ui.industry

--12
SELECT 	ui.industry,
		COUNT(DISTINCT ui.company_id) AS count_company
FROM unicorn_industries ui
	JOIN unicorn_dates ud ON ud.company_id = ui.company_id
WHERE date_joined BETWEEN '2019-01-01' AND '2021-12-31'
GROUP BY ui.industry
ORDER BY count_company DESC

SELECT  ui.industry,
		EXTRACT(YEAR FROM ud.date_joined) AS year_joined,
		COUNT(DISTINCT ui.company_id) AS total_company,
		ROUND(AVG(uf.valuation)/1000000000, 2) AS avg_valuation_billion
FROM unicorn_industries ui
	JOIN unicorn_dates ud ON ud.company_id = ui.company_id
	JOIN unicorn_funding uf ON ui.company_id = uf.company_id
WHERE 	date_joined BETWEEN '2019-01-01' AND '2021-12-31' AND 
		industry IN ('Fintech', 'Internet software & services', 'E-commerce & direct-to-consumer')
GROUP BY ui.industry, year_joined
ORDER BY industry, year_joined DESC

--13
SELECT 	country,
		COUNT(company_id) AS count_company,
		(COUNT(company_id)/ SUM(COUNT(country)) OVER()) * 100 AS pct_company
FROM unicorn_companies
GROUP BY country
ORDER BY count_company DESC