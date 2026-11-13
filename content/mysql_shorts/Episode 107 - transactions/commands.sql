-- 1. Create the schema if it does not exist.
CREATE DATABASE IF NOT EXISTS mysql_shorts;

-- 2. Switch to the schema.
USE mysql_shorts;

-- 3. Remove the demo table before recreating it.
-- DESTRUCTIVE: replaces only this episode's demo table.
DROP TABLE IF EXISTS transaction_inventory;

-- 4. Create the inventory table with a nonnegative quantity constraint.
CREATE TABLE transaction_inventory (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(40) NOT NULL,
    quantity INT NOT NULL,
    CONSTRAINT transaction_inventory_nonnegative
        CHECK (quantity >= 0)
) ENGINE = InnoDB;

-- 5. Add products with their starting inventory quantities.
INSERT INTO transaction_inventory
    (product_id, product_name, quantity)
VALUES
    (1, 'Keyboard', 10),
    (2, 'Mouse',    20),
    (3, 'Cable',    15),
    (4, 'Monitor',   1),
    (5, 'Webcam',    8);

-- 6. Show the starting inventory quantities.
SELECT product_name, quantity
FROM transaction_inventory
WHERE product_id <= 4
ORDER BY product_id;

-- 7. Reserve two keyboards.
UPDATE transaction_inventory
SET quantity = quantity - 2
WHERE product_id = 1;

-- 8. Reserve one mouse.
UPDATE transaction_inventory
SET quantity = quantity - 1
WHERE product_id = 2;

-- 9. Reserve three cables.
UPDATE transaction_inventory
SET quantity = quantity - 3
WHERE product_id = 3;

-- 10. Show inventory quantities after the successful reservations.
SELECT product_name, quantity
FROM transaction_inventory
WHERE product_id <= 4
ORDER BY product_id;

-- 11. Attempt to reserve four monitors, violating the quantity constraint.
-- Intentional error: run separately, then continue with ROLLBACK.
UPDATE transaction_inventory
SET quantity = quantity - 4
WHERE product_id = 4;

-- 12. Undo every earlier change in this transaction.
ROLLBACK;

-- 13. Confirm the original quantities are restored.
SELECT product_name, quantity
FROM transaction_inventory
WHERE product_id <= 4
ORDER BY product_id;
