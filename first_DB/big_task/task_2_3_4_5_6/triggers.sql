CREATE FUNCTION delete_client_by_rent()
    RETURNS TRIGGER
	language plpgsql
as $$
begin
    DELETE FROM clients WHERE clients_id = OLD.clients_id;
	if not found then return NULL;
	end if;
    return OLD;
end;$$;


CREATE TRIGGER delete_client
    AFTER DELETE
ON rent
FOR EACH ROW
    EXECUTE PROCEDURE delete_client_by_rent();

-- DROP TRIGGER delete_client ON rent;
-- DROP FUNCTION delete_client_by_rent;


CREATE FUNCTION delete_rent_by_clients()
    RETURNS TRIGGER
	language plpgsql
as $$
begin
    DELETE FROM rent WHERE clients_id = OLD.clients_id;
	if not found then return NULL;
	end if;
    return OLD;
end;$$;


CREATE TRIGGER delete_rent
    BEFORE DELETE
ON clients
FOR EACH ROW
    EXECUTE PROCEDURE delete_rent_by_clients();

-- DROP TRIGGER delete_rent ON clients;
-- DROP FUNCTION delete_rent_by_clients;