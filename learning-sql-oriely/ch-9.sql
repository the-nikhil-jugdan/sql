# Subqueries

select customer_id, first_name, last_name
from customer
where customer_id = (select max(customer_id) from customer);

# Subquery Types

## Non Correlated subqueries

select city_id, city
from city
where country_id <> (select country.country_id from country where country = 'India');

### Multiple Row, single column subqueries

-- The in and not in operators

select city_id, city
from city
where country_id in
      (select country_id
       from country
       where country in ('Canada', 'Mexico'));

select city_id, city
from city
where country_id not in
      (select country_id
       from country
       where country in ('Canada', 'Mexico'));

-- The all operator

select first_name, last_name
from customer
where customer_id <> all (select payment.customer_id from payment where amount = 0);

select customer_id, count(*)
from rental
group by customer_id
having count(*) > all (select count(*)
                       from rental
                                inner join customer on rental.customer_id = customer.customer_id
                                inner join address on customer.address_id = address.address_id
                                inner join city on address.city_id = city.city_id
                                inner join country on city.country_id = country.country_id
                       where country.country in ('United States', 'Mexico', 'Canada')
                       group by rental.customer_id);

-- The any operator

select customer_id, sum(amount)
from payment
group by customer_id
having sum(amount) > any (select sum(payment.amount)
                          from payment
                                   inner join customer on payment.customer_id = customer.customer_id
                                   inner join address on customer.address_id = address.address_id
                                   inner join city on address.city_id = city.city_id
                                   inner join country on city.country_id = country.country_id
                          where country.country in ('Bolivia', 'Paraguay', 'Chile')
                          group by country.country);

### Multi column Sub Queries

select actor_id, film_id
from film_actor fa
where (actor_id, film_id) in (select actor.actor_id, film.film_id
                              from actor
                                       cross join film
                              where last_name = 'MONROE'
                                and rating = 'PG');

## Correlated Subqueries

explain
select first_name, last_name
from customer
where 20 = (select count(*) from rental where rental.customer_id = customer.customer_id);

explain
select first_name, last_name
from customer
where (select sum(payment.amount)
       from payment
       where payment.customer_id = customer.customer_id) between 180 and 240;

-- The exists operator
select first_name, last_name
from customer
where exists(select 1 from rental where rental.customer_id = customer.customer_id and date(rental_date) < '2005-05-25');

-- The not exists operator
select first_name, last_name
from actor
where not exists(select 1
                 from film_actor fa
                          inner join film on fa.film_id = film.film_id
                 where fa.actor_id = actor.actor_id
                   and film.rating = 'R');

## Data Manipulation Using Correlated Subqueries

update customer
set last_name = (select max(rental_date) from rental where rental.customer_id = customer.customer_id);

update customer
set last_name = (select max(rental_date) from rental where rental.customer_id = customer.customer_id)
where exists(select 1
             from rental
             where rental.customer_id = customer.customer_id);

delete
from customer
where 365 < (select datediff(now(), min(rental_date)) from rental where rental.customer_id = customer.customer_id);

## When to use Sub Queries

### Subqueries as Data Sources

select first_name, last_name, pymt.num_rentals, pymt.tot_payments
from customer
         inner join (select customer_id, count(*) num_rentals, sum(amount) tot_payments
                     from payment
                     group by customer_id) pymt on pymt.customer_id = customer.customer_id;

select 'Small Fry' name, 0 low_limit, 74.99 high_limit
union all
select 'Average Jones' name, 75 low_limit, 149.99 high_limit
union all
select 'Heavy Hitters' name, 150 low_limit, 9999999.99 high_limit;


select pymnt_grps.name, count(*) num_customers
from (select customer_id, count(*) num_rentals, sum(amount) tot_payments from payment group by customer_id) pymnts
         inner join (select 'Small Fry' name, 0 low_limit, 74.99 high_limit
                     union all
                     select 'Average Jones' name, 75 low_limit, 149.99 high_limit
                     union all
                     select 'Heavy Hitters' name, 150 low_limit, 9999999.99 high_limit) pymnt_grps
                    on pymnts.tot_payments between pymnt_grps.low_limit and pymnt_grps.high_limit
group by pymnt_grps.name;


### Task Oriented Subqueries

select first_name, city.city, sum(amount) tot_payments, count(*) tot_rentals
from payment
         inner join customer on payment.customer_id = customer.customer_id
         inner join address on customer.address_id = address.address_id
         inner join city on address.city_id = city.city_id
group by first_name, city.city;


-- We can write the above query as

-- The aggregation Query
select customer_id, count(*) tot_rentals, sum(amount) tot_payments
from payment
group by customer_id;

