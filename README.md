# 📊 Telco Customer Churn Analysis  
**SQL (Google BigQuery) | Power BI | Business Analytics**

---

## 🔍 Project Overview
Customer churn is a major revenue risk for subscription-based businesses.  
This project analyses customer churn for a telecommunications company using **SQL (BigQuery)** for data preparation and **Power BI** for interactive analysis and storytelling.

The goal is to:
- Identify **who is churning**
- Understand **why customers churn**
- Quantify **revenue at risk**
- Provide **actionable, data-driven recommendations**

---

## 🧠 Business Questions
- Which customer segments have the highest churn rate?
- How do **contract type**, **tenure**, **pricing**, and **internet service** affect churn?
- Where is the **largest financial exposure** from churn?
- Which customers should be prioritised for retention?

---

## 🗂 Dataset
- **Source:** Telco Customer Churn dataset  
- **Storage:** Google BigQuery  
- **Granularity:** One row per customer  

**Key fields**
- `customerID`
- `tenure`
- `Contract`
- `InternetService`
- `PaymentMethod`
- `MonthlyCharges`
- `TotalCharges`
- `SeniorCitizen`
- `Churn`

---

## 🛠 Tools & Technologies
- **SQL (BigQuery)** – data exploration, feature engineering, analytical views  
- **Power BI** – dashboarding, DAX measures, business storytelling  
- **Data Modelling** – SQL views as the semantic layer for BI  

---

## 🔍 Key Business Insights

- **Month-to-month contracts** consistently show the highest churn rates, indicating low customer commitment.
- Customers in their **first 6–12 months** are the most likely to churn, highlighting early lifecycle risk.
- **High monthly charges** significantly increase churn risk, especially among newly acquired customers.
- **Fibre optic customers** represent a disproportionate share of churn compared to other service types.
- The majority of **revenue at risk** originates from customers on month-to-month contracts.

---

## 🎯 Business Recommendations

Based on the analysis, the following actions are recommended:

### 1️⃣ Target Early-Tenure Customers
- Improve onboarding during the **first 3–6 months** of the customer lifecycle.
- Introduce **proactive customer success check-ins** to address early issues.

### 2️⃣ Incentivise Long-Term Contracts
- Offer **discounts or value-added benefits** to encourage migration from month-to-month plans.
- Promote contract upgrades as part of retention campaigns.

### 3️⃣ Improve Fibre Optic Service Experience
- Address **service quality gaps or expectation mismatches** for fibre customers.
- Provide **premium or priority support** to reduce dissatisfaction.

### 4️⃣ Retain High-Value Customers
- Introduce **loyalty incentives** for customers with high monthly charges.
- Implement **early intervention strategies** for high-risk, high-value segments.



