-- ============================================
-- DATA CLEANING: Fix invalid TotalCharges values
-- ============================================
-- Some records contain empty strings ('') in TotalCharges,
-- which prevents numeric aggregation and calculations.
-- These are converted to NULL so they can be safely cast.

UPDATE Telco_Customer_Churn
SET TotalCharges = NULL
WHERE TotalCharges = '';

-- ============================================
-- DATA TYPE STANDARDISATION
-- ============================================
-- Convert TotalCharges to a numeric data type
-- to enable aggregations, churn revenue analysis,
-- and Power BI visualisations.

ALTER TABLE Telco_Customer_Churn
ALTER COLUMN TotalCharges DECIMAL(10,2);


-- ============================================
-- FEATURE ENGINEERING: Create churn_flag
-- ============================================
-- The raw Churn field is stored as a boolean value.
-- For analytical consistency and easier aggregation,
-- this query converts the boolean churn indicator into
-- a numeric flag:
--   1 = Customer churned
--   0 = Customer retained
--
-- This standardised churn_flag enables:
-- - Churn rate calculations using SUM / AVG
-- - Consistent use in SQL views and Power BI measures
-- - Clear interpretation in downstream analysis

SELECT 
    *,
    CASE 
        WHEN Churn = FALSE THEN 0 
        ELSE 1 
    END AS churn_flag
FROM Telco_Customer_Churn;


-- ============================================
-- FEATURE ENGINEERING: Create tenure_group
-- ============================================
-- Raw tenure values (in months) are continuous and
-- not easily interpretable for business analysis.
-- This query groups customers into clear lifecycle
-- stages based on length of service:
--
-- 0–12 months   → New customers
-- 13–24 months  → Early-tenure customers
-- 25–48 months → Mid-tenure customers
-- 49+ months   → Long-term customers
--
-- The tenure_group field is used to:
-- - Analyse churn by customer lifecycle stage
-- - Identify early churn risk
-- - Support Power BI segmentation and filtering

SELECT
    *,
    CASE 
        WHEN tenure <= 12 THEN '0–12 months'
        WHEN tenure BETWEEN 13 AND 24 THEN '13–24 months'
        WHEN tenure BETWEEN 25 AND 48 THEN '25–48 months'
        ELSE '49+ months'
    END AS tenure_group
FROM Telco_Customer_Churn`;

-- ============================================
-- ANALYTICS VIEW: churn_view
-- ============================================
-- This view represents the final, analysis-ready
-- dataset used for churn reporting and dashboarding.
--
-- Purpose:
-- - Provide a single source of truth for churn analysis
-- - Abstract raw tables away from BI tools
-- - Standardise business logic across reports
--
-- Key transformations applied:
-- 1. Tenure is bucketed into lifecycle stages (tenure_group)
-- 2. Churn status is converted into a numeric flag (churn_flag)
--
-- This design enables:
-- - Consistent churn rate calculations
-- - Clear lifecycle-based analysis
-- - Reliable consumption by Power BI dashboards

CREATE OR REPLACE VIEW churn_view AS
SELECT
    customerID,
    gender,
    SeniorCitizen,
    Partner,
    Dependents,
    tenure,
    CASE 
        WHEN tenure < 6 THEN '0–5 months'
        WHEN tenure BETWEEN 6 AND 12 THEN '6–12 months'
        WHEN tenure BETWEEN 13 AND 24 THEN '13–24 months'
        ELSE '25+ months'
    END AS tenure_group,

    Contract,
    InternetService,
    PaymentMethod,
    MonthlyCharges,
    TotalCharges,
    CASE 
        WHEN Churn = 'Yes' THEN 1 
        ELSE 0 
    END AS churn_flag

FROM Telco_Customer_Churn;


    -- ============================================
-- OVERALL CHURN RATE
-- ============================================
-- Calculates:
-- 1. Total customer base
-- 2. Number of churned customers
-- 3. Percentage churn rate

SELECT 
    COUNT(*) AS total_customers,
    SUM(churn_flag) AS churned_customers,
    ROUND(100.0 * SUM(churn_flag) / COUNT(*), 2) AS churn_rate
FROM Telco_Customer_Churn;

-- ============================================
-- CHURN BY CONTRACT TYPE - USING THE VIEW TABLE
-- ============================================
-- Highlights how churn varies across contract models
-- (e.g. Month-to-month vs long-term contracts),
-- a key driver of customer retention strategy.

SELECT 
    Contract,
    COUNT(*) AS customers,
    SUM(churn_flag) AS churned,
    ROUND(100.0 * SUM(churn_flag) / COUNT(*), 2) AS churn_rate
FROM churn_view
GROUP BY Contract
ORDER BY churn_rate DESC;

-- ============================================
-- CHURN BY TENURE GROUP - USING THE VIEW TABLE
-- ============================================
-- Reveals churn concentration by customer lifecycle stage,
-- enabling targeted onboarding and early-retention initiatives.

SELECT 
    tenure_group,
    COUNT(*) AS customers,
    SUM(churn_flag) AS churned,
    ROUND(100.0 * SUM(churn_flag) / COUNT(*), 2) AS churn_rate
FROM churn_view
GROUP BY tenure_group
ORDER BY churn_rate DESC;


-- ============================================
-- HIGH-RISK CUSTOMER SEGMENT - USING THE VIEW TABLE
-- ============================================
-- Defines high-risk churn customers as:
-- - Month-to-month contracts
-- - High monthly charges
-- - Early tenure (less than 12 months)
-- - Already churned
--
-- This segment represents priority targets for retention actions.

SELECT 
    COUNT(*) AS high_risk_customers
FROM churn_view
WHERE 
    Contract = 'Month-to-month'
    AND MonthlyCharges > 70
    AND tenure < 12
    AND churn_flag = 1;
