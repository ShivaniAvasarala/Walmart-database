-- 1. Find different payment methods and no of transactions, no of quantity sold
SELECT
	PAYMENT_METHOD,
	COUNT(*) AS NO_OF_PAYMENTS,
	SUM(QUANTITY) AS TOTAL_QUANTITY
FROM
	WALMART
GROUP BY
	PAYMENT_METHOD;

-- 2. Identify the highest rated category in each branch, displaying branch, category and avg rating
SELECT
	*
FROM
	(
		SELECT
			"Branch",
			CATEGORY,
			AVG(RATING) AS AVG_RATING,
			RANK() OVER (
				PARTITION BY
					"Branch"
				ORDER BY
					AVG(RATING)
			)
		FROM
			WALMART
		GROUP BY
			"Branch",
			CATEGORY
		ORDER BY
			"Branch",
			AVG_RATING DESC
	)
WHERE
	RANK = 1;

-- 3. Identify the busiest day for each branch based on the no fo transactions
SELECT
	*
FROM
	(
		SELECT
			"Branch",
			TO_CHAR(TO_DATE(DATE, 'DD,MM,YY'), 'Day') AS DAY,
			COUNT(*),
			RANK() OVER (
				PARTITION BY
					"Branch"
				ORDER BY
					COUNT(*) DESC
			)
		FROM
			WALMART
		GROUP BY
			"Branch",
			DAY
		ORDER BY
			"Branch",
			COUNT(*) DESC
	)
WHERE
	RANK = 1;

-- 4. Calculate total quantity of items sold per payment method . List payment method and total quantity
SELECT
	PAYMENT_METHOD,
	SUM(QUANTITY) AS TOTAL_QUANTITY
FROM
	WALMART
GROUP BY
	PAYMENT_METHOD;

-- 5. Determine the average, minimum, and maximum rating of category for each city.
-- List city, category, avg_rating, min rating and max rating
SELECT
	"City",
	"category",
	AVG(RATING) AS AVG_RATING,
	MIN(RATING) AS MIN_RATING,
	MAX(RATING) AS MAX_RATING
FROM
	WALMART
GROUP BY
	"City",
	"category"
ORDER BY
	"City",
	"category";

-- 6. Calculate the total profit for each category by considering
-- total profit as (unit_price * quantity * profit margin).
-- List category and total profit, ordered from high to low
SELECT
	CATEGORY,
	SUM(UNIT_PRICE * QUANTITY * PROFIT_MARGIN) AS TOTAL_PROFIT
FROM
	WALMART
GROUP BY
	CATEGORY;

-- 7. Determine the most common payment method for each branch.
SELECT
	"Branch",
	PAYMENT_METHOD,
	COUNT_PAYMENT_METHOD
FROM
	(
		SELECT
			"Branch",
			PAYMENT_METHOD,
			COUNT(PAYMENT_METHOD) AS COUNT_PAYMENT_METHOD,
			RANK() OVER (
				PARTITION BY
					"Branch"
				ORDER BY
					COUNT(PAYMENT_METHOD) DESC
			) AS RANK
		FROM
			WALMART
		GROUP BY
			"Branch",
			PAYMENT_METHOD
	) RANKED_DATA
WHERE
	RANK = 1;

-- 8. Categorize sales into 3 groups: Morning, afternoon, evening
-- Find out each of the shift and number of invoices.
SELECT
	COUNT(*),
	CASE
		WHEN EXTRACT(
			HOUR
			FROM
				(TIME::TIME)
		) < 12 THEN 'Morning'
		WHEN EXTRACT(
			HOUR
			FROM
				(TIME::TIME)
		) BETWEEN 12 AND 17  THEN 'Afternoon'
		ELSE 'Evening'
	END SHIFT
FROM
	WALMART
GROUP BY
	SHIFT;

-- 9. Identify 5 branches with the highest decrease ratio in the
-- revenue compared to last year (2023/2022)
-- rdr = (LY_Rev - CY_Rev)/LY_Rev * 100

