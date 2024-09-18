# Grouping Concepts

-- Ungrouped
select customer_id
from rental;

-- Grouped data

select customer_id, count(*)
from rental
group by customer_id
having count(*) >= 40
order by 2 desc;

# Aggregate Functions
select max(amount) max_amt,
       min(amount) min_amt,
       avg(amount) avg_amt,
       sum(amount) tot_amt,
       count(*)    num_payments
from payment;

-- Implicit vs Explicit Groups
-- The previous query has an implicit group of all rows in the table

-- Query with an explicit Group
select customer_id,
       max(amount) max_amt,
       min(amount) min_amt,
       avg(amount) avg_amt,
       sum(amount) tot_amt,
       count(*)    num_payments
from payment
group by customer_id
order by 4 desc;

-- Counting Distinct values
select count(customer_id) num_rows, count(distinct customer_id) num_customers
from payment;

-- Using Expressions
select max(datediff(return_date, rental_date))
from rental;

-- How Nulls are Handled

create table number_tbl
(
    val smallint
);

insert into number_tbl
values (1);
insert into number_tbl
values (3);
insert into number_tbl
values (5);

select count(*) num_rows, count(val) num_vals, sum(val) total, max(val) max_val, avg(val) avg_val
from number_tbl;

insert into number_tbl
values (null);

select count(*) num_rows, count(val) num_vals, sum(val) total, max(val) max_val, avg(val) avg_val
from number_tbl;

# Generating Groups

-- Single Column Grouping
select actor_id, count(*) as films
from film_actor
group by actor_id
order by 2 desc;


select actor.first_name, actor.last_name, fas.films
from actor
         left join (select actor_id, count(*) as films
                    from film_actor
                    group by actor_id) fas on actor.actor_id = fas.actor_id
order by 3 desc;

-- Multi Column grouping

select actor_id, rating, count(*) as films
from film_actor
         inner join film on film_actor.film_id = film.film_id
group by actor_id, rating
order by 1, 2;

-- Grouping Via Expressions
select extract(year from rental_date) as year, count(*) rentals
from rental
group by year;

-- Generating Rollups

select actor_id, rating, count(*) as films
from film_actor
         inner join film on film_actor.film_id = film.film_id
group by actor_id, rating
with rollup
order by 1, 2;

-- Can also use something called with cube, not in MySQL 8.0 though

# Group Filter Conditions

select actor_id, rating, count(*) as films
from film_actor
         inner join film on film_actor.film_id = film.film_id
where rating in ('G', 'PG')
group by actor_id, rating
having films > 9;

# Exercises

## Exercise 8-1
select count(*)
from payment;

## Exercise 8-2
select customer_id, count(*)
from payment
group by customer_id;

## Exercise 8-3
select customer_id, count(*) as payments_made
from payment
group by customer_id
having payments_made >= 5;

