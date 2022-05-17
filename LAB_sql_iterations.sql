#1 Write a query to find what is the total business done by each store.

USE 
	sakila;

SELECT 
	s.store_id, 
    round(sum(p.amount),0) as 'sales_amount'
FROM
	store s
JOIN 
	inventory i 
USING 
	(store_id)
JOIN 
	rental r 
USING
	(inventory_id)
JOIN 
	payment p 
USING  
	(rental_id)
GROUP BY 
	s.store_id;

#2 Convert the previous query into a stored procedure.

drop procedure if exists 
	pro_sales_store;

delimiter //
CREATE PROCEDURE pro_sales_store()
BEGIN 
  	SELECT 
	s.store_id, 
    round(sum(p.amount),0) as 'sales_amount'
	FROM
		store s
	JOIN 
		inventory i 
	USING 
		(store_id)
	JOIN 
		rental r 	
	USING
		(inventory_id)
	JOIN 
		payment p 
	USING  
		(rental_id)
	GROUP BY 
		s.store_id;
END;
// delimiter ;
CALL pro_sales_store();

#3 Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.

drop procedure if exists pro_sales_store;

delimiter //
CREATE PROCEDURE pro_sales_store(In param_store int (1))
BEGIN 
  	SELECT 
	s.store_id, 
    round(sum(p.amount),0) as 'sales_amount'
	FROM
		store s
	JOIN 
		inventory i 
	USING 
		(store_id)
	JOIN 
		rental r 	
	USING
		(inventory_id)
	JOIN 
		payment p 
	USING  
		(rental_id)
	WHERE 
		s.store_id = param_store
	GROUP BY 
		s.store_id;
END;
// delimiter ;

CALL pro_sales_store(2);

#4 Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result (of the total sales amount for the store). 

drop procedure if exists pro_sales_store;

delimiter //
CREATE PROCEDURE pro_sales_store(In param_store int)
BEGIN
DECLARE total_sales_value float default 0.0;
   SELECT 
	sum(p.amount) into total_sales_value
FROM
	store s
JOIN
	staff st 
USING
	(store_id)
JOIN
	payment p
USING
	(staff_id)
GROUP BY
	st.staff_id, s.store_id
HAVING
	s.store_id = param_store;
SELECT total_sales_value;
END;
//
delimiter ;

CALL pro_sales_store(1);

-- 5. In the previous query, add another variable flag. If the total sales value for the store is over 30.000, then label it as green_flag, otherwise label is as red_flag. 
-- Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value

drop procedure if exists pro_sales_store;

delimiter //
CREATE PROCEDURE pro_sales_store(In param_store int)
BEGIN
  	SELECT
		s.store_id, 
        round(sum(p.amount),0) as 'sales_amount',
  	CASE
		WHEN 
			sum(p.amount) > 30000 then "green flag"
		WHEN
			sum(p.amount) < 30000 then "red_flag"
  	END AS 
		sales_flag
	FROM 
		store s
	JOIN
		inventory i 
	USING
		(store_id)
	JOIN 
		rental r
	USING
		(inventory_id) 
	JOIN
		payment p 
	USING
		(rental_id)
	WHERE 
		s.store_id = param_store
	GROUP BY s.store_id;
end;
// delimiter ;

CALL pro_sales_store(2);

