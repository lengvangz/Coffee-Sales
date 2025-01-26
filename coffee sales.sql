-- 1. Identify peak purchasing days to plan marketing efforts:

SELECT
	TO_CHAR(date, 'day') AS day_of_week,
	COUNT(*) AS num_purchase
FROM
	coffee_sales.sales
GROUP BY
	day_of_week
ORDER BY 
	num_purchase desc
LIMIT 1


-- 2. Find the most popular coffee:

SELECT
	coffee_name,
	COUNT(*)
FROM
	coffee_sales.sales
GROUP BY 
	coffee_name
ORDER BY
	COUNT(*) DESC
LIMIT 3


-- 3. Analyze total revenue trends over time:

SELECT 
	EXTRACT(MONTH FROM date) AS num_month,
	SUM(money) AS total_sales_in_Ukrainian_hryvnias
FROM 
	coffee_sales.sales
GROUP BY 
	num_month
ORDER BY 
	num_month

-- 4. Determine cash vs. card preference by date:

SELECT
	EXTRACT(MONTH FROM date) AS num_month,
	COUNT(CASE
			WHEN cash_type = 'card' THEN 1
		  END)AS num_card,
	COUNT(CASE
			WHEN cash_type = 'cash' THEN 1
		  END) AS num_cash
FROM
	coffee_sales.sales
GROUP BY
	num_month
ORDER BY
	num_month


-- 5. Evaluate customer spending patterns by card number:

SELECT
	card,
	SUM(money) AS total_sales_in_Ukrainian_hryvnias
FROM 
	coffee_sales.sales
WHERE
	card IS NOT NULL
GROUP BY
	card
ORDER BY 
	total_sales_in_Ukrainian_hryvnias DESC
LIMIT 7

-- 6. Find days with the highest average spend per transaction:

SELECT
	date,
	AVG(money)
FROM 
	coffee_sales.sales
GROUP BY
	date
ORDER BY
	AVG(money) DESC
LIMIT 5

-- 8. Find correlations between coffee type and payment method:

SELECT
	coffee_name,
	COUNT(CASE
			WHEN cash_type = 'cash' THEN 1
		  END) AS cash_count,
	COUNT(CASE
			WHEN cash_type = 'card' THEN 1
		  END) AS card_count
FROM
	coffee_sales.sales
GROUP BY
	coffee_name
ORDER BY
	coffee_name



-- 9. Determine seasonal trends for coffee purchases:

SELECT 
	EXTRACT(QUARTER FROM date) AS num_quarter,
	coffee_name,
	COUNT(*)
FROM
	coffee_sales.sales
GROUP BY 
	num_quarter,
	coffee_name
ORDER BY 
	num_quarter,
	COUNT(*) DESC

-- 10. Forecast future revenue using historical trends:

SELECT 
	EXTRACT(WEEK FROM date) AS week,
	SUM(money) AS weekly_rev
FROM 
	coffee_sales.sales
GROUP BY 
	week
ORDER BY
	week 
	
-- 11 Identify times of day with the highest sales volume:

SELECT
	EXTRACT(HOUR FROM datetime) AS purchase_hour,
	COUNT(*) AS num_purchase
FROM
	coffee_sales.sales
GROUP BY
	purchase_hour
ORDER BY 
	purchase_hour


	
