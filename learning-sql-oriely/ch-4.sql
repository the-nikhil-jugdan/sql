# Equality Condition
select title, film_id
from film
where film_id = (select film_id from film where title = 'RIVER OUTLAW');

select customer.email
from customer
         inner join rental on customer.customer_id = rental.customer_id
where date(rental_date) = '2005-06-14';

# Inequality Condition
select customer.email
from customer
         inner join rental on customer.customer_id = rental.customer_id
where date(rental_date) != '2005-06-14';

# Delete data using equality conditions
delete
from rental
where year(rental_date) = 2004;

# Range Query
select customer_id, rental_date
from rental
where rental_date <= '2005-06-16'
  and rental_date >= '2005-06-14';

# Using between
select customer_id, rental_date
from rental
where rental_date between '2005-06-14' and '2005-06-16';

select customer_id, payment_date, amount
from payment
where amount between 10 and 11.99;

# String ranges
select first_name, last_name
from customer
where last_name between 'FA' and 'FR';

# Membership Conditions
select title, rating
from film
where rating = 'G'
   or rating = 'PG';

select title, rating
from film
where rating in ('G', 'PG');

# Using Subqueries
select rating
from film
where title like '%PET%';

select title, rating
from film
where rating in (select rating
                 from film
                 where title like '%PET%');

# Using not in
select title, rating
from film
where rating not in ('G', 'PG');

# Matching Conditions
select last_name, first_name
from customer
where left(last_name, 1) = 'Q';

# Using Wildcards
select last_name, first_name
from customer
where last_name like '_A_T%S';

select last_name, first_name
from customer
where last_name like 'Q%'
   or last_name like 'Y%';

select last_name, first_name
from customer
where last_name regexp '^[QY]';

# NULLS
select rental_id, customer_id
from rental
where return_date is null; -- = null will fail as two nulls are never equal

select rental_id, customer_id, return_date
from rental
where return_date is not null
limit 20;

select rental_id, customer_id, return_date
from rental
where return_date not between '2005-05-01' and '2005-09-01'; -- Not correct as it doesn't account for Nulls

select rental_id, customer_id, return_date
from rental
where return_date is null
   or return_date not between '2005-05-01' and '2005-09-01';

# Exercise

# Exercise 4-1
# Fetches all the payment ids where customer_id != 5 and either
# amount was more than 8 or the payment was made on '2005-08-23'

select customer_id, payment_id, payment_date, amount
from payment
where customer_id != 5
  and (amount > 8 or date(payment_date) = '2005-08-23');

# Exercise 4-2
# Fetches all the payment ids where customer_id = 5 and
# the amount <= 6 and the payment was not made on '2005-06-19'
select customer_id, payment_id, payment_date, amount
from payment
where customer_id = 5
  and not (amount > 6 or date(payment_date) = '2005-06-19');

# Exercise 4-3
select amount
from payment
where amount in (1.98, 7.98, 9.98);

# Exercise 4-4
select last_name
from customer
where last_name like '_A%W%';

