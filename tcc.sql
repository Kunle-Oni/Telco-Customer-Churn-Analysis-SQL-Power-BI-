UPDATE telco_customers
SET TotalCharges = NULL
WHERE TotalCharges = '';

-- SQL Data Cleaning Layer (CORE QUERIES)
UPDATE telco_customers
SET TotalCharges = NULL
WHERE TotalCharges = '';

ALTER TABLE telco_customers
ALTER COLUMN TotalCharges DECIMAL(10,2);

3️⃣ Tenure Buckets
CASE 
    WHEN tenure < 6 THEN '0–5 months'
    WHEN tenure BETWEEN 6 AND 12 THEN '6–12 months'
    WHEN tenure BETWEEN 13 AND 24 THEN '13–24 months'
    ELSE '25+ months'
END AS tenure_group


-- Overall Churn Rate
SELECT 
    COUNT(*) AS total_customers,
    SUM(churn_flag) AS churned_customers,
    ROUND(100.0 * SUM(churn_flag) / COUNT(*), 2) AS churn_rate
FROM churn_view;

-- Churn by Contract Type
SELECT 
    Contract,
    COUNT(*) AS customers,
    SUM(churn_flag) AS churned,
    ROUND(100.0 * SUM(churn_flag) / COUNT(*), 2) AS churn_rate
FROM churn_view
GROUP BY Contract
ORDER BY churn_rate DESC;

--  Churn by Tenure Group
SELECT 
    tenure_group,
    COUNT(*) AS customers,
    SUM(churn_flag) AS churned,
    ROUND(100.0 * SUM(churn_flag) / COUNT(*), 2) AS churn_rate
FROM churn_view
GROUP BY tenure_group
ORDER BY churn_rate DESC;

--  High-Risk Customer Segment
SELECT 
    COUNT(*) AS high_risk_customers
FROM churn_view
WHERE 
    Contract = 'Month-to-month'
    AND MonthlyCharges > 70
    AND tenure < 12
    AND churn_flag = 1;

--  Create SQL Views for Power BI 

-- Power BI should consume views, not raw tables.

CREATE VIEW churn_view AS
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
        WHEN Churn = 'Yes' THEN 1 ELSE 0 
    END AS churn_flag
FROM telco_customers;