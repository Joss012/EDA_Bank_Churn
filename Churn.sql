
-- ############ 1. SETTING UP DATA ############ --

-- Creating the Customer Table that will hold the raw data --
-- Imported Dataset (CSV) via the PgAdmin4 GUI -- 
CREATE TABLE IF NOT EXISTS Customer ( 
	RowNumber INTEGER,
	CustomerId INTEGER PRIMARY KEY,
	Surname	VARCHAR(100),
	CreditScore	INTEGER,
	"Geography"	VARCHAR(100),
	Gender	VARCHAR(100),
	Age	INTEGER,
	Tenure INTEGER,	
	Balance	REAL,
	NumOfProducts INTEGER,	
	HasCrCard INTEGER,	
	IsActiveMember INTEGER,	
	EstimatedSalary	REAL,
	Exited INTEGER,	
	Complain INTEGER,	
	"Satisfaction Score" INTEGER,	
	"Card Type"	VARCHAR(100),
	"Point Earned" INTEGER
);

-- Creating a copy of Customer table -- 
-- This is so I dont mess with the raw data while cleaning or analyzing -- 
CREATE TABLE IF NOT EXISTS Customer_Copy AS
SELECT * FROM Customer;

-- ############ 2. CLEANING DATA ############ --

-- Dropping a row that I will not be using -- 
ALTER TABLE Customer_Copy
DROP COLUMN RowNumber;

-- Checking for Duplicates --
-- There were None in the data -- 
SELECT CustomerId, Surname, COUNT(*)
FROM Customer_Copy
GROUP BY CustomerId, Surname, CreditScore, "Geography", Gender, Age, Tenure, Balance, NumOfProducts, HasCrCard, IsActiveMember, EstimatedSalary, Exited, Complain, "Satisfaction Score", "Card Type", "Point Earned"
HAVING COUNT(*) > 1;

-- Checking for Null and Empty String values --
-- There were None in the data -- 
SELECT CustomerId, Surname
FROM Customer_Copy
WHERE CustomerId IS NULL
OR Surname IS NULL OR Surname = ''
OR CreditScore IS NULL
OR "Geography" IS NULL OR "Geography" = ''
OR Gender IS NULL OR Gender = ''
OR Age IS NULL
OR Tenure IS NULL
OR Balance IS NULL
OR NumOfProducts IS NULL
OR HasCrCard IS NULL
OR IsActiveMember IS NULL
OR EstimatedSalary IS NULL
OR Exited IS NULL
OR Complain IS NULL
OR "Satisfaction Score" IS NULL
OR "Card Type" IS NULL OR "Card Type" = ''
OR "Point Earned" IS NULL;

-- ############ 3. ANALYZING THE DATA ############ --

-- Q: What is the churn rate of the bank? --
/* A: 2038/10,000 = 20.4% */
SELECT ((SELECT CAST(COUNT(*) AS REAL)
		FROM Customer_Copy
		WHERE Exited = 1) / (CAST(COUNT(*) AS REAL)) * 100) AS CHURN_RATE
FROM Customer_Copy;

-- Q: What is the churn rate of the bank for each country? --
/* A: Spain:	413/2477 = 16.7% 
	  France:	811/5014 = 16.2%
	  Germany:  814/2509 = 32.4% */
SELECT "Geography",
       (CAST(COUNT(*) FILTER (WHERE Exited = 1) AS REAL) 
	   / CAST(COUNT(*) AS REAL)) * 100 AS churn_rate
FROM Customer_Copy
GROUP BY "Geography";

-- Q: What is the average credit score of people leaving the bank? -- 
/* A: 645 */
SELECT AVG(CreditScore)
FROM Customer_Copy
WHERE Exited = 1;

-- Q: What is the average credit score of people staying at the bank? -- 
/* A: 652 */
SELECT AVG(CreditScore)
FROM Customer_Copy
WHERE Exited = 0;

-- Q: What is the average credit score of people for each conutry leaving the bank? --
/* A: Spain:	647
	  France:	642
	  Germany:  648 */
SELECT "Geography", AVG(CreditScore) as Average_Credit_Score
FROM Customer_Copy
WHERE Exited = 1
GROUP BY "Geography";

