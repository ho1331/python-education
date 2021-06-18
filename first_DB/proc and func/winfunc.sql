WITH avg_price AS (
    SELECT category_title,
        product_title,
        price,
        avg(price) OVER(PARTITION BY category_title) AVG
    FROM products
        JOIN categories USING(category_id)
    ORDER BY category_title DESC
)
SELECT category_title,
    product_title,
    price,
    avg,
    price - avg as diff
FROM avg_price;