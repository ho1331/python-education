
create function set_ship_tot(some_city varchar)
returns void
language plpgsql
as
$$
declare
	user_iden int;
	order_cart int;
	ship record;
begin
   select cart_id
   into user_iden
   from carts join users using(user_id)
   where lower(users.city) = lower(some_city);
   
   for ship in (select cart_id from orders) loop
   		order_cart := ship.cart_id;
   		if user_iden = order_cart then
			update orders set shipping_total = 0
			where cart_id = order_cart;
		end if;
	end loop;

   return;
end; $$;

select set_ship_tot('city 2');