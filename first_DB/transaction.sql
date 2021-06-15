BEGIN;
INSERT INTO categories(category_id, category_title, category_description)
VALUES(73, 'Momoa', 'fork on');
UPDATE categories
SET category_description = 'nister in'
WHERE category_title = 'Momoa';
DELETE FROM categories
WHERE category_title = 'Momoa';
COMMIT;


BEGIN;
INSERT INTO orders VALUES(1501,1501,5,60,700,NULL,NULL);
SAVEPOINT SAVE_1;

UPDATE orders
SET shipping_total = 500,
    total = 255
WHERE (
        SELECT orders.order_id
        FROM products
            JOIN cart_products ON product_id = products_product_id
            LEFT JOIN orders USING(carts_cart_id)
        WHERE cart_products.carts_cart_id BETWEEN 1501 and 1503
        LIMIT 1
    ) is NULL;
SAVEPOINT SAVE_2;

DELETE FROM users WHERE 1506 in (SELECT user_id FROM users 
JOIN carts ON user_id = users_user_id
LEFT JOIN orders ON carts_cart_id = cart_id
WHERE carts_cart_id is NULL LIMIT 5);

ROLLBACK TO SAVE_1;

DELETE FROM orders WHERE order_id = 1501;
COMMIT;

SELECT * FROM orders ORDER BY order_id DESC LIMIT 10;