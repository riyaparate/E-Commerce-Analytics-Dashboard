## Kpi And Chart Show 

USE olist_project;

## KPI 1 : TOTAL ORDERS

SELECT 
    COUNT(DISTINCT order_id) AS Total_Orders
FROM orders;

## KPI 2 : TOTAL REVENUE

SELECT 
    ROUND(SUM(payment_value),2) AS Total_Revenue
FROM order_payments;

## KPI 3 : AVERAGE REVIEW SCORE

SELECT 
    ROUND(AVG(review_score),2) AS Avg_Review_Score
FROM order_reviews;

## KPI 4 : AVERAGE DELIVERY DAYS

SELECT 
    ROUND(
        AVG(
            DATEDIFF(
                order_delivered_customer_date,
                order_purchase_timestamp
            )
        ),
    2) AS Avg_Delivery_Days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;

## CHART 1 : WEEKDAY VS WEEKEND PAYMENT ANALYSIS

SELECT
    CASE
        WHEN DAYOFWEEK(order_purchase_timestamp) IN (1,7)
        THEN 'Weekend'
        ELSE 'Weekday'
    END AS Day_Type,

    ROUND(SUM(op.payment_value),2) AS Total_Payment

FROM orders o

JOIN order_payments op
ON o.order_id = op.order_id

GROUP BY Day_Type;

## CHART 2 : ORDERS BY PAYMENT METHOD

SELECT
    payment_type,
    COUNT(order_id) AS Total_Orders
FROM order_payments
GROUP BY payment_type
ORDER BY Total_Orders DESC;

## CHART 3 : AVERAGE PAYMENT VALUE BY PRODUCT CATEGORY

SELECT
    pct.product_category_name_english,
    
    ROUND(AVG(op.payment_value),2) AS Avg_Payment_Value

FROM order_items oi

JOIN products p
ON oi.product_id = p.product_id

JOIN product_category_translation pct
ON p.product_category_name = pct.product_category_name

JOIN order_payments op
ON oi.order_id = op.order_id

GROUP BY pct.product_category_name_english
ORDER BY Avg_Payment_Value DESC;

## CHART 4 : TOP 10 PRODUCT CATEGORIES BY SALES

SELECT
    pct.product_category_name_english,

    ROUND(SUM(op.payment_value),2) AS Total_Sales

FROM order_items oi

JOIN products p
ON oi.product_id = p.product_id

JOIN product_category_translation pct
ON p.product_category_name = pct.product_category_name

JOIN order_payments op
ON oi.order_id = op.order_id

GROUP BY pct.product_category_name_english
ORDER BY Total_Sales DESC
LIMIT 10;

## CHART 5: AVERAGE ORDER VALUE VS AVERAGE PRODUCT PRICE FOR SAO PAULO CUSTOMERS

SELECT
    c.customer_city,

    ROUND(AVG(op.payment_value),2) AS Avg_Order_Value,

    ROUND(AVG(oi.price),2) AS Avg_Product_Price

FROM customers c

JOIN orders o
ON c.customer_id = o.customer_id

JOIN order_payments op
ON o.order_id = op.order_id

JOIN order_items oi
ON o.order_id = oi.order_id

WHERE c.customer_city = 'sao paulo'

GROUP BY c.customer_city;

## CHART 6 : MONTHLY SALES TREND

SELECT
    DATE_FORMAT(order_purchase_timestamp,'%Y-%m') AS Month,

    ROUND(SUM(op.payment_value),2) AS Monthly_Revenue

FROM orders o

JOIN order_payments op
ON o.order_id = op.order_id

GROUP BY Month
ORDER BY Month;

