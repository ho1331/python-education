create procedure update_with_time(status int)
	language plpgsql
	as $$
	declare
		dif_timestamp text := 
			'select * 
			from orders 
			where order_status_id = $1
			AND (date_part(''day'', now()) - date_part(''day'', updated_at)) >2';
			
		s_data record;
	begin
		execute dif_timestamp into s_data using status;
		if s_data is not NULL then
			update orders set shipping_total = 120 
			where order_status_id = status;
			commit;
		end if;

	end;$$;


call update_with_time(1);
--drop procedure update_with_time;



create procedure change_val()
	language plpgsql
	as $$
	declare
		rows record;
		prices decimal;
		in_stocs int;
		id int;
	begin
		for rows in 
			(SELECT * FROM products 
			JOIN cart_products USING(product_id)
			LEFT JOIN orders USING(cart_id)
			WHERE orders.cart_id is NULL) loop
			
			prices := rows.price;
			in_stocs := rows.in_stock;
			id := rows.order_id;

			if in_stocs = 0 then
				commit;
				begin
					delete from products where in_stock = in_stocs;
					exception
						WHEN foreign_key_violation THEN rollback;
				end;

			elsif in_stocs = 12 and prices> 200 then
				commit;
				begin
					update orders set order_id= (select count(order_id)+1 from orders);
					exception
						WHEN others THEN rollback;
				end;
			else rollback;
			end if;
		end loop;

	end;$$;

-- drop procedure change_val;
call change_val();