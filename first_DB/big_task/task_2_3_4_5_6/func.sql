--loop and returning table
create or replace function total_min_price()
	returns table(period_renting int,total_price bigint,cars bigint)
	language plpgsql
	as
	$$
	declare
		s_row record;
	begin
		for s_row in(
			SELECT period_of_renting,SUM(price) as p,COUNT(cars_id) as c
				FROM rent
				JOIN cars USING(cars_id)
				JOIN models USING(model_id)
				GROUP BY period_of_renting)
			loop
				CASE
					WHEN s_row.period_of_renting = 3 THEN total_price := s_row.p - (s_row.p/1000)*3;
					WHEN s_row.period_of_renting = 2 THEN total_price := s_row.p - (s_row.p/100)*2;
					ELSE total_price := s_row.p - (s_row.p/10);
				END CASE;
				period_renting := s_row.period_of_renting;
				cars := s_row.c;
				return next;
			end loop;
				
	end;$$;



-- select * FROM total_min_price(); 
-- drop function total_min_price;



--with cursor
create or replace function check_phone_model_rent()
   returns table(c_id int, phone varchar, model_name varchar)
   language plpgsql
as $$
declare
	 s_row record;
	 phone_oper cursor for select clients_id, clients_tel, price
			 from clients
			 join rent using(clients_id)
			 join cars using(cars_id)
			 join models using(model_id);
begin
   open phone_oper;
   loop
   -- here fetch
      fetch phone_oper into s_row;
    -- exit when end rows
      exit when not found;
      if s_row.clients_tel like '38066%' then phone := 'vodafone';
	  elsif s_row.clients_tel like '38096%' or s_row.clients_tel like '38097%' then phone := 'kyivstar';
	  elsif s_row.clients_tel like '38093%' or s_row.clients_tel like '38063%' then phone := 'life';
	  else phone := 'life';
      end if;
	  
	  if s_row.price > 900 then model_name := 'Tesla';
	  elsif s_row.price between 400 and 900 then model_name := 'Lincoln';
	  else model_name := 'Not metter';
	  end if;
	  c_id := s_row.clients_id;
	  --record result into table
	  return next;
   end loop;
   close phone_oper;
end; $$

-- select * from check_phone_model_rent();
-- drop function check_phone_model_rent;