-- Задание 1
-- Создайте новую таблицу potential customers с полями id, email, name, surname, second_name, city
CREATE TABLE potential_customers
(
    id SERIAL,
    email VARCHAR(255),
    password VARCHAR(255),
    name VARCHAR(255),
    surname VARCHAR(255),
    second_name VARCHAR(255),
    city VARCHAR(255),
    PRIMARY KEY (id)
);
-- Заполните данными таблицу.
INSERT INTO potential_customers(email,name,surname,second_name,city) 
SELECT email,first_name,last_name,middle_name,city 
FROM users WHERE user_id > 9 LIMIT 150;

-- Выведите имена и электронную почту потенциальных и существующих пользователей из города city 17
SELECT name pot_name,potential_customers.email pot_email,first_name exist_name, users.email exist_email 
FROM potential_customers,users 
WHERE users.city= 'city 17' 
AND potential_customers.city = 'city 17';

-- Задание 2
-- Вывести имена и электронные адреса всех users отсортированных по городам и по имени (по алфавиту)
SELECT first_name, email FROM users ORDER BY (city,first_name);

-- Задание 3
-- Вывести наименование группы товаров, общее количество по группе товаров в порядке убывания количества
SELECT category_title, COUNT(category_id) count_of_prod 
FROM categories JOIN products USING(category_id) 
GROUP BY category_title ORDER BY count_of_prod DESC;

-- Задание 4
-- 1. Вывести продукты, которые ни разу не попадали в корзину.
-- 2. Вывести все продукты, которые так и не попали ни в 1 заказ. (но в корзину попасть могли).
-- 3. Вывести топ 10 продуктов, которые добавляли в корзины чаще всего.
-- 4. Вывести топ 10 продуктов, которые не только добавляли в корзины, но и оформляли заказы чаще всего.
-- 5. Вывести топ 5 юзеров, которые потратили больше всего денег (total в заказе).
-- 6. Вывести топ 5 юзеров, которые сделали больше всего заказов (кол-во заказов).
-- 7. Вывести топ 5 юзеров, которые создали корзины, но так и не сделали заказы.

SELECT product_title FROM products LEFT JOIN cart_products ON product_id = products_product_id
WHERE products_product_id IS NULL;

SELECT product_title FROM products 
JOIN cart_products ON product_id = products_product_id 
LEFT JOIN orders USING(carts_cart_id)
WHERE orders.carts_cart_id is NULL;

SELECT product_title, COUNT(products_product_id) counts FROM products 
JOIN cart_products ON product_id = products_product_id 
GROUP BY product_title ORDER BY counts DESC LIMIT 10;

SELECT product_title, COUNT(products_product_id) prod_id,COUNT(orders.carts_cart_id) ord_id FROM products 
JOIN cart_products ON product_id = products_product_id
LEFT JOIN orders USING(carts_cart_id)
GROUP BY product_title ORDER BY ord_id DESC LIMIT 10;

SELECT user_id, orders.total totality FROM users
JOIN carts ON user_id = users_user_id
JOIN orders ON carts_cart_id = cart_id
ORDER BY totality DESC LIMIT 5;

SELECT user_id, COUNT(order_id) orders FROM users
JOIN carts ON user_id = users_user_id
JOIN orders ON carts_cart_id = cart_id
GROUP BY user_id
ORDER BY orders DESC LIMIT 5;


SELECT user_id FROM users 
JOIN carts ON user_id = users_user_id
LEFT JOIN orders ON carts_cart_id = cart_id
WHERE carts_cart_id is NULL LIMIT 5;