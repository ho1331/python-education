create procedure delete_clients(client_id int)
	language plpgsql
	as $$
	declare
	 s_row record;
	 client cursor for select clients_id
			 from rent;
	begin
	  open client;
		   loop
			  fetch client into s_row;
			  if not found then
			  	DELETE FROM clients WHERE clients_id = client_id;
                commit;
				exit;
				end if;
			  if s_row.clients_id = client_id then
			  	RAISE EXCEPTION 'id: % is using on another constract.', s_row.clients_id;
			  end if;

			end loop;
		close client;
	end;$$;
	
	
	
call delete_clients(246);
--drop procedure delete_clients;


create procedure update_clients(client_id int, tel varchar)
	language plpgsql
	as $$
	declare
		c_id int;
	begin
		select clients_id into c_id from clients
			where clients_id = client_id;
			
		if c_id is NULL then
			RAISE EXCEPTION 'id: % dosn''t exist', client_id;
		else
			UPDATE clients SET clients_tel = tel
				WHERE clients_id = c_id;
			commit;
		end if;

	end;$$;
	
	
	
call update_clients(246, '380660764651');
--drop procedure update_clients;


--все процедуры с INSERT в файле inserting.sql