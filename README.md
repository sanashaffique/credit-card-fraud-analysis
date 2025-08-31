# Credit Card Fraud Detection Dashboard 📊
## Project Overview
This project analyzes a simulated **Credit Card Transactions dataset** to detect and visualize fraud patterns. The dataset contains **555,719 transactions** with 23 columns and highlights fraud trends by **day, month, state, category, customer, job role, age group, and transaction amount levels**. The goal is to identify high-risk customers, transactions, and regions to improve fraud monitoring and decision-making.

🗂 **Dataset Source:** Kaggle – Synthetic dataset generated using Sparkov.  
**Structure:** Single large transaction table with customer, product, and transaction details.  
**Record Count:** 555,719 transactions.

🛠 **Tools & Technologies**  
- **SQL Server / T-SQL:** Data cleaning, type conversions, null handling, and exploratory queries.  
- **Power BI:** Multi-page dashboard creation with relationships, KPIs, visualizations, and interactive slicers.  

🧹 **Data Cleaning & Preparation**  
- Converted columns to proper data types (e.g., float → decimal, nvarchar → nchar).  
- Standardized categorical values (merchant, job, gender).  
- Removed duplicates and irrelevant columns (e.g., `unix_time`).  
- Created additional columns: `age`, `age_group`, `amt_group`, and `full_name`.  
- Handled missing latitude/longitude carefully to avoid loss of valid location data.  

📈 **Key Insights**
- **Total Transactions:** 555,719  
- **Fraud Count:** 2,145 (less than 1%)  
- **Total Transaction Amount:** $38.56M  
- **Unique Credit Card Holders:** 924  
- **Fraud by State:** Highest in New York (175 cases)  
- **Fraud by Category:** Online payments (`shopping_net`) and POS payments (`grocery_pos`) highest  
- **Customer Behavior:** Seniors commit most fraud; low-amount transactions dominate  
- **Fraud Trends:** Peaks from July to November; highest daily fraud on 4th October  

📷 **Dashboard Pages**
- **Raw Dataset :** https://drive.google.com/file/d/1ZOoAZq6pvlKjYSG7slaQ3Q_r8Fscbu2-/view?usp=drive_link 
- **Power BI Dashboard:** https://drive.google.com/file/d/1hScma3POMgaSiU_5MXrAnr7gTFwHzOJi/view?usp=drive_link  

**Page 1 – Overview / Summary**  
https://github.com/sanashaffique/credit-card-fraud-analysis/blob/main/Screenshot 2025-08-31 203417.png
Displays KPIs for total transactions, fraud count, fraud rate, total amount, and unique customers. Includes line chart of fraud by date and state, bar charts for category and gender.  

**Page 2 – Customer Insights**  
https://github.com/sanashaffique/credit-card-fraud-analysis/blob/main/Screenshot%202025-08-31%20203440.png
Analyzes fraud by age group, gender, top customers, job roles, and amount groups. Interactive slicers include date, amount, age group, and gender.  

**Page 3 – Geographical Distribution**  
https://github.com/sanashaffique/credit-card-fraud-analysis/blob/main/Screenshot 2025-08-31 203502.png
Maps and charts for fraud by state, business/store, and merchant site. Bubble maps visualize high-risk locations.  

**Page 4 – Transaction Insights & Trends**  
https://github.com/sanashaffique/credit-card-fraud-analysis/blob/main/Screenshot 2025-08-31 203538.png
Line charts for fraud by day/month, matrix of business vs total transactions vs fraud, and analysis by amount groups. Highlights repeat fraud customers and channel-based trends.  

📌 **Recommendations**
- Ensure consistent and accurate data collection.  
- Standardize job titles and demographic information.  
- Monitor high-risk regions and low-value transactions for fraud prevention.  
- Align transaction timestamps for accurate trend analysis.

---