select first_name, city, pymnts.tot_payments, pymnts.tot_rentals
from (select customer_id, count(*) tot_rentals, sum(amount) tot_payments
      from payment
      group by customer_id) pymnts
         inner join customer on pymnts.customer_id = customer.customer_id
         inner join address on customer.address_id = address.address_id
         inner join city on address.city_id = city.city_id;

-- This query is more modular, and may run faster.
-- In the previous query, we were joining and then grouping, so the total number of rows before the containing
-- query's group by was run, was as much as the payments records
-- In the second query, we run group by on payments first, then join

## Common Table Expressions (CTE)

-- A CTE is a named query, which uses with clause

with actors_s as (select actor_id, first_name, last_name from actor where last_name like 'S%'),
     actors_s_pg as (select actors_s.actor_id, first_name, last_name, film.film_id, title
                     from actors_s
                              inner join film_actor on actors_s.actor_id = film_actor.actor_id
                              inner join film on film_actor.film_id = film.film_id
                     where rating = 'PG'),
     actrors_s_pg_revenue as (select first_name, last_name, amount
                              from actors_s_pg
                                       inner join inventory on actors_s_pg.film_id = inventory.film_id
                                       inner join rental on inventory.inventory_id = rental.inventory_id
                                       inner join payment on rental.rental_id = payment.rental_id)
select first_name, last_name, sum(amount) total_revenue
from actrors_s_pg_revenue
group by first_name, last_name
order by 3 desc;

### Subqueries as Expression Generators

-- Using scalar subqueries to fetch values and run order by
select (select first_name from customer where payment.customer_id = customer.customer_id) as first_name,
       (select last_name from customer where payment.customer_id = customer.customer_id)  as last_name,
       (select city
        from customer
                 inner join address on customer.address_id = address.address_id
                 inner join city on address.city_id = city.city_id
        where payment.customer_id = customer.customer_id)                                    city,
       sum(amount)                                                                           tot_payments,
       count(*)                                                                              total_rentals
from payment
group by payment.customer_id;

-- To run order by
select actor_id, first_name, last_name
from actor
order by (select count(*) from film_actor where actor.actor_id = film_actor.actor_id) desc;

-- To insert data
insert into film_actor (actor_id, film_id, last_update)
values ((select actor.actor_id from actor where first_name = 'JENNIFER' and last_name = 'DAVIS'),
        (select film.film_id
         from film
         where title = 'ACE GOLDFINGER'),
        now());

## Subquery Wrap Up
-- Subqueries can do:
-- Return a single column and row, a single column with multiple rows and multiple rows and multiple columns
-- Are independent of the containing statement - Non correlated Subqueries
-- Reference one or more columns from the containing statement - Correlated Subqueries
-- Are used in conditions that utilize comparison operators as well as the special purpose operators in, not in, exists and not exists
-- Can be found in select, update, delete and insert statements
-- Generate result sets that can be joined to other tables or subqueries in a query
-- Can be used to generate values to populate a table, or populate columns in a query's resutl set
-- Are used in the select, from ,where, having and order by clauses of queries.

## Exercise 9

# Exercise 9.1


select film.title, cat.name
from film
         inner join(select category.name, film_id
                    from film_category
                             inner join category on film_category.category_id = category.category_id
                    where category.name = 'Action') cat on cat.film_id = film.film_id;

select title, film_id
from film;

-- After taking some GPT help

select title, film_id
from film
where film_id in (select film_category.film_id
                  from film_category
                  where category_id in (select category.category_id
                                        from category
                                        where name = 'Action'));

# Exercise 9.2


select title, film.film_id
from film
where film_id in (select film_category.film_id
                  from film_category
                           inner join category on category.category_id = film_category.category_id
                  where category.name = 'Action');

-- Using GPT to understand question
select title, film_id
from film
where 'Action' in (select category.name
                   from film_category
                            inner join category on film_category.category_id = category.category_id
                   where film.film_id = film_category.film_id);

-- GPT's query
select title, film_id
from film
where exists(select 1
             from film_category
                      inner join category on film_category.category_id = category.category_id
             where film.film_id = film_category.film_id
               and category.name = 'Action');


# Exercise 9.3

select first_name, last_name, fa.films_done, levels.level
from actor
         inner join (select actor_id, count(*) as films_done
                     from film_actor
                     group by actor_id) fa on fa.actor_id = actor.actor_id
         inner join(SELECT 'Hollywood Star' level, 30 min_roles, 99999 max_roles
                    UNION ALL
                    SELECT 'Prolific Actor' level, 20 min_roles, 29 max_roles
                    UNION ALL
                    SELECT 'Newcomer' level, 1 min_roles, 19 max_roles) as levels
                   on films_done between levels.min_roles and levels.max_roles;

