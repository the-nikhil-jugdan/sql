# Conditional Logic, CASE statements

select first_name, last_name, case when active = 1 then 'ACTIVE' else 'INACTIVE' end activity_type
from customer;

# The Case expression

## Searched Case Expression
select name,
       case
           when name in ('Children', 'Family', 'Sports', 'Animation')
               then 'All Ages'
           when name = 'Horror' then 'Adult'
           when name in ('Music', 'Games')
               then 'Teens'
           else 'Other'
           end suitable_for
from category;

select first_name,
       last_name,
       case
           when active = 0 then 0
           else (select count(*) from rental where customer.customer_id = rental.customer_id)
           end num_reports
from customer;

## Simple Case Expression

select name,
       case name
           when 'Children' then 'All Ages'
           when 'Family' then 'All Ages'
           when 'Sports' then 'All Ages'
           when 'Animation' then 'All Ages'
           when 'Horror' then 'Adult'
           when 'Music' then 'Teens'
           when 'Games' then 'Teens'
           else 'Other'
           end
from category;

# Case Expression Examples

## Result Set Transformations
select monthname(rental_date) rental_month, count(*) num_rentals
from rental
where rental_date between '2005-05-01' and '2005-08-01'
group by monthname(rental_date);

-- To transform this query to a query which returns a single row with 3 columns

select sum(case when monthname(rental_date) = 'May' then 1 else 0 end)  may_rentals,
       sum(case when monthname(rental_date) = 'June' then 1 else 0 end) june_rentals,
       sum(case when monthname(rental_date) = 'July' then 1 else 0 end) july_rentals
from rental
where rental_date between '2005-05-01' and '2005-08-01';

## Checking for existence

select first_name,
       last_name,
       case
           when exists(select 1
                       from film_actor
                                inner join film on film_actor.film_id = film.film_id
                       where actor.actor_id = film_actor.actor_id
                         and film.rating = 'G') then 'Y'
           else 'N'
           end g_actor,
       case
           when exists(select 1
                       from film_actor
                                inner join film on film_actor.film_id = film.film_id
                       where actor.actor_id = film_actor.actor_id
                         and film.rating = 'PG') then 'Y'
           else 'N'
           end pg_actor,
       case
           when exists(select 1
                       from film_actor
                                inner join film on film_actor.film_id = film.film_id
                       where actor.actor_id = film_actor.actor_id
                         and film.rating = 'NC-17') then 'Y'
           else 'N'
           end nc17_actor
from actor
where last_name like 'S%'
  and first_name like 'S%';

select title,
       case (select count(*) from inventory where film.film_id = inventory.film_id)
           when 0 then 'Out of Stock'
           when 1 then 'Scarce'
           when 2 then 'Scarce'
           when 3 then 'Available'
           when 4 then 'Available'
           else 'Common' end film_availability
from film;

## Division by Zero Errors
select 100 / 0;

select first_name,
       last_name,
       sum(amount)   total_payment_amount,
       count(amount) num_payments,
       sum(amount) / case
                         when count(amount) = 0 then 1
                         else count(amount
                              )
           end       avg_payment
from customer
         left outer join payment on customer.customer_id = payment.customer_id
group by first_name, last_name;

## Conditional Updates
update customer
set active = case
                 when 90 < (select datediff(now(), max(rental_date))
                            from rental
                            where rental.customer_id = customer.customer_id) then 0
                 else 1
    end
where active = 1;

## Handling Null Values

select case
           when address.address is null then 'unknown'
           else address.address
           end address_,
       case
           when city.city is null then 'Unknown'
           else city.city
           end city_,
       case
           when country.country is null then 'Unknown'
           else country.country
           end country_
from customer
         left outer join address on customer.address_id = address.address_id
         left outer join city on address.city_id = city.city_id
         left outer join country on city.country_id = country.country_id;

-- Null values in calculation
select (7 * 5) / ((3 + 14) * null);

# Exercises

## Exercise 11-1

select name,
       case
           when name in ('English', 'Italian', 'French', 'German') then 'latin1'
           when name in ('Japanese', 'Mandarin') then 'utf-8'
           else 'Unknown'
           end character_set
from language;

## Exercise 11-2

select sum(case when rating = 'PG' then 1 else 0 end)    PG,
       sum(case when rating = 'G' then 1 else 0 end)     G,
       sum(case when rating = 'PG-13' then 1 else 0 end) PG_13,
       sum(case when rating = 'NC-17' then 1 else 0 end) NC_17,
       sum(case when rating = 'R' then 1 else 0 end)     R
from film;

