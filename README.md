# 🛒 Walmart Sales Data Analysis

![Python](https://img.shields.io/badge/Python-3.12-blue?style=flat-square&logo=python)
![Pandas](https://img.shields.io/badge/Pandas-Data_Processing-green?style=flat-square)
![MySQL](https://img.shields.io/badge/MySQL-Database-orange?style=flat-square)
![Status](https://img.shields.io/badge/Status-Complete-success?style=flat-square)

> **End-to-End Data Analytics Project** demonstrating ETL pipeline, data cleaning, and SQL-based business analysis on 10,000+ Walmart sales transactions.

---

## 📌 Project Overview

This project analyzes Walmart e-commerce sales data to solve real-world business problems. The workflow includes:
- **Data Cleaning** with Python (removed duplicates, handled missing values, transformed data types)
- **Database Integration** with MySQL
- **SQL Analysis** solving 21 business problems using advanced queries

**Tech Stack:** Python | Pandas | MySQL | Jupyter Notebook

---

## 📊 Dataset Information

- **Records:** 10,051 → 9,969 (after cleaning)
- **Time Period:** 2022-2023
- **Columns:** 12 (invoice_id, branch, city, category, unit_price, quantity, date, time, payment_method, rating, profit_margin, total)

---

## 🧹 Data Cleaning (Python)

**Steps Performed:**

1. **Removed Duplicates:** 51 duplicate records identified and removed
2. **Handled Missing Values:** 31 rows with null values dropped
3. **Data Type Conversion:** 
   - Converted `unit_price` from string ($XX.XX) to float
   - Ensured proper data types for all columns
4. **Feature Engineering:** Created `total` column (unit_price × quantity)
5. **Standardization:** Converted all column names to lowercase

**Result:** Clean dataset with 9,969 records ready for analysis

---

## 💼 Business Problems Solved (21 SQL Queries)

### 📈 Sales & Revenue Analysis
- Transaction volume analysis
- Revenue comparison (2022 vs 2023)
- Top 3 revenue-generating products per category
- Peak revenue month identification per branch
- Revenue decline investigation (top 5 branches)

### 💳 Payment Analytics
- Payment method distribution
- Preferred payment method by branch
- Sales volume by payment type

### ⭐ Customer Insights
- Category ratings by city (min, max, average)
- Highest-rated category per branch
- Transaction size segmentation (Small/Medium/Large)

### 🏪 Operational Insights
- Busiest day of the week per branch
- Sales shift patterns (Morning/Afternoon/Evening)
- Branch network assessment

### 💰 Profitability
- Total profit by category
- Profit estimation handling missing data
- Branch-category revenue matrix
- Pricing strategy analysis

---

## 🔍 SQL Skills Demonstrated

- **Window Functions:** `RANK()`, `ROW_NUMBER()`, `DENSE_RANK()`, `PARTITION BY`
- **CTEs (Common Table Expressions):** Complex multi-step queries
- **Aggregate Functions:** `SUM()`, `AVG()`, `COUNT()`, `MIN()`, `MAX()`
- **Date/Time Functions:** `DAYNAME()`, `MONTHNAME()`, `YEAR()`, `HOUR()`
- **Conditional Logic:** `CASE WHEN` statements
- **Joins:** Multi-table operations
- **Database Objects:** Created Views and Stored Procedures
- **Data Handling:** `COALESCE()` for NULL values

---

## 📂 Project Files

```
├── walmart_sales_analysis.ipynb    # Python data cleaning & ETL
├── walmart_sales_queries.sql       # 21 SQL business queries
├── business_problems.pdf           # Detailed problem statements
├── walmart_clean_data.csv          # Cleaned dataset
└── README.md                       # Project documentation
```

---

## 🚀 How to Run

### Prerequisites
- Python 3.12+
- MySQL 8.0+
- Jupyter Notebook

### Steps

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/walmart-sales-analysis.git
```

2. **Install required libraries**
```bash
pip install pandas sqlalchemy pymysql
```

3. **Setup MySQL database**
```sql
CREATE DATABASE walmart_db;
```

4. **Run the Python notebook**
   - Open `walmart_sales_analysis.ipynb`
   - Update database credentials
   - Execute all cells

5. **Run SQL queries**
   - Open `walmart_sales_queries.sql` in MySQL Workbench
   - Execute queries to see analysis results

---

## 💡 Key Insights

- **Payment Trends:** E-wallet is the most preferred payment method
- **Revenue Decline:** 5 branches showed revenue decrease from 2022 to 2023
- **Customer Ratings:** Average rating of 5.8/10 across all transactions
- **Peak Hours:** Evening shift generates maximum transactions
- **Profitability:** Electronic accessories category shows highest profit margins

---

## 🎯 Learning Outcomes

Through this project, I gained hands-on experience with:

✅ **Data Cleaning:** Handling real-world messy data  
✅ **ETL Pipeline:** Building end-to-end data workflows  
✅ **SQL Expertise:** Writing complex analytical queries  
✅ **Business Analysis:** Translating data into actionable insights  
✅ **Database Management:** Working with MySQL databases  
✅ **Problem Solving:** Addressing real business questions  

---

## 👨‍💻 About Me

**Sachin**  
Aspiring Data Analyst | SQL | Python | Data Visualization

📧 Email: your.email@example.com  
💼 LinkedIn: 
🐙 GitHub: 

---

## 📄 License

This project is open source and available for educational purposes.

---

**⭐ If you found this project helpful, please give it a star!**