-- Q: What is the average credit score of people for each conutry staying at the bank? --
/* A: Spain:	652
	  France:	651
	  Germany:  653 */
SELECT "Geography", AVG(CreditScore) as Average_Credit_Score
FROM Customer_Copy
WHERE Exited = 0
GROUP BY "Geography";

-- Q: What is the churn rate between Male and Females? -- 
/* A: Male:		899/5457 =  16.5%
	  Female:	1139/4543 = 25.1% */
SELECT Gender,
       (CAST(COUNT(*) FILTER (WHERE Exited = 1) AS REAL) 
	   / CAST(COUNT(*) AS REAL)) * 100 AS churn_rate
FROM Customer_Copy
GROUP BY Gender;

-- Q: What is the churn rate between different age groups? -- 
/* A: Under 20: 	3/49 = 6.1%
	  20-29: 		121/1592 = 7.6%
	  30-39: 		473/4346 = 10.9%
	  40-49: 		807/2618 = 30.8%
	  50-59: 		487/869 = 56.0%
	  60 and above: 147/526 = 27.9% */
WITH customer_age_groups AS (
    SELECT CASE 
               WHEN Age < 20 THEN 'Under 20'
               WHEN Age BETWEEN 20 AND 29 THEN '20-29'
               WHEN Age BETWEEN 30 AND 39 THEN '30-39'
               WHEN Age BETWEEN 40 AND 49 THEN '40-49'
               WHEN Age BETWEEN 50 AND 59 THEN '50-59'
               ELSE '60 and above'
           END AS age_group,
           COUNT(*) AS total_customers,
           COUNT(*) FILTER (WHERE Exited = 1) AS exited_customers
    FROM Customer_Copy
    GROUP BY age_group
)
SELECT age_group,
	   exited_customers,
       total_customers,
       (CAST(exited_customers AS REAL) / CAST(total_customers AS REAL)) * 100 AS churn_rate
FROM customer_age_groups
ORDER BY churn_rate DESC;	

-- Q: What is the churn rate between different tenures? -- 
/* A: 0: 95/413	  = 23.0%	6:  196/967  = 20.3%
	  1: 232/1035 = 22.4%	7:  177/1028 = 17.2%
	  2: 201/1048 = 19.2%	8:  197/1025 = 19.2%
	  3: 213/1009 = 21.1%	9:  214/984  = 21.8%
	  4: 203/989  = 20.5%	10: 101/490  = 20.6%
	  5: 209/1012 = 20.7%	*/
SELECT Tenure,
       (CAST(COUNT(*) FILTER (WHERE Exited = 1) AS REAL) 
	   / CAST(COUNT(*) AS REAL)) * 100 AS churn_rate
FROM Customer_Copy
GROUP BY Tenure;

-- Q: What is the churn rate between different balance groups? -- 
/* A: 0-24,999: 		504/3623	= 13.9%		125,000-149,999: 	429/1762 = 24.3%
	  25,000-49,999: 	22/69		= 31.9%		150,000-174,999: 	156/738  = 21.1%
	  50,000-74,999: 	75/349		= 21.5%		175,000-199,999: 	49/197   = 24.9%
	  75,000-99,999: 	226/1160	= 19.5%		200,000-224,999:	17/32    = 53.1%
	  100,000-124,999:  558/2068	= 26.9%		225,000 and above:	2/2 	 = 100.0% */
WITH customer_balance_groups AS (
    SELECT CASE 
            	WHEN Balance BETWEEN 0 AND 24999 THEN '0-24999'
				WHEN Balance BETWEEN 25000 AND 49999 THEN '25000-49999'
				WHEN Balance BETWEEN 50000 AND 74999 THEN '50000-74999'
				WHEN Balance BETWEEN 75000 AND 99999 THEN '75000-99999'
				WHEN Balance BETWEEN 100000 AND 124999 THEN '100000-124999'
				WHEN Balance BETWEEN 125000 AND 149999 THEN '125000-149999'
				WHEN Balance BETWEEN 150000 AND 174999 THEN '150000-174999'
				WHEN Balance BETWEEN 175000 AND 199999 THEN '175000-199999'
				WHEN Balance BETWEEN 200000 AND 224999 THEN '200000-224999'
				WHEN Balance >= 225000 THEN '225000 and above'
           END AS balance_group,
           COUNT(*) AS total_customers,
           COUNT(*) FILTER (WHERE Exited = 1) AS exited_customers
    FROM Customer_Copy
    GROUP BY balance_group
)
SELECT balance_group,
       exited_customers,
       total_customers,
       (CAST(exited_customers AS REAL) / CAST(total_customers AS REAL)) * 100 AS churn_rate