with last_year AS
(
select "Branch",
sum(total) as revenue_2022
from walmart
where (EXTRACT(YEAR FROM(to_date(date, 'DD,MM,YY')))) = 2022
group by "Branch"
),
current_year AS
(
select "Branch",
sum(total) as revenue_2023
from walmart
where (EXTRACT(YEAR FROM(to_date(date, 'DD,MM,YY')))) = 2023
group by "Branch"
)
select *, (revenue_2022 - revenue_2023)/revenue_2022 * 100 as RDR
from last_year
join current_year
ON last_year."Branch" = current_year."Branch"
where revenue_2022 > revenue_2023
order by rdr desc
limit 5;



-- Check types of distinct payment methods
SELECT DISTINCT
	PAYMENT_METHOD
FROM
	WALMART;

-- Number of orders grouped by payment methods
SELECT
	PAYMENT_METHOD,
	COUNT(*)
FROM
	WALMART
GROUP BY
	PAYMENT_METHOD;

-- Show all invoices for the branch "WALM003".
SELECT
	*
FROM
	WALMART
WHERE
	"Branch" = 'WALM003';

-- SELECT DISTINCT category FROM table_name;
SELECT DISTINCT
	(CATEGORY)
FROM
	WALMART;

-- Find the total number of invoices.
SELECT
	COUNT(*)
FROM
	WALMART;

-- Find all transactions that used 'Ewallet' as the payment method.
SELECT
	*
FROM
	WALMART
WHERE
	PAYMENT_METHOD = 'Ewallet';

-- Calculate the total sales (total) for each branch.
SELECT
	"Branch",
	SUM(TOTAL) AS TOTAL_SALES
FROM
	WALMART
GROUP BY
	"Branch"
ORDER BY
	"Branch";

-- Find the average rating for each category.
SELECT
	CATEGORY,
	AVG(RATING)
FROM
	WALMART
GROUP BY
	CATEGORY;

-- List all transactions where the profit_margin is above 0.4 and the rating is above 8.0.
SELECT
	*
FROM
	WALMART
WHERE
	PROFIT_MARGIN > 0.4
	AND RATING > 8.0;

-- Find the branch with the highest total sales.
SELECT
	"Branch",
	SUM(TOTAL) AS TOTAL_SALES
FROM
	WALMART
GROUP BY
	"Branch"
ORDER BY
	TOTAL_SALES DESC
LIMIT
	1;

-- Count the number of transactions for each payment method.
SELECT
	PAYMENT_METHOD,
	COUNT(*)
FROM
	WALMART
GROUP BY
	PAYMENT_METHOD;

-- Calculate the profit for each transaction and find the top 5 highest profit transactions.
SELECT
	*,
	(TOTAL * PROFIT_MARGIN) AS PROFIT
FROM
	WALMART
ORDER BY
	PROFIT DESC
LIMIT
	5;

-- Find the category with the highest average sales per transaction.
SELECT
	CATEGORY,
	AVG(TOTAL)
FROM
	WALMART
GROUP BY
	CATEGORY
ORDER BY
	AVG(TOTAL) DESC
LIMIT
	1;

-- Find the branch with the highest sales for the category "Health and beauty".
SELECT
	"Branch",
	SUM(TOTAL) AS TOTAL_SALES
FROM
	WALMART
WHERE
	CATEGORY = 'Health and beauty'
GROUP BY
	"Branch"
ORDER BY
	TOTAL_SALES DESC
LIMIT
	1;

-- Calculate the total sales for each branch and month.
SELECT
	EXTRACT(
		MONTH
		FROM
			TO_DATE(DATE, 'DD/MM/YYYY')
	) AS MONTH,
	"Branch",
	SUM(TOTAL) AS TOTAL_SALES
FROM
	WALMART
GROUP BY
	MONTH,
	"Branch"
ORDER BY
	MONTH,
	"Branch";

SELECT
	*
FROM
	WALMART
WHERE
	QUANTITY > (
		SELECT
			AVG(QUANTITY)
		FROM
			WALMART
	);

SELECT
	*
FROM
	WALMART
LIMIT
	5;

