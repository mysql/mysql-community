-- 1. Create the schema.
CREATE SCHEMA mysql_shorts;

-- 2. Switch to the schema.
USE mysql_shorts;

-- 3. Create the related tables.
CREATE TABLE `order` (
  id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL
);

CREATE TABLE order_item (
  id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL,
  product VARCHAR(100) NOT NULL,
  quantity INT NOT NULL,
  CONSTRAINT fk_order_item_order
    FOREIGN KEY (order_id) REFERENCES `order`(id)
);

-- 4. Add initial relational data.
INSERT INTO `order` (id, first_name, last_name)
VALUES (101, 'Avery', 'Taylor');

INSERT INTO order_item (order_id, product, quantity)
VALUES
  (101, 'Coffee beans', 2),
  (101, 'Mug', 1);

-- 5. Create the JSON duality view.
CREATE JSON DUALITY VIEW orders_view AS
SELECT JSON_DUALITY_OBJECT(
  WITH (INSERT, UPDATE, DELETE)
  '_id': id,
  'first_name': first_name,
  'last_name': last_name,
  'items': (
    SELECT JSON_ARRAYAGG(
      JSON_DUALITY_OBJECT(
        WITH (INSERT, UPDATE, DELETE)
        'id': id,
        'product': product,
        'quantity': quantity
      )
    )
    FROM order_item
    WHERE order_item.order_id = `order`.id
  )
)
FROM `order`;

-- 6. Read Avery's order as JSON.
SELECT JSON_PRETTY(data)
FROM orders_view
WHERE data->'$._id' = 101;

-- 7. Insert Jordan's order without supplying IDs.
INSERT INTO orders_view VALUES ('{
  "first_name": "Jordan",
  "last_name": "Lee",
  "items": [
    {"product": "Tea", "quantity": 2},
    {"product": "Teapot", "quantity": 1},
    {"product": "Honey", "quantity": 1}
  ]
}');

-- 8. Read Jordan's order as JSON.
SELECT JSON_PRETTY(data)
FROM orders_view
WHERE data->'$._id' = 102;

-- 9. Show the underlying relational rows using a join.
SELECT
  o.id AS order_id,
  o.first_name,
  o.last_name,
  i.id AS order_item_id,
  i.product,
  i.quantity
FROM `order` AS o
JOIN order_item AS i ON i.order_id = o.id
ORDER BY o.id, i.id;

-- 10. Replace Jordan's JSON document.
-- Change the last name, increase Tea's quantity, and remove Honey.
UPDATE orders_view
SET data = '{
  "_id": 102,
  "first_name": "Jordan",
  "last_name": "Smith",
  "items": [
    {"id": 3, "product": "Tea", "quantity": 4},
    {"id": 4, "product": "Teapot", "quantity": 1}
  ]
}'
WHERE data->'$._id' = 102;

-- 11. Show the updated JSON document.
SELECT JSON_PRETTY(data)
FROM orders_view
WHERE data->'$._id' = 102;

-- 12. Verify the changes in the relational tables.
SELECT
  o.id AS order_id,
  o.first_name,
  o.last_name,
  i.id AS order_item_id,
  i.product,
  i.quantity
FROM `order` AS o
JOIN order_item AS i ON i.order_id = o.id
WHERE o.id = 102
ORDER BY i.id;

-- 13. Delete Jordan's order and its remaining items.
DELETE FROM orders_view
WHERE data->'$._id' = 102;

-- 14. Verify that only Avery's order and items remain.
SELECT
  o.id AS order_id,
  o.first_name,
  o.last_name,
  i.id AS order_item_id,
  i.product,
  i.quantity
FROM `order` AS o
JOIN order_item AS i ON i.order_id = o.id
ORDER BY o.id, i.id;