FROM customer_balance_groups
ORDER BY churn_rate DESC;

-- Q: What is the churn rate between customers who have a different number of products? -- 
/* A: 1: 1409/5084 = 27.7%
	  2: 349/4590  = 7.6%
	  3: 220/266   = 82.7%
	  4: 60/60 	   = 100.0% */
SELECT NumOfProducts,
       COUNT(*) FILTER (WHERE Exited = 1) AS exited_customers,
       COUNT(*) AS total_customers,
       (CAST(COUNT(*) FILTER (WHERE Exited = 1) AS REAL) / CAST(COUNT(*) AS REAL)) * 100 AS churn_rate
FROM Customer_Copy
GROUP BY NumOfProducts
ORDER BY churn_rate DESC;

-- Q: What is the churn rate between customers who do and don't have a credit card? -- 
/* A: DO: 	 1425/7055 = 20.2%
	  DON'T: 613/2945  = 20.9% */
SELECT HasCrCard,
       COUNT(*) FILTER (WHERE Exited = 1) AS exited_customers,
       COUNT(*) AS total_customers,
       (CAST(COUNT(*) FILTER (WHERE Exited = 1) AS REAL) / CAST(COUNT(*) AS REAL)) * 100 AS churn_rate
FROM Customer_Copy
GROUP BY HasCrCard
ORDER BY churn_rate DESC;

-- Q: What is the churn rate between customers who are active and not? -- 
/* A: ACTIVE: 	  735/5151 	 = 14.3%
	  NOT ACTIVE: 1303/4849  = 26.9% */
SELECT IsActiveMember,
       COUNT(*) FILTER (WHERE Exited = 1) AS exited_customers,
       COUNT(*) AS total_customers,
       (CAST(COUNT(*) FILTER (WHERE Exited = 1) AS REAL) / CAST(COUNT(*) AS REAL)) * 100 AS churn_rate
FROM Customer_Copy
GROUP BY IsActiveMember
ORDER BY churn_rate DESC;

-- Q: What is the churn rate between different Salary groups? -- 
/* A: 0-25,000: 		242/1217 = 19.9%		100,001-125,000: 256/1276 = 20.1%
	  25,001-50,000: 	247/1236 = 19.9%		125,001-150,000: 261/1279 = 20.4%
	  50,001-75,000: 	266/1269 = 20.9%		150,001-175,000: 254/1195 = 21.3%
	  75,001-100,000: 	238/1268 = 18.8%		175,001-200,000: 274/1260 = 21.7% */
WITH customer_salary_groups AS (
    SELECT CASE 
            	WHEN EstimatedSalary BETWEEN 0 AND 25000 THEN '0-25000'
				WHEN EstimatedSalary BETWEEN 25001 AND 50000 THEN '25001-50000'
				WHEN EstimatedSalary BETWEEN 50001 AND 75000 THEN '50001-75000'
				WHEN EstimatedSalary BETWEEN 75001 AND 100000 THEN '75001-100000'
				WHEN EstimatedSalary BETWEEN 100001 AND 125000 THEN '100001-125000'
				WHEN EstimatedSalary BETWEEN 125001 AND 150000 THEN '125001-150000'
				WHEN EstimatedSalary BETWEEN 150001 AND 175000 THEN '150001-175000'
				WHEN EstimatedSalary BETWEEN 175001 AND 200000 THEN '175001-200000'
           END AS salary_group,
           COUNT(*) AS total_customers,
           COUNT(*) FILTER (WHERE Exited = 1) AS exited_customers
    FROM Customer_Copy
    GROUP BY salary_group
)
SELECT salary_group,
       exited_customers,
       total_customers,
       (CAST(exited_customers AS REAL) / CAST(total_customers AS REAL)) * 100 AS churn_rate
