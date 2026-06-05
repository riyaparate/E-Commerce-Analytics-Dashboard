create database olist_project;
use olist_project;

## 1. CUSTOMERS TABLE
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix INT,
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);

## 2. ORDERS TABLE
CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(50),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME,

    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
);

## 3. ORDER ITEMS TABLE
CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),

    PRIMARY KEY (order_id, order_item_id)
);

## 4. ORDER PAYMENTS TABLE
CREATE TABLE order_payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(50),
    payment_installments INT,
    payment_value DECIMAL(10,2)
);

## 5. ORDER REVIEWS TABLE
CREATE TABLE order_reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title VARCHAR(255),
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME
);

## 6. PRODUCTS TABLE
CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(200),
    product_name_lenght FLOAT,
    product_description_lenght FLOAT,
    product_photos_qty FLOAT,
    product_weight_g FLOAT,
    product_length_cm FLOAT,
    product_height_cm FLOAT,
    product_width_cm FLOAT
);

## 7. PRODUCT CATEGORY TRANSLATION TABLE
CREATE TABLE product_category_translation (
    product_category_name VARCHAR(100),
    product_category_name_english VARCHAR(100)
);

## 8. SELLERS TABLE
CREATE TABLE sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state VARCHAR(10)
);

## 9. GEOLOCATION TABLE
CREATE TABLE geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat FLOAT,
    geolocation_lng FLOAT,
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(10)
);

SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

## import customer 

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_customers_dataset.csv" 
INTO TABLE customers 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; 

## Import orders

LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_orders_dataset.csv" 
INTO TABLE orders
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
  order_id, 
  customer_id, 
  order_status, 
  order_purchase_timestamp, 
  @v_approved_at,             
  @v_carrier_date, 
  @v_customer_date, 
  order_estimated_delivery_date
)
SET  
  order_approved_at = IF(@v_approved_at = '' OR @v_approved_at IS NULL, NULL, @v_approved_at), 
  order_delivered_carrier_date = IF(@v_carrier_date = '' OR @v_carrier_date IS NULL, NULL, @v_carrier_date),
  order_delivered_customer_date = IF(@v_customer_date = '' OR @v_customer_date IS NULL, NULL, @v_customer_date);
  
  ## IMPORT ORDER ITEMS
  LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_items_dataset.csv"
INTO TABLE order_items
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; 

## IMPORT PAYMENTS
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_payments_dataset.csv"
INTO TABLE order_payments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

## IMPORT REVIEWS
DROP TABLE IF EXISTS products;
SELECT * FROM order_reviews;

## IMPORT PRODUCTS
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_products_dataset.csv"  
INTO TABLE products 
FIELDS TERMINATED BY ','  
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS
-- 1. Saare columns ko sequence me likhein. Khali hone wale columns ko variables (@v_) me lenge
(
  product_id, 
  product_category_name, 
  @v_name_len, 
  @v_desc_len, 
  @v_photos_qty, 
  @v_weight_g, 
  @v_length_cm, 
  @v_height_cm, 
  @v_width_cm
)
-- 2. Ab check karenge agar variable khali ('') hai to use NULL set kar do, nahi to asli value daalo
SET 
  product_name_lenght = IF(@v_name_len = '', NULL, @v_name_len),
  product_description_lenght = IF(@v_desc_len = '', NULL, @v_desc_len),
  product_photos_qty = IF(@v_photos_qty = '', NULL, @v_photos_qty),
  product_weight_g = IF(@v_weight_g = '', NULL, @v_weight_g),
  product_length_cm = IF(@v_length_cm = '', NULL, @v_length_cm),
  product_height_cm = IF(@v_height_cm = '', NULL, @v_height_cm),
  product_width_cm = IF(@v_width_cm = '', NULL, @v_width_cm);
  
  ## IMPORT SELLERS
  




