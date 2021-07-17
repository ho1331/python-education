CREATE VIEW cheep_models AS
SELECT model_id,
    model,
    price
FROM models
WHERE price < (
        SELECT AVG(price) - AVG(price) / 2
        FROM models
    ) WITH CHECK OPTION;


CREATE VIEW small_branch AS
SELECT branch_name,
    branch_tel,
    city,
    COUNT(cars_id) cars
FROM branches
    JOIN adress USING(adress_id)
    JOIN cars USING(branch_id)
GROUP BY branch_name,
    branch_tel,
    city
HAVING COUNT(cars_id) > 140;


-- DROP VIEW cheep_models,small_branch;

CREATE MATERIALIZED VIEW branches_info AS
SELECT branch_name,
    COUNT(clients_id) clients,
    COUNT(cars_number) cars,
    CASE
        WHEN COUNT(clients_id) > 15 THEN 'Popular branch'
        ELSE 'Not enough info'
    END AS "with stat"
FROM branches
    JOIN cars USING(branch_id)
    FULL OUTER JOIN rent USING(cars_id)
GROUP BY branch_name WITH NO DATA;

REFRESH MATERIALIZED VIEW branches_info;
-- DROP MATERIALIZED VIEW branches_info;
