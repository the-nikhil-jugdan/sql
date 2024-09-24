## Index creation

alter table customer
    add index idx_email (email);

show index from customer;

-- Removing an index

alter table customer
    drop index idx_email;

## Unique Index

alter table customer
    add unique idx_email (email);

update customer
set email = 'ALAN.KHAN@sakilacustomer.org';


## Multicolumn Indexes

alter table customer
    add index idx_full_name (last_name, first_name);

# How Indexes are used

explain
select first_name, last_name
from customer
where first_name like 'S%'
  and last_name like 'P%';

# Constraints

## Creating a constraint
delete
from customer
where address_id = 123;

# Exercises

## Exercise 13-1
desc rental;

alter table rental
    add constraint fk_rental_customer_n foreign key (customer_id)
        references customer (customer_id) on delete restrict on update cascade;

delete
from customer;


alter table payment
    add index idx_customer_id_payment_date_amount (customer_id, payment_date, amount);

explain
select customer_id, payment_date, amount
from payment
where payment_date > cast('2019-12-31 23:59:59' as datetime);

explain
select customer_id, payment_date, amount
from payment
where payment_date > cast('2019-12-31 23:59:59' as datetime)
  and amount < 5;
