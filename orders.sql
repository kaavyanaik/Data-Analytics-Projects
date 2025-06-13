-- Top 10 Highest Revenue-Generating Products
SELECT TOP 10 
    product_id, 
    SUM(sale_price) AS revenue_generated
FROM 
    df_orders
GROUP BY 
    product_id
ORDER BY 
    revenue_generated DESC;


-- Top 5 Highest-Selling Products in Each Region
WITH product_region_sales AS (
    SELECT 
        product_id,
        region,
        SUM(sale_price) AS revenue_generated
    FROM 
        df_orders
    GROUP BY 
        product_id, region
),
ranked_products AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY region ORDER BY revenue_generated DESC) AS rn
    FROM 
        product_region_sales
)
SELECT 
    product_id,
    region,
    revenue_generated
FROM 
    ranked_products
WHERE 
    rn <= 5
ORDER BY 
    region, revenue_generated DESC;


--MOM sales
WITH cte AS (
    SELECT 
        YEAR(order_date) AS year_sale,
        MONTH(order_date) AS month_sale,
        SUM(sale_price) AS sales
    FROM df_orders
    GROUP BY YEAR(order_date), MONTH(order_date)
),
cte2 AS (
    SELECT 
        *,
        LAG(sales, 1) OVER (ORDER BY year_sale, month_sale) AS previous_sales
    FROM cte
)
SELECT *,
       ROUND((sales - previous_sales) * 100.0 / NULLIF(previous_sales, 0), 2) AS mom_sales
FROM cte2;





-- Month-wise Sales Comparison: 2022 vs 2023
WITH monthly_sales AS (
    SELECT 
        YEAR(order_date) AS order_year,
        MONTH(order_date) AS order_month,
        SUM(sale_price) AS sales
    FROM 
        df_orders
    GROUP BY 
        YEAR(order_date), 
        MONTH(order_date)
)

SELECT 
    order_month,
    SUM(CASE WHEN order_year = 2022 THEN sales ELSE 0 END) AS sales_2022,
    SUM(CASE WHEN order_year = 2023 THEN sales ELSE 0 END) AS sales_2023
FROM 
    monthly_sales
GROUP BY 
    order_month
ORDER BY 
    order_month;



--Month with Highest Sales for Each Category 
WITH monthly_category_sales AS (
    SELECT 
        category,
        FORMAT(order_date, 'MMM yyyy') AS month_name,         -- e.g., 'Jan 2023'
        SUM(sale_price) AS sales
    FROM 
        df_orders
    GROUP BY 
        category, 
        FORMAT(order_date, 'MMM yyyy')
),
ranked_sales AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY sales DESC) AS rn
    FROM 
        monthly_category_sales
)
SELECT 
    category,
    month_name,
    sales
FROM 
    ranked_sales
WHERE 
    rn = 1
ORDER BY 
    sales DESC;


--Sub-Category with Highest Sales Growth from 2022 to 2023

WITH yearly_sales AS (
    SELECT 
        sub_category,
        YEAR(order_date) AS order_year,
        SUM(sale_price) AS sales
    FROM 
        df_orders
    GROUP BY 
        sub_category, YEAR(order_date)
),
pivoted_sales AS (
    SELECT 
        sub_category,
        SUM(CASE WHEN order_year = 2022 THEN sales ELSE 0 END) AS sales_2022,
        SUM(CASE WHEN order_year = 2023 THEN sales ELSE 0 END) AS sales_2023
    FROM 
        yearly_sales
    GROUP BY 
        sub_category
)
SELECT TOP 1 
    sub_category,
    sales_2022,
    sales_2023,
    sales_2023 - sales_2022 AS sales_growth,
    ROUND((sales_2023 - sales_2022) * 100.0 / NULLIF(sales_2022, 0), 2) AS growth_percentage
FROM 
    pivoted_sales
ORDER BY 
    sales_growth DESC;