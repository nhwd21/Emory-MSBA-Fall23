# Note: for this question, I connected to the BIG DATA class MySQL server, which Annie provided credentials for

# connect to my database
USE STUDENT_DMOSDEN;

# Q1 Part 1
# Sales_receipt: Load using SQL: LOAD DATA LOCAL INFILE
DROP TABLE IF EXISTS sales_receipt;
CREATE TABLE `sales_receipt` (
    `transaction_id` INT,
    `transaction_date` TEXT,
    `transaction_time` TEXT,
    `sales_outlet_id` INT,
    `staff_id` INT,
    `customer_id` INT,
    `instore_yn` TEXT,
    `order` INT,
    `line_item_id` INT,
    `product_id` INT,
    `quantity` INT,
    `line_item_amount` DOUBLE,
    `unit_price` DOUBLE,
    `promo_item_yn` TEXT
);
DELETE FROM sales_receipt;
LOAD DATA LOCAL INFILE "C:\\Users\\d_mos\\OneDrive\\Documents\\ISOM 671 [Big Data]\\Assignment 3\\coffee shop\\sales_receipt.csv"
INTO TABLE sales_receipt
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;
SELECT * FROM sales_receipt;

# Q1 Part 2
# Product: Load 5 entries using SQL: INSERT INTO product
DROP TABLE IF EXISTS product;
CREATE TABLE `product` (
    `product_id` INT,
    `product_group` TEXT,
    `product_category` TEXT,
    `product_type` TEXT,
    `product` TEXT,
    `product_description` TEXT,
    `unit_of_measure` TEXT,
    `current_wholesale_price` DOUBLE,
    `current_retail_price` TEXT,
    `tax_exempt_yn` TEXT,
    `promo_yn` TEXT,
    `new_product_yn` TEXT
);
DELETE FROM product;
INSERT INTO product (
    product_id,
    product_group,
    product_category,
    product_type,
    product,
    product_description,
    unit_of_measure,
    current_wholesale_price,
    current_retail_price,
    tax_exempt_yn,
    promo_yn,
    new_product_yn
) VALUES
(
    1,
    'Whole Bean/Teas',
    'Coffee beans',
    'Organic Beans',
    'Brazilian - Organic',
    'It\'s like Carnival in a cup. Clean and smooth.',
    '12 oz',
    14.4,
    '$18.00',
    'Y',
    'N',
    'N'
),
(
    2,
    'Whole Bean/Teas',
    'Coffee beans',
    'House blend Beans',
    'Our Old Time Diner Blend',
    'Out packed blend of beans that is reminiscent of the cup of coffee you used to get at a diner.',
    '12 oz',
    14.4,
    '$18.00',
    'Y',
    'N',
    'N'
),
(
    3,
    'Whole Bean/Teas',
    'Coffee beans',
    'Espresso Beans',
    'Espresso Roast',
    'Our house blend for a good espresso shot.',
    '1 lb',
    11.8,
    '$14.75',
    'Y',
    'N',
    'N'
),
(
    4,
    'Whole Bean/Teas',
    'Coffee beans',
    'Espresso Beans',
    'Primo Espresso Roast',
    'Our premium single source of hand-roasted beans.',
    '1 lb',
    16.36,
    '$20.45',
    'Y',
    'N',
    'N'
),
(
    5,
    'Whole Bean/Teas',
    'Coffee beans',
    'Gourmet Beans',
    'Columbian Medium Roast',
    'A smooth cup of coffee any time of day.',
    '1 lb',
    12,
    '$15.00',
    'Y',
    'N',
    'N'
);
SELECT * FROM product;