create procedure insert_adress()
	language plpgsql
	as $$
	declare
		counter int;
		c_region varchar;
		c_city varchar;
		c_street varchar;
		c_building int;
	begin
		counter := 1;
		while counter <= 2000 loop
			c_region := 'region'||counter;
			c_city := 'city'||counter;
			c_street := 'street'||counter;
			c_building := (random()*400)::int;

			INSERT INTO adress (region,city,street,building) 
                VALUES (c_region,c_city,c_street,c_building);

			counter := counter+1;
			commit;
		end loop;
	end;$$;



create procedure insert_models()
	language plpgsql
	as $$
	declare
		counter int;
		c_model varchar;
		c_price int;
	begin
		counter := 1;
		while counter <= 500 loop
			c_model := 'model'||counter;
			c_price := (random()*1000)::int;

			INSERT INTO models (model,price) 
                VALUES (c_model,c_price);

			counter := counter+1;
			commit;
		end loop;
	end;$$;



create procedure insert_branches()
	language plpgsql
	as $$
	declare
		counter int;
		c_branch_name varchar;
		c_branch_tel varchar;
		c_adress_id int;
	begin
		counter := 1;
		while counter <= 50 loop
			c_branch_name := 'b_name'||counter;
			c_branch_tel := '380'||(random()*1000000000)::int;

			select adress_id into c_adress_id 
				from adress order by random() limit 1;

			INSERT INTO branches (branch_name,branch_tel,adress_id) 
                VALUES (c_branch_name,c_branch_tel,c_adress_id);

			counter := counter+1;
			commit;
		end loop;
	end;$$;



create procedure insert_cars()
	language plpgsql
	as $$
	declare
		counter int;
		c_branch_id int;
		c_model_id int;
		c_cars_number varchar;
	begin
		counter := 1;
		while counter <= 7000 loop
			c_cars_number := 'car_number'||counter;

			select branch_id into c_branch_id 
				from branches order by random() limit 1;

			select model_id into c_model_id 
				from models order by random() limit 1;

			INSERT INTO cars (branch_id,model_id,cars_number) 
                VALUES (c_branch_id,c_model_id,c_cars_number);

			counter := counter+1;
			commit;
		end loop;
	end;$$;


create procedure insert_clients()
	language plpgsql
	as $$
	declare
		counter int;
		c_clients_name varchar;
		c_clients_tel varchar;
		c_adress_id int;
	begin
		counter := 1;
		while counter <= 9000 loop
			c_clients_name := 'name'||counter;
			c_clients_tel := '380'||(random()*1000000000)::int;

			select adress_id into c_adress_id 
				from adress order by random() limit 1;

			INSERT INTO clients (clients_name,clients_tel,adress_id) 
                VALUES (c_clients_name,c_clients_tel,c_adress_id);

			counter := counter+1;
			commit;
		end loop;
	end;$$;



create procedure insert_rent()
	language plpgsql
	as $$
	declare
		counter int;
		c_date_of_renting date;
		c_period_of_renting int;
		c_cars_id int;
		c_clients_id int;
	begin
		counter := 1;
		while counter <= 600 loop
			c_date_of_renting := '2021-06-19'::date + counter;
			c_period_of_renting := (random()*10)::int + 1;

			select cars_id into c_cars_id 
				from cars order by random() limit 1;

			select clients_id into c_clients_id 
				from clients order by random() limit 1;

			INSERT INTO rent (date_of_renting,period_of_renting,cars_id,clients_id) 
                VALUES (c_date_of_renting,c_period_of_renting,c_cars_id,c_clients_id);
                
			counter := counter+1;
			commit;
		end loop;
	end;$$;



call insert_adress();
call insert_models();
call insert_branches();
call insert_cars();
call insert_clients();
call insert_rent();
--drop procedure insert_rent;
--drop procedure insert_models;
--drop procedure insert_branches;
--drop procedure insert_cars;
--drop procedure insert_clients;