# Outer Joins

select film.film_id, title, count(*) as num_copies
from film
         inner join inventory on film.film_id = inventory.film_id
group by film.film_id, title;


-- With outer join
select film.film_id,
       title,
       count(inventory_id
       ) as num_copies
from film
         left outer join inventory on film.film_id = inventory.film_id
group by film.film_id, title;


-- Seeing the difference

select film.film_id,
       title,
       inventory_id
from film
         inner join inventory on film.film_id = inventory.film_id
where film.film_id between 13 and 15;


select film.film_id,
       title,
       inventory_id
from film
         left outer join inventory on film.film_id = inventory.film_id
where film.film_id between 13 and 15;

select film.film_id,
       title,
       inventory_id
from inventory
         right outer join film on film.film_id = inventory.film_id
where film.film_id between 13 and 15;

## Three Way outer joins

select film.film_id,
       title,
       inventory.inventory_id,
       rental_date
from film
         left outer join inventory on film.film_id = inventory.film_id
         left outer join rental on inventory.inventory_id = rental.inventory_id
where film.film_id between 13 and 15;


# Cross Joins
select category.name as category_name, language.name as language_name
from category
         cross join language;

-- Useful scenario for a cross join
-- To generate all days of 2020 year


with ones as (select 0 num
              union all
              select 1 num
              union all
              select 2 num
              union all
              select 3 num
              union all
              select 4 num
              union all
              select 5 num
              union all
              select 6 num
              union all
              select 7 num
              union all
              select 8 num
              union all
              select 9 num),
     tens as (select 0 num
              union all
              select 10 num
              union all
              select 20 num
              union all
              select 30 num
              union all
              select 40 num
              union all
              select 50 num
              union all
              select 60 num
              union all
              select 70 num
              union all
              select 80 num
              union all
              select 90 num),
     hundreds as (select 0 num
                  union all
                  select 100 num
                  union all
                  select 200 num
                  union all
                  select 300 num)
select date_add('2020-01-01', interval ones.num + tens.num + hundreds.num day)
from ones
         cross join tens
         cross join hundreds
where date_add('2020-01-01', interval ones.num + tens.num + hundreds.num day) < '2021-01-01'
order by 1;

-- Trying with using just ones
with ones as (select 0 num
              union all
              select 1 num
              union all
              select 2 num
              union all
              select 3 num
              union all
              select 4 num
              union all
              select 5 num
              union all
              select 6 num
              union all
              select 7 num
              union all
              select 8 num
              union all
              select 9 num)
select date_add('2020-01-01', interval ones.num + tens.num * 10 + hundreds.num * 100 day)
from ones
         cross join ones tens
         cross join ones hundreds
where date_add('2020-01-01', interval ones.num + tens.num * 10 + hundreds.num * 100 day) < '2021-01-01'
order by 1;

-- Rentals on each day in 2005
with ones as (select 0 num
              union all
              select 1 num
              union all
              select 2 num
              union all
              select 3 num
              union all
              select 4 num
              union all
              select 5 num
              union all
              select 6 num
              union all
              select 7 num
              union all
              select 8 num
              union all
              select 9 num)
select dt, count(rental_date)
from (select date_add('2005-01-01', interval ones.num + tens.num * 10 + hundreds.num * 100 day) dt
      from ones
               cross join ones tens
               cross join ones hundreds
      where date_add('2005-01-01', interval ones.num + tens.num * 10 + hundreds.num * 100 day) < '2006-01-01'
      order by 1) dates_2005
         left outer join rental on date(rental_date) = dates_2005.dt
group by dates_2005.dt
order by dates_2005.dt;

# Natural Joins

-- Doesn't work as natural join also tries to use column, last_updated
select first_name, last_name, date(rental_date)
from customer
         natural join rental;

-- Can work by restricting columns for one of the tables
select first_name, last_name, date(rental_date)
from (select customer_id, first_name, last_name from customer) cust
         natural join rental;

# Exercises

## Exercise 10-1

# select customer.name, sum(balance) from customer left outer join account on customer.customer_id = account.customer_id group by customer.customer_id;

## Exercise 10-2

# select customer.name, sum(balance) from account right outer join customer on customer.customer_id = account.customer_id group by customer.customer_id;

## Exercise 10-3

with ones as (select 0 num
              union all
              select 1 num
              union all
              select 2 num
              union all
              select 3 num
              union all
              select 4 num
              union all
              select 5 num
              union all
              select 6 num
              union all
              select 7 num
              union all
              select 8 num
              union all
              select 9 num)
select ones.num + tens.num * 10 + hundreds.num * 100 as number
from ones
         cross join ones tens
         cross join ones hundreds
where (ones.num + tens.num * 10 + hundreds.num * 100) between 1 and 100
order by 1;


