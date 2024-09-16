# Union all

select 'CUST' typ, first_name, last_name
from customer;

select 'ACT' typ, first_name, last_name
from actor;

select 'CUST' typ, c.first_name, c.last_name
from customer c
union all
select 'ACT' typ, a.first_name, a.last_name
from actor a;

select first_name, last_name
from actor
union all
select first_name, last_name
from actor;

## Seeing Duplicate data IRL

select first_name, last_name
from customer
where customer.first_name like 'J%'
  and customer.last_name like 'D%'
union all
select first_name, last_name
from actor
where actor.first_name like 'J%'
  and actor.last_name like 'D%';

# Union operator

select first_name, last_name
from customer
where customer.first_name like 'J%'
  and customer.last_name like 'D%'
union
select first_name, last_name
from actor
where actor.first_name like 'J%'
  and actor.last_name like 'D%';

# Intersect Operator
## This operator was not implemented in MySQL, but now is apparently

select first_name, last_name
from customer
where customer.first_name like 'J%'
  and customer.last_name like 'D%'
intersect
select first_name, last_name
from actor
where actor.first_name like 'J%'
  and actor.last_name like 'D%';

## Empty intersection
select first_name, last_name
from customer
where customer.first_name like 'D%'
  and customer.last_name like 'T%'
intersect
select first_name, last_name
from actor
where actor.first_name like 'D%'
  and actor.last_name like 'T%';


## Intersect all
### Doesn't seem to do much imo

select first_name, last_name
from customer
where customer.first_name like 'J%'
  and customer.last_name like 'D%'
intersect all
select first_name, last_name
from actor
where actor.first_name like 'J%'
  and actor.last_name like 'D%';

# Except Operator
## This operator was not implemented in MySQL, but now is apparently

select first_name, last_name
from actor
where actor.first_name like 'J%'
  and actor.last_name like 'D%'
except
select first_name, last_name
from customer
where customer.first_name like 'J%'
  and customer.last_name like 'D%';

## Except All
### Removes only one occurance of the duplicate data

# Set Operation Rules

## Sorting Compound Query Results

-- Can only use names from first query in order by clause
select actor.first_name afname, actor.last_name alname
from actor
where actor.first_name like 'J%'
  and actor.last_name like 'D%'
union all
select customer.first_name, customer.last_name
from customer
where customer.first_name like 'J%'
  and customer.last_name like 'D%'
order by afname, alname;

-- Set Operator Precedence
-- For more than 2 queries, we need to think about the order of operations

select first_name, last_name
from actor
where first_name like 'J%'
  and last_name like 'D%'
union all
select first_name, last_name
from actor
where first_name like 'M%'
  and last_name like 'T%'
union
select first_name, last_name
from customer
where first_name like 'J%'
  and last_name like 'D%';


select first_name, last_name
from actor
where first_name like 'J%'
  and last_name like 'D%'
union
select first_name, last_name
from actor
where first_name like 'M%'
  and last_name like 'T%'
union all
select first_name, last_name
from customer
where first_name like 'J%'
  and last_name like 'D%';

# Exercises

# Exercise 6-1

-- A = {L, M, N, O, P} B = {P, Q, R, S, T}
-- A union B = { L, M, N, O, P, Q, R, S, T }
-- A union all B = {L, M, N, O, P, P, Q, R, S, T}
-- A intersect B = {P}
-- A except B = {L, M, N, O}

# Exercise 6-2

select first_name, last_name
from actor
where last_name like 'L%'
union
select first_name, last_name
from customer
where last_name like 'L%';

# Exercise 6-3

select first_name, last_name
from actor
where last_name like 'L%'
union
select first_name, last_name
from customer
where last_name like 'L%'
order by last_name;
