# String fields
create table string_tbh
(
    char_fld  char(30),
    vchar_fld varchar(30),
    text_fld  text
);

# String Generation

## Simplest way to populate
insert into string_tbh
values ('This is char data', 'This is varchar data', 'This is text data');

## Too long string
update string_tbh
set vchar_fld = 'This is extremely long piece of varchar data';

## Turn on ANSI mode to allow for string truncation

select @@session.sql_mode;

set sql_mode = 'ANSI';

select @@session.sql_mode;

update string_tbh
set vchar_fld = 'This is extremely long piece of varchar data';

select *
from string_tbh;

# Including Single Quotes

update string_tbh
set text_fld = 'This string doesn't work;

## Escale single quotes

update string_tbh
set text_fld = 'This string didn''t work but it works now';

select *
from string_tbh;

update string_tbh
set text_fld = 'This string didn\'t work but it works now';

select *
from string_tbh;

## Getting data with escaped string
select quote(string_tbh.text_fld)
from string_tbh;

# Including Special Characters
select char(128, 129, 130, 131, 132, 133, 134, 135, 136, 137);

## Using concat to generate string
select concat('danke sch', char(148), 'n');

## Getting the ASCII equivalent of a char
select ascii('ö');

# String Manipulation

insert into string_tbh (char_fld, vchar_fld, text_fld)
values ('This string is 28 characters',
        'This string is 28 characters',
        'This string is 28 characters');

select *
from string_tbh;

## String functions that return numbers
select length(char_fld), length(vchar_fld), length(text_fld)
from string_tbh;

select position('characters' in string_tbh.vchar_fld)
from string_tbh;


select locate('characters', vchar_fld, 5)
from string_tbh;

delete
from string_tbh;

insert into string_tbh(vchar_fld)
values ('abcd'),
       ('xyz'),
       ('QRSTUV'),
       ('qrstuv'),
       ('12345');

select vchar_fld
from string_tbh
order by vchar_fld;

select strcmp('12345', '12345')   12345_12345,
       strcmp('abcd', 'xyz')      abcd_xyz,
       strcmp('abcd', 'QRSTUV')   abcd_QRSTUV,
       strcmp('qrstuv', 'QRSTUV') qrstuv_QRSTUV,
       strcmp('12345', 'xyz')     12345_xyz,
       strcmp('xyz', 'qrstuv')    xyz_qrstuv;

select name, name like '%y' ends_in_y
from category
order by ends_in_y desc;

select name, name regexp 'y$' ends_in_y
from category
order by ends_in_y desc;

## String Functions that return Strings

delete
from string_tbh;

insert into string_tbh (text_fld)
values ('This string was 29 characters');

update string_tbh
set text_fld = concat(text_fld, ' , but now it is longer');

select string_tbh.text_fld
from string_tbh;

select concat(first_name, ' ', last_name, ' has been a customer since ', date(create_date)) as customer_narrative
from customer;

select insert('goodbye world', 9, 0, 'cruel ');
select insert('goodbye world', 1, 7, 'hello');

select substring('goodbye cruel world', 9, 5);

# Working with Numeric Data
-- Main concern when storing numeric data is that
-- numbers might be rounded if they are larger than
-- the specified precision of the column

## Performing Arithmetic Functions

select mod(10, 4);
-- In mysql, mod can be used with real numbers too
select mod(22.75, 5);

select pow(2, 8);

## Controlling number precision
select ceil(72.445), floor(72.445);

select ceil(72.000000001), floor(72.999999999);

--
SELECT round(72.000000001), round(72.999999999), round(72.50001);

-- Round can also preserve decimal places
select round(72.0909, 1), round(72.0909, 2), round(72.0909, 3);

-- Truncate, doesn't round
select truncate(72.0909, 1), truncate(72.0909, 2), truncate(72.0909, 3);

-- Truncate and round work with negative arguments to round the left side of the number
select round(17, −1), truncate(17, −1);

## Handling singed data
select sign(-72), abs(-72);

# Handling Temporal Data

## Dealing with TimeZones
select @@global.time_zone, @@session.time_zone;
SET time_zone = 'Europe/Zurich';
select @@global.time_zone, @@session.time_zone;

## String representation of Temporal Data
update rental
set return_date = '2019-09-17 15:30:00'
where rental_id = 9999;

## String to Date Conversions
select cast('2019-09-17 15:30:00' as datetime);

select cast('2019-09-17' as date) date_field, cast('108:17:57' as time) time_field;

## Functions for Generating Dates

-- str_to_date()
update rental
set return_date = str_to_date('September 17, 2019', '%M %d, %Y')
where rental_id = 9999;

-- current date
select current_date(), current_time(), current_timestamp();

## Manipulating Temporal Data

-- Temporal Functions that return dates
select date_add(current_date(), interval 15 day);

update rental
set return_date = date_add(return_date, interval '3:27:11' hour_second)
where rental_id = 9999;

select last_day('2019-09-17');

-- Temporal Functions that return Strings

select dayname('2019-09-18');

select extract(year from '2019-09-18 22:19:05');

-- Temporal Functions that return Numbers

select datediff(
               '2019-09-03',
               '2019-06-21'
       );

select datediff(
               '2019-06-21',
               '2019-09-03'
       );

# Conversion Functions
select cast('1456328' as signed integer);

select cast('999abc111' as unsigned integer);

show warnings;

# Exercises

## Exercise 7.1

select substring('Please find the substring in this string', 17, 25);

## Exercise 7.2

select sign(-25.76823), abs(-25.76823), round(-25.76823, 2);

## Exercise 7.2

select extract(month from current_date())
