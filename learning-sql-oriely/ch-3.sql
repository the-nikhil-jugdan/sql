select *
from language;

select language_id, name, last_update
from language;

select name
from language;

select language_id, 'COMMON' as language_usage, language_id * 3.14 as lang_pi_value, upper(name) as language_name
from language;

select version(), user(), database();


select actor_id
from film_actor
order by actor_id;

select distinct actor_id
from film_actor
order by actor_id;

select concat(cust.last_name, ',', cust.first_name) as full_name
from (select first_name, last_name, email
      from customer
      where first_name = 'JESSIE') as cust;

create temporary table actors_j
(
    actor_id   smallint(5),
    first_name varchar(45),
    last_name  varchar(45)
);

insert into actors_j (select actor_id, first_name, last_name
                      from actor
                      where last_name like 'J%');

select *
from actors_j;

create view cust_vw as
select customer_id, first_name, last_name, active
from customer;

select *
from cust_vw
where active = 0;

select customer.first_name, customer.last_name, time(rental.rental_date)
from customer
         inner join rental on customer.customer_id = rental.customer_id
where date(rental.rental_date) = '2005-06-14';


select c.first_name, c.last_name, time(r.rental_date)
from customer as c
         inner join rental as r on c.customer_id = r.customer_id
where date(r.rental_date) = '2005-06-14';


select title
from film
where rating = 'G'
  and rental_duration >= 7;

select title
from film
where (rating = 'G'
    and rental_duration >= 7)
   or (
    rating = 'PG-13' and rental_duration < 4
    );


select first_name, last_name, count(*)
from customer
         inner join rental on customer.customer_id = rental.customer_id
group by first_name, last_name
having count(*) >= 40;

select first_name, last_name, time(rental_date) as rental_time
from customer
         inner join rental on customer.customer_id = rental.customer_id
where date(rental_date) = '2005-06-14'
order by last_name, first_name;


select first_name, last_name, time(rental_date) as rental_time
from customer
         inner join rental on customer.customer_id = rental.customer_id
where date(rental_date) = '2005-06-14'
order by rental_time desc;

# Exercise 3.1
# a

select actor_id, first_name, last_name
from actor
order by last_name;

# b
select actor_id, first_name, last_name
from actor
order by first_name;

# Exercise 3.2
#a
select actor_id, first_name, last_name
from actor
where last_name = 'Williams'
   or last_name = 'Davis';

# Exercise 3.3
select customer.customer_id
from customer
         inner join rental on customer.customer_id = rental.customer_id
where date(rental_date) = '2005-07-05';

# Exercise 3.4
select customer.email, rental.return_date
from customer
         inner join rental on customer.customer_id = rental.customer_id
where date(rental_date) = '2005-06-14'
order by rental.return_date desc;
