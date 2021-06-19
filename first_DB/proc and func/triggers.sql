CREATE FUNCTION change_type_crts_timestamp()
    RETURNS TRIGGER
AS $$
BEGIN
    IF OLD.timestamp < now() THEN
		UPDATE carts SET subtotal = NEW.total, timestamp = now()
		WHERE carts.total = NEW.total;
	ELSIF OLD.timestamp = now() THEN
		UPDATE carts SET subtotal = NEW.total
		WHERE carts.total = NEW.total;
	
	END IF;
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER change_type_to_timestamp
    AFTER UPDATE
ON carts
FOR EACH ROW
    EXECUTE PROCEDURE change_type_crts_timestamp();
	
-- DROP TRIGGER change_type_to_timestamp ON carts;
-- DROP FUNCTION change_type_crts_timestamp;


CREATE FUNCTION carts_insert_new()
    RETURNS TRIGGER
AS $$
DECLARE
	users_id int;
	avg_total int;
BEGIN
	SELECT count(user_id) INTO users_id FROM carts;
	SELECT avg(total) INTO avg_total FROM carts;
	IF NEW.user_id > users_id THEN
		INSERT INTO carts VALUES(
			NEW.user_id,
			NEW.user_id,
			avg_total,
			avg_total,
			now());
	END IF;
    RETURN NEW;
	
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER carts_refresh
    AFTER INSERT
ON users
FOR EACH ROW
    EXECUTE PROCEDURE carts_insert_new();
	
-- DROP TRIGGER carts_refresh ON users;
-- DROP FUNCTION carts_insert_new;