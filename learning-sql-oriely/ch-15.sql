# Information Schema

select table_name, table_type
from information_schema.tables
where table_schema = 'sakila'
order by 1;

-- To get only tables and not views

select table_name, table_type
from information_schema.tables
where table_schema = 'sakila'
  and table_type = 'BASE TABLE'
order by 1;

-- To query views

select table_name, is_updatable
from information_schema.views
where table_schema = 'sakila'
order by 1;

-- Column Information for tables and views

select column_name, data_type, character_maximum_length, numeric_precision, numeric_scale
from information_schema.columns
where table_schema = 'sakila'
  and table_name = 'film'
order by ordinal_position;

-- To get information about a table's indexes

select index_name,
       non_unique,
       seq_in_index,
       column_name
from information_schema.statistics
where table_schema = 'sakila'
  and table_name = 'rental'
order by 1, 3;

-- To get constraints data

select constraint_name,
       table_name,
       constraint_type
from information_schema.table_constraints
where table_schema = 'sakila'
order by 3, 1;

# Working with metadata

## Schema Generation Scripts

select concat(
               ' ', column_name,
               ' ', column_type,
               case
                   when is_nullable = 'NO' then ' not null'
                   else ''
                   end,
               case
                   when extra is not null and extra like 'DEFAULT_GENERATED%' then
                       concat(
                               ' DEFAULT', column_default, substr(extra, 18)
                       )
                   when extra is not null then concat(' ', extra)
                   else ''
                   end, ','
       ) txt
from information_schema.columns
where table_schema = 'sakila'
  and table_name = 'category'
order by ordinal_position;

select concat(' constraint primary key (')
from information_schema.table_constraints
where table_schema = 'sakila'
  and table_name = 'category'
  and constraint_type = 'PRIMARY KEY';

select (select concat(case when ordinal_position > 1 then ' ,' else ' ' end, column_name)) txt
from information_schema.key_column_usage
where table_schema = 'sakila'
  and table_name = 'category'
  and constraint_name = 'PRIMARY'
order by ordinal_position;

select 'create table category(' create_table_statement
union all
select cols.txt
from (select concat(
                     ' ', column_name,
                     ' ', column_type,
                     case
                         when is_nullable = 'NO' then ' not null'
                         else ''
                         end,
                     case
                         when extra is not null and extra like 'DEFAULT_GENERATED%' then
                             concat(
                                     ' DEFAULT', column_default, substr(extra, 18)
                             )
                         when extra is not null then concat(' ', extra)
                         else ''
                         end, ','
             ) txt
      from information_schema.columns
      where table_schema = 'sakila'
        and table_name = 'category'
      order by ordinal_position) cols
union all
select concat(' constraint primary key (')
from information_schema.table_constraints
where table_schema = 'sakila'
  and table_name = 'category'
  and constraint_type = 'PRIMARY KEY'
union all
select cols2.txt
from (select (select concat(case when ordinal_position > 1 then ' ,' else ' ' end, column_name)) txt
      from information_schema.key_column_usage
      where table_schema = 'sakila'
        and table_name = 'category'
        and constraint_name = 'PRIMARY'
      order by ordinal_position) cols2
union all
select ')';

## Deployment Verification

select tbl.table_name,
       (select count(*)
        from information_schema.columns clm
        where clm.table_schema = tbl.table_schema
          and clm.table_name = tbl.table_name)    num_columns,
       (select count(*)
        from information_schema.statistics sta
        where sta.table_schema = tbl.table_schema
          and sta.table_name = tbl.table_name)    num_indexes,
       (select count(*)
        from information_schema.table_constraints tc
        where tc.table_schema = tbl.table_schema
          and tc.table_name = tbl.table_name
          and tc.constraint_type = 'PRIMARY KEY') num_primary_keys
from information_schema.tables tbl
order by 1;

## Dynamic SQL Generation
set @qry = 'select customer_id,first_name, last_name from customer';

prepare dynsql1 from @qry;

execute dynsql1;

deallocate prepare dynsql1;

set @qry = 'select * from customer where customer_id = ?';

prepare dynsql2 from @qry;

set @cust_id = 9;

execute dynsql2 using @cust_id;

-- Not working for some reason

# Exercises
describe information_schema.statistics;

## Exercise 15-1
select index_name, table_name
from information_schema.statistics
where index_schema = 'sakila';

## Exercise 15-2
select 'alter table customer '
union all
select (select concat('add index', index_name, ' ', column_name))
from information_schema.statistics
where index_schema = 'sakila'
  and table_name = 'customer'
union all
select ';'


