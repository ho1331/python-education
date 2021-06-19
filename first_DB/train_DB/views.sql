--products
CREATE VIEW products_quantile AS
SELECT product_title,
    price,
    category_id
FROM products
WHERE price BETWEEN (
        SELECT MIN(price)
        FROM products
    )
    AND (
        SELECT AVG(price)
        FROM products
    ) WITH CHECK OPTION;
    
--order_status and orders
CREATE VIEW orders_2018 AS
SELECT *
FROM orders
    JOIN order_statuses USING(order_status_id)
WHERE date_part('year', updated_at) = '2018'
    AND order_status_id IN(1, 3);

--products and category
CREATE VIEW count_product_by_category AS
SELECT category_title,
    COUNT(product_title) count
FROM products
    JOIN categories USING(category_id)
WHERE in_stock > 20
GROUP BY category_title;
DROP VIEW products_quantile,
orders_2018,
count_product_by_category;

--hard query
CREATE MATERIALIZED VIEW rank_of_clients AS
SELECT cart_id,
    COUNT(product_id) "products count",
    orders.total,
    status_name,
    last_name clients,
    CASE
        WHEN orders.total > 800 THEN 'VIP client'
        WHEN orders.total < 300 THEN 'meager client'
        ELSE 'potential VIP client'
    END AS "rank of client"
FROM cart_products
    JOIN carts USING(cart_id)
    JOIN users USING(user_id)
    JOIN orders USING(cart_id)
    JOIN order_statuses USING(order_status_id)
WHERE order_status_id = 4
    AND orders.total > 75
GROUP BY (cart_id, orders.total, status_name, clients)
HAVING COUNT(product_id) < 8
ORDER BY "products count" WITH NO DATA;

REFRESH MATERIALIZED VIEW rank_of_clients;

DROP MATERIALIZED VIEW rank_of_clients;