-- Задание 2.1
-- Вывести:
-- 1. всех юзеров,
-- 2. все продукты,
-- 3. все статусы заказов

SELECT *
FROM users;

SELECT *
FROM products;

SELECT *
FROM order_statuses;

-- Задание 2.2
-- Вывести заказы, которые успешно доставлены и оплачены
SELECT order_id, carts_cart_id, order_status_order_status_id, shipping_total, total, updated_at, created_at
FROM orders, order_statuses
WHERE order_status_order_status_id =  order_status_id AND status_name IN('Paid','Finished');
--or
SELECT order_id, carts_cart_id, order_status_order_status_id, shipping_total, total, updated_at, created_at
FROM orders JOIN order_statuses ON orders.order_status_order_status_id = order_statuses.order_status_id
WHERE status_name IN('Paid','Finished');

-- Задание 2.3
-- Вывести:
-- (если задание можно решить несколькими способами, указывай все)
-- 1. Продукты, цена которых больше 80.00 и меньше или равно 150.00
-- 2. заказы совершенные после 01.10.2020 (поле created_at)
-- 3. заказы полученные за первое полугодие 2020 года
-- 4. подукты следующих категорий Category 7, Category 11, Category 18
-- 5. незавершенные заказы по состоянию на 31.12.2020
-- 6.Вывести все корзины, которые были созданы, но заказ так и не был оформлен.

-----1------
SELECT *
FROM products
WHERE price > 80 AND price <= 150;
-----2------
SELECT *
FROM orders
WHERE created_at::date > TO_DATE('2020/10/01','YYYY/MM/DD')
--or-
SELECT *
FROM orders
WHERE created_at > '2020-10-01'
::timestamp;

-----3------
SELECT *
FROM orders
WHERE EXTRACT(QUARTER FROM created_at ) < 3 AND date_part('year', created_at) = '2020';

-----4------
SELECT product_id, product_title, product_description, in_stock, price, slug, products.category_id
FROM products, categories
WHERE products.category_id = categories.category_id AND category_title IN('Category 7', 'Category 11', 'Category 18');
--or
SELECT *
FROM products
WHERE category_id IN (SELECT category_id
FROM categories
WHERE category_title IN('Category 7', 'Category 11', 'Category 18'));
--or
SELECT product_id, product_title, product_description, in_stock, price, slug, products.category_id
FROM products JOIN categories ON products.category_id = categories.category_id
WHERE categories.category_title IN('Category 7', 'Category 11', 'Category 18');

----5------
SELECT order_id, carts_cart_id, order_status_order_status_id, shipping_total, total, updated_at, created_at
FROM orders, order_statuses
WHERE order_status_order_status_id =  order_status_id AND status_name = 'In progress' AND updated_at < '2020-12-31'
::timestamp;
--or
SELECT *
FROM orders
WHERE order_status_order_status_id IN (SELECT order_status_id
    FROM order_statuses
    WHERE status_name = 'In progress') AND updated_at < '2020-12-31'
::timestamp;

--конкретно на 31.12.2020
SELECT *
FROM orders
WHERE order_status_order_status_id IN (SELECT order_status_id
    FROM order_statuses
    WHERE status_name = 'In progress') AND updated_at = '2020-12-31'
::timestamp;

----6------
SELECT cart_id, users_user_id, subtotal, carts.total, timestamp
FROM carts, orders, order_statuses
WHERE carts_cart_id = cart_id AND order_status_order_status_id=order_status_id AND status_name = 'Canceled';
--or
SELECT cart_id, users_user_id, subtotal, carts.total, timestamp
FROM carts JOIN orders ON carts_cart_id = cart_id JOIN order_statuses ON order_status_order_status_id=order_status_id
WHERE status_name = 'Canceled';