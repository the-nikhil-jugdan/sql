# Partitioning

## Table Paritioning
-- Horizontal and Vertical Partitioning

## Index Partitioning
-- Global Index vs Local Index

## Partitioning Methods

### Range Partitioning

create table sales
(
    sale_id   int  not null,
    cust_id   int  not null,
    store_id  int  not null,
    sale_date date not null,
    amount    decimal(9, 2)
)
    partition by range (yearweek(sale_date)) (
        partition s1 values less than (202002),
        partition s2 values less than (202003),
        partition s3 values less than (202004),
        partition s4 values less than (202005),
        partition s5 values less than (202006),
        partition s999 values less than (maxvalue)
        );

-- Getting metadata
select partition_name, partition_method, partition_expression
from information_schema.partitions
where table_name = 'sales'
order by partition_ordinal_position;

-- Modify partitioning
alter table sales
    reorganize partition s999 into (
        partition s6 values less than (202007),
        partition s7 values less than (202008),
        partition s999 values less than (maxvalue )
        );

-- Getting metadata
select partition_name, partition_method, partition_expression
from information_schema.partitions
where table_name = 'sales'
order by partition_ordinal_position;

insert into sales
values (1, 1, 1, '2020-01-18', 2765.15),
       (2, 3, 4, '2020-02-07', 5322.08);

-- See in which partition row data is stored
select concat('# of rows in s1 = ', count(*)) partition_rowcount
from sales partition (s1)
union all
select concat('# of rows in s2 = ', count(*)) partition_rowcount
from sales partition (s2)
union all
select concat('# of rows in s3 = ', count(*)) partition_rowcount
from sales partition (s3)
union all
select concat('# of rows in s4 = ', count(*)) partition_rowcount
from sales partition (s4)
union all
select concat('# of rows in s5 = ', count(*)) partition_rowcount
from sales partition (s5)
union all
select concat('# of rows in s6 = ', count(*)) partition_rowcount
from sales partition (s6)
union all
select concat('# of rows in s7 = ', count(*)) partition_rowcount
from sales partition (s7)
union all
select concat('# of rows in s999 = ', count(*)) partition_rowcount
from sales partition (s999);

### List Partitioning
drop table sales;
create table sales
(
    sale_id       int        not null,
    cust_id       int        not null,
    store_id      int        not null,
    sale_date     date       not null,
    geo_region_cd varchar(6) not null,
    amount        decimal(9, 2)
)
    partition by list columns (geo_region_cd)
        (partition northamerica values in ('us_ne','us_se','us_mw',
        'us_nw','us_sw','can','mex'),
        partition europe values in ('eur_e','eur_w'),
        partition asia values in ('chn','jpn','ind')
        );

insert into sales
values (1, 1, 1, '2020-01-18', 'US_NE', 2765.15);
insert into sales
values (2, 3, 4, '2020-02-07', 'CAN', 5322.08);
insert into sales
values (3, 6, 27, '2020-03-11', 'KOR', 4267.12);
-- Item 3 won't be inserted as KOR isn't defined in paritions
select *
from sales;

-- Need to alter table
alter table sales
    reorganize partition asia into (
        partition asia values in ('CHN', 'JPN', 'IND', 'KOR')
        );

-- Running for Korea now workds
insert into sales
values (3, 6, 27, '2020-03-11', 'KOR', 4267.12);
select *
from sales;

-- Verifying metadata

select partition_name,
       partition_expression,
       partition_description
from information_schema.partitions
where table_name = 'sales'
order by partition_ordinal_position;

### Hash Partitioning

drop table sales;

create table sales
(
    sale_id   int  not null,
    cust_id   int  not null,
    store_id  int  not null,
    sale_date date not null,
    amount    decimal(9, 2)
)
    partition by hash (cust_id)
        partitions 4
        (partition h1,
        partition h2,
        partition h3,
        partition h4
        );

insert into sales
values (1, 1, 1, '2020-01-18', 1.1),
       (2, 3, 4, '2020-02-07', 1.2),
       (3, 17, 5, '2020-01-19', 1.3),
       (4, 23, 2, '2020-02-08', 1.4),
       (5, 56, 1, '2020-01-20', 1.6),
       (6, 77, 5, '2020-02-09', 1.7),
       (7, 122, 4, '2020-01-21', 1.8),
       (8, 153, 1, '2020-02-10', 1.9),
       (9, 179, 5, '2020-01-22', 2.0),
       (10, 244, 2, '2020-02-11', 2.1),
       (11, 263, 1, '2020-01-23', 2.2),
       (12, 312, 4, '2020-02-12', 2.3),
       (13, 346, 2, '2020-01-24', 2.4),
       (14, 389, 3, '2020-02-13', 2.5),
       (15, 472, 1, '2020-01-25', 2.6),
       (16, 502, 1, '2020-02-14', 2.7);

-- Check hashing partition effectiveness

select concat('# of rows in h1 = ', count(*)) partition_rowcount
from sales partition (h1)
union all
select concat('# of rows in h2 = ', count(*)) partition_rowcount
from sales partition (h2)
union all
select concat('# of rows in h3 = ', count(*)) partition_rowcount
from sales partition (h3)
union all
select concat('# of rows in h4 = ', count(*)) partition_rowcount
from sales partition (h4);

### Composite Partitioning

drop table sales;

create table sales
(
    sale_id   int  not null,
    cust_id   int  not null,
    store_id  int  not null,
    sale_date date not null,
    amount    decimal(9, 2)
)
    partition by range (yearweek(sale_date))
        subpartition by hash (cust_id)
        (
        partition s1 values less than (202002)
            (subpartition s1_h1,
            subpartition s1_h2,
            subpartition s1_h3,
            subpartition s1_h4),
        partition s2 values less than (202003)
            (subpartition s2_h1,
            subpartition s2_h2,
            subpartition s2_h3,
            subpartition s2_h4),
        partition s3 values less than (202004)
            (subpartition s3_h1,
            subpartition s3_h2,
            subpartition s3_h3,
            subpartition s3_h4),
        partition s4 values less than (202005)
            (subpartition s4_h1,
            subpartition s4_h2,
            subpartition s4_h3,
            subpartition s4_h4),
        partition s5 values less than (202006)
            (subpartition s5_h1,
            subpartition s5_h2,
            subpartition s5_h3,
            subpartition s5_h4),
        partition s999 values less than (maxvalue)
            (subpartition s999_h1,
            subpartition s999_h2,
            subpartition s999_h3,
            subpartition s999_h4)
        );

insert into sales
values (1, 1, 1, '2020-01-18', 1.1),
       (2, 3, 4, '2020-02-07', 1.2),
       (3, 17, 5, '2020-01-19', 1.3),
       (4, 23, 2, '2020-02-08', 1.4),
       (5, 56, 1, '2020-01-20', 1.6),
       (6, 77, 5, '2020-02-09', 1.7),
       (7, 122, 4, '2020-01-21', 1.8),
       (8, 153, 1, '2020-02-10', 1.9),
       (9, 179, 5, '2020-01-22', 2.0),
       (10, 244, 2, '2020-02-11', 2.1),
       (11, 263, 1, '2020-01-23', 2.2),
       (12, 312, 4, '2020-02-12', 2.3),
       (13, 346, 2, '2020-01-24', 2.4),
       (14, 389, 3, '2020-02-13', 2.5),
       (15, 472, 1, '2020-01-25', 2.6),
       (16, 502, 1, '2020-02-14', 2.7);

-- Getting data from partition s3 and s3_h3

select *
from sales partition (s3);
select *
from sales partition (s3_h3);
