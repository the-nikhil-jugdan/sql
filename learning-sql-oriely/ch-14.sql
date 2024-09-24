# Views

select customer_id, first_name, concat(substr(email, 1, 2), '******', substr(email, -4)) as email
from customer;

-- Creating a view to store this query's result
create view customer_vw(customer_id, first_name, email) as
select customer_id,
       first_name,
       concat(substr(email, 1, 2), '******', substr(email, -4)) as email
from customer;

select *
from customer_vw;

describe customer_vw;

##
CREATE VIEW film_stats
AS
SELECT f.film_id,
       f.title,
       f.description,
       f.rating,
       (SELECT c.name
        FROM category c
                 INNER JOIN film_category fc
                            ON c.category_id = fc.category_id
        WHERE fc.film_id = f.film_id) category_name,
       (SELECT count(*)
        FROM film_actor fa
        WHERE fa.film_id = f.film_id) num_actors,
       (SELECT count(*)
        FROM inventory i
        WHERE i.film_id = f.film_id)  inventory_cnt,
       (SELECT count(*)
        FROM inventory i
                 INNER JOIN rental r
                            ON i.inventory_id = r.inventory_id
        WHERE i.film_id = f.film_id)  num_rentals
FROM film f;

explain
select *
from film_stats;

explain
select title
from film_stats;

# Updatable Views

# Exercise 14

## Exercise 14-1
select title, first_name, last_name, category.name as category_name
from film_actor
         left join film on film_actor.film_id = film.film_id
         left join film_category on film.film_id = film_category.film_id
         left join category on film_category.category_id = category.category_id
         left join actor on film_actor.actor_id = actor.actor_id;


create view fiml_ctgry_actor
as
select title, first_name, last_name, category.name as category_name
from film_actor
         left join film on film_actor.film_id = film.film_id
         left join film_category on film.film_id = film_category.film_id
         left join category on film_category.category_id = category.category_id
         left join actor on film_actor.actor_id = actor.actor_id;

select *
from fiml_ctgry_actor
where last_name = 'FAWCETT';

## Exercise 14-2
select sum(amount), country.country
from payment
         left join customer on customer.customer_id = payment.customer_id
         left join address on customer.address_id = address.address_id
         left join city on address.city_id = city.city_id
         left join country on city.country_id = country.country_id
group by country.country
order by 2;

create view country_payments as
select country,
       (select sum(amount)
        from payment
                 left join customer on payment.customer_id = customer.customer_id
                 left join address on customer.address_id = address.address_id
                 left join city on address.city_id = city.city_id
                 left join country c on city.country_id = country.country_id
        where country.country_id = city.country_id) tot_poayments
from country;

select * from country_payments;

