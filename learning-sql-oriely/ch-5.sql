desc customer;
desc address;

# Cartesian Product / Cross Join
select customer.first_name, customer.last_name, address.address
from customer
         join
     address;

# Inner Join

select first_name, last_name, address
from customer
         join address on customer.address_id = address.address_id;

select first_name, last_name, address
from customer
         inner join address on customer.address_id = address.address_id;

select first_name, last_name, address
from customer
         inner join address using (address_id);

# ANSI SQL92 syntax

-- Older join syntax
select first_name, last_name, address
from customer,
     address
where customer.address_id = address.address_id;

# Joining three tables

select first_name, last_name, city
from customer
         inner join address on customer.address_id = address.address_id
         inner join city on address.city_id = city.city_id;

# Switching up orders

select first_name, last_name, city
from address
         inner join city on address.city_id = city.city_id
         inner join customer on address.address_id = customer.address_id;

select first_name, last_name, city
from city
         inner join address on city.city_id = address.city_id
         inner join customer on address.address_id = customer.address_id;

## Straight Join
select straight_join first_name, last_name, city
from city
         inner join address on city.city_id = address.city_id
         inner join customer on address.address_id = customer.address_id;

# Using Subqueries as Tables

select first_name, last_name, address, city
from customer
         inner join (select address_id, address.address, city.city
                     from address
                              inner join city on address.city_id = city.city_id
                     where district = 'California') addr
                    on customer.address_id = addr.address_id;

# Using the same table twice
select title
from film
         inner join film_actor on film.film_id = film_actor.film_id
         inner join actor on film_actor.actor_id = actor.actor_id
where (
    first_name = 'CATE' AND last_name = 'MCQUEEN'
    )
   or (first_name = 'Cuba' and last_name = 'BIRCH');

## Finding films with Cate Mcqueen and Cuba Birch

select title
from film
         inner join film_actor fa1 on fa1.film_id = film.film_id
         inner join actor a1 on fa1.actor_id = a1.actor_id
         inner join film_actor fa2 on fa2.film_id = film.film_id
         inner join actor a2 on fa2.actor_id = a2.actor_id
where (a1.first_name = 'CATE' AND a1.last_name = 'MCQUEEN')
  and (a2.first_name = 'Cuba' and a2.last_name = 'BIRCH');

# Self Join

## Exercise 5.1
select c.first_name, c.last_name, a.address, ct.city
from customer c
         inner join address a on c.address_id = a.address_id
         inner join city ct on a.city_id = ct.city_id
where a.district = 'California';

## Exercise 5.2
select film.title
from film
         inner join film_actor on film.film_id = film_actor.film_id
         inner join actor on film_actor.actor_id = actor.actor_id
where actor.first_name = 'John';

## Exercise 5.3
select a1.address, a2.address, a1.city_id
from address a1
         inner join address a2 on a1.city_id = a2.city_id
where a1.address
          < a2.address;


select 1 num, 'abc' str
union
select 9 num, 'xyz' str;

