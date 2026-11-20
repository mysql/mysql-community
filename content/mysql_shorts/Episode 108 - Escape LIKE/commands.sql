-- 1. Create the schema if it does not exist.
CREATE DATABASE IF NOT EXISTS mysql_shorts;

-- 2. Switch to the schema.
USE mysql_shorts;

-- 3. Remove the demo table before recreating it.
-- Destructive reset: removes only this episode's table.
DROP TABLE IF EXISTS like_escape_products;

-- 4. Create the product codes table.
CREATE TABLE like_escape_products (
    product_code VARCHAR(30) PRIMARY KEY
);

-- 5. Add product codes containing underscores, percent signs, and ordinary characters.
INSERT INTO like_escape_products (product_code)
VALUES
    ('USB_CABLE'),
    ('USB-CABLE'),
    ('USB3'),
    ('SAVE20%'),
    ('SAVE20PLUS'),
    ('SAVE200');

-- 6. Match USB codes with an underscore wildcard that matches any single character.
SELECT product_code
FROM like_escape_products
WHERE product_code LIKE 'USB_%'
ORDER BY product_code;

-- 7. Escape the underscore to match codes starting with a literal USB_.
SELECT product_code
FROM like_escape_products
WHERE product_code LIKE 'USB!_%' ESCAPE '!'
ORDER BY product_code;

-- 8. Match SAVE20 codes with a percent wildcard that matches any number of characters.
SELECT product_code
FROM like_escape_products
WHERE product_code LIKE 'SAVE20%'
ORDER BY product_code;

-- 9. Escape the percent sign to match the literal code SAVE20%.
SELECT product_code
FROM like_escape_products
WHERE product_code LIKE 'SAVE20!%' ESCAPE '!'
ORDER BY product_code;
