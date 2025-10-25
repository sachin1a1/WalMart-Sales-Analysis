/********************************************************************
 * Project: Walmart Sales Analysis
 * Database: MySQL
 * Author : [Sachin]
 * Purpose: Analytical queries on Walmart sales data for reporting
 ********************************************************************/


CREATE TABLE walmart (
    invoice_id      VARCHAR(20) PRIMARY KEY,
    branch          VARCHAR(10),
    city            VARCHAR(50),
    category        VARCHAR(50),
    unit_price      DECIMAL(10,2),
    quantity        INT,
    date            DATE,
    time            TIME,
    payment_method  VARCHAR(30),
    rating          DECIMAL(3,1),
    profit_margin   DECIMAL(5,2),
    total           DECIMAL(10,2)
);


-- ================================================================
-- Q0: Table Overview
-- Description: Fetch all data from the walmart table for review
-- Output: Complete walmart table
-- ================================================================
SELECT * 
FROM walmart;


-- ================================================================
-- Q1: Count total records in the table
-- Description: Returns total number of rows (transactions) in walmart
-- Output: Single integer value representing total records
-- ================================================================
SELECT COUNT(*) 
FROM walmart;


-- ================================================================
-- Q2: Count number of transactions by each payment method
-- Description: Group transactions by payment method
-- Output: payment_method, no_payments
-- ================================================================
SELECT 
    payment_method,
    COUNT(*) AS no_payments
FROM walmart
GROUP BY payment_method;


-- ================================================================
-- Q3: Count distinct branches
-- Description: Identify how many unique branches exist in the data
-- Output: Single integer value representing distinct branches
-- ================================================================
SELECT COUNT(DISTINCT branch) 
FROM walmart;


-- ================================================================
-- Q4: Find minimum quantity sold
-- Description: Determine the smallest quantity sold in any transaction
-- Output: Single integer value representing minimum quantity
-- ================================================================
SELECT MIN(quantity) 
FROM walmart;


-- ================================================================
-- Q5: Payment methods and total quantity sold
-- Description: Find different payment methods, number of transactions,
--              and total quantity sold by each method
-- Output: payment_method, no_payments, no_qty_sold
-- ================================================================
SELECT 
    payment_method,
    COUNT(*) AS no_payments,
    SUM(quantity) AS no_qty_sold
FROM walmart
GROUP BY payment_method;


-- ================================================================
-- Q6: Highest-rated category per branch
-- Description: Identify the category with highest average rating in each branch
-- Output: branch, category, avg_rating
-- ================================================================
SELECT branch, category, avg_rating
FROM (
    SELECT 
        branch,
        category,
        AVG(rating) AS avg_rating,
        RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) AS rank_num
    FROM walmart
    GROUP BY branch, category
) AS ranked
WHERE rank_num = 1;


-- ================================================================
-- Q7: Busiest day per branch
-- Description: Identify the day of the week with the most transactions for each branch
-- Output: branch, day_name, no_transactions
-- ================================================================
SELECT branch, day_name, no_transactions
FROM (
    SELECT 
        branch,
        DAYNAME(STR_TO_DATE(date, '%Y-%m-%d')) AS day_name,
        COUNT(*) AS no_transactions,
        RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rank_num
    FROM walmart
    GROUP BY branch, day_name
) AS ranked
WHERE rank_num = 1;


-- ================================================================
-- Q8: Total quantity sold per payment method
-- Description: Aggregate quantity sold by each payment method
-- Output: payment_method, no_qty_sold
-- ================================================================
SELECT 
    payment_method,
    SUM(quantity) AS no_qty_sold
FROM walmart
GROUP BY payment_method;


-- ================================================================
-- Q9: Ratings summary per city and category
-- Description: Calculate min, max, and average ratings of categories for each city
-- Output: city, category, min_rating, max_rating, avg_rating
-- ================================================================
SELECT 
    city,
    category,
    MIN(rating) AS min_rating,
    MAX(rating) AS max_rating,
    AVG(rating) AS avg_rating
FROM walmart
GROUP BY city, category;


-- ================================================================
-- Q10: Total profit per category
-- Description: Calculate total profit = unit_price * quantity * profit_margin
-- Output: category, total_profit (sorted descending)
-- ================================================================
SELECT 
    category,
    SUM(unit_price * quantity * profit_margin) AS total_profit
FROM walmart
GROUP BY category
ORDER BY total_profit DESC;


-- ================================================================
-- Q11: Preferred payment method per branch
-- Description: Identify the most common payment method used in each branch
-- Output: branch, preferred_payment_method
-- ================================================================
WITH cte AS (
    SELECT 
        branch,
        payment_method,
        COUNT(*) AS total_trans,
        RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rank_num
    FROM walmart
    GROUP BY branch, payment_method
)
SELECT branch, payment_method AS preferred_payment_method
FROM cte
WHERE rank_num = 1;


-- ================================================================
-- Q12: Sales shift categorization
-- Description: Classify sales into Morning (<12), Afternoon (12-17), Evening (>17)
-- Output: branch, shift, num_invoices
-- ================================================================
SELECT
    branch,
    CASE 
        WHEN HOUR(TIME(time)) < 12 THEN 'Morning'
        WHEN HOUR(TIME(time)) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS num_invoices
FROM walmart
GROUP BY branch, shift
ORDER BY branch, num_invoices DESC;


