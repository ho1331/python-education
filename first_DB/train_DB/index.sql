-----------1-------------
EXPLAIN SELECT * FROM cart_products 
WHERE products_product_id = 813; --(Seq Scan on cart_products  (cost=0.00..186.34 rows=3 width=8)

CREATE INDEX idx_cart_product_product_id ON cart_products(products_product_id);

EXPLAIN SELECT * FROM cart_products 
WHERE products_product_id = 813; --(Bitmap Index Scan on idx_cart_product_product_id  (cost=0.00..4.31 rows=3 width=0))

-----------2-------------
EXPLAIN SELECT * FROM carts 
WHERE subtotal BETWEEN 319 AND 567; --(Seq Scan on carts  (cost=0.00..45.00 rows=496 width=28))

CREATE INDEX idx_carts_subtotal ON carts(subtotal);

EXPLAIN SELECT * FROM carts 
WHERE subtotal BETWEEN 319 AND 567; --(Bitmap Index Scan on idx_carts_subtotal  (cost=0.00..13.24 rows=496 width=0))

-----------3-------------
EXPLAIN SELECT COUNT(product_title) count_product,category_id FROM products 
WHERE category_id = 2  GROUP BY category_id HAVING COUNT(product_title) > 180; --(Seq Scan on products  (cost=0.00..155.00 rows=190 width=16))

CREATE INDEX idx_products_category_id ON products(category_id);

EXPLAIN SELECT COUNT(product_title) count_product,category_id FROM products 
WHERE category_id = 2  GROUP BY category_id HAVING COUNT(product_title) > 180; --(Bitmap Index Scan on idx_products_category_id  (cost=0.00..5.71 rows=190 width=0))


DROP INDEX idx_products_category_id,idx_cart_product_product_id,idx_carts_subtotal;


--with join
CREATE INDEX idx_orders ON orders(order_status_id);

EXPLAIN
SELECT orders.total,
    status_name,
    last_name clients
FROM carts
    JOIN users USING(user_id)
    JOIN orders USING(cart_id)
    JOIN order_statuses USING(order_status_id)
WHERE orders.total > 75
    AND order_status_id = 4;

DROP INDEX idx_orders;