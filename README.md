
# 🛍️ Retail Orders Analytics Project

This project demonstrates a complete end-to-end data analytics workflow using **Python**, **Pandas**, **SQL**, and **SQL Server**. The goal is to derive actionable business insights from a retail orders dataset.

---

## 📁 Project Structure

```
📦Retail-Orders-Analytics
├── Orders.ipynb         # Python notebook for data cleaning & loading
├── orders.csv           # Raw retail dataset
├── orders.png           # Power BI dashboard exported PNG
├── orders.sql           # SQL queries for analysis
└── README.md            # Project documentation
```

---

## 🔍 Objective

- Clean and preprocess raw retail data using Python
- Load the data into SQL Server using SQLAlchemy
- Perform business-oriented SQL analysis to derive insights on:
  - Revenue-generating products
  - Regional product performance
  - Month-over-month sales trends
  - Year-over-year growth comparisons
  - Category/sub-category wise sales patterns

---

## ⚙️ Tools & Technologies

- **Python** (pandas, SQLAlchemy)
- **SQL Server** with ODBC Driver 17
- **Jupyter Notebook**
- **Kaggle CLI** for dataset download

---

## 🧹 Data Preprocessing (Python)

Performed using `pandas` in `Orders.ipynb`:
- Loaded the dataset (`orders.csv`)
- Handled missing/null values
- Converted date columns to datetime format
- Cleaned column names
- Loaded cleaned data to SQL Server using:

```python
df.to_sql('df_orders', con=conn, index=False, if_exists='replace')
```

---

## 🧠 SQL Analysis (orders.sql)

Key SQL insights derived from the dataset include:

1. **Top 10 highest revenue-generating products**
2. **Top 5 products in each region**
3. **Month-over-month (MoM) sales trend**
4. **MoM comparison between 2022 and 2023**
5. **Month of highest sales for each category**
6. **Sub-category with highest YoY sales growth**

Example SQL query:

```sql
-- MOM growth comparison between 2022 and 2023
SELECT order_month,
  SUM(CASE WHEN order_year = 2022 THEN sales ELSE 0 END) AS sales_2022,
  SUM(CASE WHEN order_year = 2023 THEN sales ELSE 0 END) AS sales_2023
FROM (
  SELECT YEAR(order_date) AS order_year, MONTH(order_date) AS order_month, SUM(sale_price) AS sales
  FROM df_orders
  GROUP BY YEAR(order_date), MONTH(order_date)
) cte
GROUP BY order_month
ORDER BY order_month;
```

---

## 📊 Business Insights

- 📈 January had the highest YoY growth from 2022 to 2023.
- 🏆 Certain products consistently drove the most revenue.
- 🌍 Regional variations in top-selling products provided actionable segmentation clues.
- 📅 Each category had distinct peak sales months, useful for marketing strategy planning.

---

## 🚀 How to Run This Project

1. Install requirements:
   ```bash
   pip install pandas sqlalchemy pyodbc
   ```

2. Set up SQL Server (with ODBC Driver 17).

3. Upload dataset to your local or cloud SQL Server using the Jupyter Notebook.

4. Run `orders.sql` in SQL Server Management Studio (SSMS) to analyze data.

---

## 🙋‍♀️ Author

**Kavya Naik**  
Aspiring Data Analyst | Skilled in SQL, Python, Excel, and Power BI  

---

## 📌 License

This project is for educational and portfolio purposes. Attribution appreciated if reused.