FROM customer_salary_groups
ORDER BY churn_rate DESC;

-- Q: What is the churn rate between customers who have and have not filed a complaint? -- 
/* A: HAVE: 	2034/2044 = 99.5%
	  HAVE NOT: 4/7956    = 0.05% */
SELECT Complain,
       COUNT(*) FILTER (WHERE Exited = 1) AS exited_customers,
       COUNT(*) AS total_customers,
       (CAST(COUNT(*) FILTER (WHERE Exited = 1) AS REAL) / CAST(COUNT(*) AS REAL)) * 100 AS churn_rate
FROM Customer_Copy
GROUP BY Complain
ORDER BY churn_rate DESC;

-- Q: What is the churn rate between customers who have a different satisfaction scores? -- 
/* A: 1: 387/1932 = 20.03%
	  2: 439/2014 = 21.8%
	  3: 401/2042 = 19.6%
	  4: 414/2008 = 20.6%
	  5: 397/2004 = 19.8% */
SELECT "Satisfaction Score",
       COUNT(*) FILTER (WHERE Exited = 1) AS exited_customers,
       COUNT(*) AS total_customers,
       (CAST(COUNT(*) FILTER (WHERE Exited = 1) AS REAL) / CAST(COUNT(*) AS REAL)) * 100 AS churn_rate
FROM Customer_Copy
GROUP BY "Satisfaction Score"
ORDER BY churn_rate DESC;

-- Q: What is the churn rate between customers who have a different card types? -- 
/* A: Diamond:  546/2507 = 21.8%
	  Platinum: 508/2495 = 20.4%
	  Gold: 	482/2502 = 19.3%
	  Silver: 	502/2496 = 20.1% */
SELECT "Card Type",
       COUNT(*) FILTER (WHERE Exited = 1) AS exited_customers,
       COUNT(*) AS total_customers,
       (CAST(COUNT(*) FILTER (WHERE Exited = 1) AS REAL) / CAST(COUNT(*) AS REAL)) * 100 AS churn_rate
FROM Customer_Copy
GROUP BY "Card Type"
ORDER BY churn_rate DESC;

-- Q: What is the churn rate between customers who have different amounts of points earned? -- 
/* A: 100-200: 	1/2		 = 50.0%	601-700: 	265/1274 = 20.9%
	  201-300: 	235/1088 = 21.6%	701-800: 	280/1279 = 21.9%
	  301-400: 	260/1267 = 20.5%	801-900: 	254/1243 = 20.4%
	  401-500: 	235/1239 = 18.9%	901-1000:	241/1258 = 19.2%
	  501-600:  267/1350 = 19.8%	*/
WITH customer_points_groups AS (
    SELECT CASE 
            	WHEN "Point Earned" BETWEEN 100 AND 200 THEN '100-200'
				WHEN "Point Earned" BETWEEN 201 AND 300 THEN '201-300'
				WHEN "Point Earned" BETWEEN 301 AND 400 THEN '301-400'
				WHEN "Point Earned" BETWEEN 401 AND 500 THEN '401-500'
				WHEN "Point Earned" BETWEEN 501 AND 600 THEN '501-600'
				WHEN "Point Earned" BETWEEN 601 AND 700 THEN '601-700'
				WHEN "Point Earned" BETWEEN 701 AND 800 THEN '701-800'
				WHEN "Point Earned" BETWEEN 801 AND 900 THEN '801-900'
				WHEN "Point Earned" BETWEEN 901 AND 1000 THEN '901-1000'
           END AS points_group,
           COUNT(*) AS total_customers,
           COUNT(*) FILTER (WHERE Exited = 1) AS exited_customers
    FROM Customer_Copy
    GROUP BY points_group
)
SELECT points_group,
       exited_customers,
       total_customers,
       (CAST(exited_customers AS REAL) / CAST(total_customers AS REAL)) * 100 AS churn_rate
FROM customer_points_groups
ORDER BY churn_rate DESC;







