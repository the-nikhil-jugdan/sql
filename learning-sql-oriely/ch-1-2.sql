# Creating tables
create table person
(
    person_id   smallint unsigned,
    fname       varchar(20),
    lname       varchar(20),
    eye_color   enum ('BR', 'BL', 'GR'),
    birth_date  date,
    street      varchar(30),
    city        varchar(20),
    country     varchar(20),
    postal_code varchar(20),
    constraint pk_person primary key (person_id)
);

# Describles a table
desc person;

create table favourite_food
(
    person_id smallint unsigned,
    food      varchar(20),
    # Adds a Primary Key constraint
    constraint pk_favourite_food primary key (person_id, food),
    # Add a Foreign Key constraint
    constraint fk_fav_food_person_id foreign key (person_id) references person (person_id)
);

desc favourite_food;

# Need to drop favourite_food table to make this command work
# Modifies column person_id
alter table person
    modify person_id smallint unsigned auto_increment;

# Insert data
insert into person
    (person_id, fname, lname, eye_color, birth_date)
values (null, 'William', 'Turner', 'BR', '1972-05-27');

# Select
select *
from person
where eye_color = 'BR';

insert into favourite_food
    (person_id, food)
values (1, 'pizza');
select *
from favourite_food;

insert into favourite_food
    (person_id, food)
values (1, 'cookies');

select *
from favourite_food;

insert into favourite_food
    (person_id, food)
values (1, 'nachos');

select *
from favourite_food;

select *
from favourite_food
where person_id = 1
order by food;

insert into person
(fname, lname, eye_color, birth_date, street, city, country, postal_code)
values ('Susan', 'Smith', 'BL', '1975-11-02', '23 Maple St.', 'Arlington', 'USA', '20220');

select *
from person;


# Update data in a table
update person
set street      = '1225 Tremont St.',
    city        = 'Boston',
    country     = 'USA',
    postal_code = '02138'
where person_id = 1;

# Deletes person with person_id = 2
delete
from person
where person_id = 2;

select *
from person;

# Won't work as person with person_id 1 already exists
insert into person
    (person_id, fname)
values (1, 'Error');

# Won't work as the person does not exist
insert into favourite_food
    (person_id, food)
values (2, 'GG');

# Won't work as the value is out of enum
update person
set eye_color = 'GG'
where person_id = 1;

# Specifies specific date format
update person
set birth_date = str_to_date('DEC-21-1990', '%b-%d-%Y')
where person_id = 1;

select *
from person;

show tables;

select *
from actor;

# Removes the tables favourite_food and person
drop table favourite_food;
drop table person;

desc customer;
