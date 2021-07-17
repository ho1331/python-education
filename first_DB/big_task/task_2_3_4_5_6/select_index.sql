EXPLAIN
SELECT *
FROM cars
    FULL OUTER JOIN rent USING(cars_id)
    LEFT JOIN clients USING(clients_id)
WHERE rent.cars_id is NOT NULL
    AND clients_name IN ('name4385', 'name4394', 'name6721')
    AND period_of_renting < 7;

CREATE INDEX idx_clients_name ON clients(clients_name);
-- DROP INDEX idx_clients_name;

EXPLAIN
SELECT *
FROM clients
    JOIN adress USING(adress_id)
WHERE building > 300;

CREATE INDEX idx_adress_build ON adress(building);
-- DROP INDEX idx_adress_build;


EXPLAIN SELECT period_of_renting,SUM(price) total_price,COUNT(cars_id) cars
	FROM rent
	JOIN cars USING(cars_id)
	JOIN models USING(model_id)
	WHERE branch_id IN(2,11)
	GROUP BY period_of_renting;

	
CREATE INDEX idx_cars_branch_id ON cars(branch_id);
-- DROP INDEX idx_cars_branch_id;