-- ================================================================
-- Q13: Top 5 branches with highest revenue decrease ratio
-- Description: Compare revenue from last year to current year and find branches with largest decrease
-- Output: branch, last_year_revenue, current_year_revenue, revenue_decrease_ratio
-- ================================================================
WITH revenue_2022 AS (
    SELECT 
        branch,
        SUM(total) AS revenue
    FROM walmart
    WHERE YEAR(STR_TO_DATE(date, '%Y-%m-%d')) = 2022
    GROUP BY branch
),
revenue_2023 AS (
    SELECT 
        branch,
        SUM(total) AS revenue
    FROM walmart
    WHERE YEAR(STR_TO_DATE(date, '%Y-%m-%d')) = 2023
    GROUP BY branch
)
SELECT 
    r2022.branch,
    r2022.revenue AS last_year_revenue,
    r2023.revenue AS current_year_revenue,
    ROUND(((r2022.revenue - r2023.revenue) / r2022.revenue) * 100, 2) AS revenue_decrease_ratio
FROM revenue_2022 AS r2022
JOIN revenue_2023 AS r2023 ON r2022.branch = r2023.branch
WHERE r2022.revenue > r2023.revenue
ORDER BY revenue_decrease_ratio DESC
LIMIT 5;


-- ================================================================
-- Q14: Top 3 Products by Total Transaction Amount per Category
-- Description: Identify top-selling products by total sales amount within each category
-- Output: category, product_name, total_amount
-- ================================================================
SELECT category, invoice_id, total_amount
FROM (
    SELECT category,
           invoice_id,
           SUM(total) AS total_amount,
           ROW_NUMBER() OVER(PARTITION BY category ORDER BY SUM(total) DESC) AS rn
    FROM walmart
    GROUP BY category, invoice_id
) AS ranked
WHERE rn <= 3;


-- ================================================================
-- Q15: Month with Highest Revenue per Branch
-- Description: Find the month generating the highest revenue for each branch
-- Output: branch, month_name, monthly_revenue
-- ================================================================
SELECT branch, month_name, monthly_revenue
FROM (
    SELECT branch,
           MONTHNAME(STR_TO_DATE(date, '%Y-%m-%d')) AS month_name,
           SUM(total) AS monthly_revenue,
           DENSE_RANK() OVER(PARTITION BY branch ORDER BY SUM(total) DESC) AS rnk
    FROM walmart
    GROUP BY branch, month_name
    order by monthly_revenue desc
) AS ranked
WHERE rnk = 1;


-- ================================================================
-- Q16: Transaction Size Classification per Branch
-- Description: Categorize transactions as 'Small', 'Medium', or 'Large' based on quantity
-- Output: branch, transaction_size, num_transactions
-- ================================================================
SELECT branch,
       IF(quantity >= 5, 'Small', IF(quantity <= 15, 'Medium', 'Large')) AS transaction_size,
       COUNT(*) AS num_transactions
FROM walmart
GROUP BY branch, transaction_size;


-- ================================================================
-- Q17: Estimated Profit per Invoice Handling NULL Profit Margin
-- Description: Calculate estimated profit, treating NULL profit_margin as 0
-- Output: invoice_id, estimated_profit
-- ================================================================
SELECT invoice_id,
       SUM(unit_price * quantity * COALESCE(profit_margin, 0)) AS estimated_profit
FROM walmart
GROUP BY invoice_id
ORDER BY estimated_profit DESC;


-- ================================================================
-- Q18: Branch-Category Combined Identifier with Total Revenue
-- Description: Create unique branch-category identifier and calculate total revenue
-- Output: branch_category, total_revenue
-- ================================================================
SELECT CONCAT(branch, ' - ', category) AS branch_category,
       SUM(total) AS total_revenue
FROM walmart
GROUP BY branch_category
ORDER BY total_revenue DESC;


-- ================================================================
-- Q19: Floor and Ceiling of Unit Price per Category
-- Description: Determine minimum and maximum unit prices rounded down/up per category
-- Output: category, min_floor_price, max_ceil_price
-- ================================================================
SELECT category,
       FLOOR(MIN(unit_price)) AS min_floor_price,
       CEIL(MAX(unit_price)) AS max_ceil_price
FROM walmart
GROUP BY category;


-- ================================================================
-- Q20: Preferred Payment Method per Branch Using View and Stored Procedure
-- Description: Identify the most used payment method per branch and make it reusable
-- Output (View): branch, preferred_payment_method
-- Input (Procedure): branch_name
-- Output (Procedure): branch, preferred_payment_method
-- ================================================================

-- Step 1: Create a View for preferred payment method
CREATE OR REPLACE VIEW preferred_payment_per_branch AS
WITH payment_rank AS (
    SELECT branch, payment_method,
           COUNT(*) AS num_transactions,
           RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rnk
    FROM walmart
    GROUP BY branch, payment_method
)
SELECT branch, payment_method AS preferred_payment_method
FROM payment_rank
WHERE rnk = 1;

-- Step 2: Stored Procedure to get preferred payment method for a specific branch
DELIMITER //
CREATE PROCEDURE GetPreferredPayment(IN branch_name VARCHAR(50))
BEGIN
    SELECT branch, preferred_payment_method
    FROM preferred_payment_per_branch
    WHERE branch = branch_name;
END //
DELIMITER ;

-- Example Call:
-- CALL GetPreferredPayment('WALM049');
