# Analytic Function Concepts

## Data Windows

select quarter(payment_date)                                      quarter,
       monthname(payment_date)                                    month,
       sum(amount)                                                month_sales,
       max(sum(amount)) over ()                                   max_mnth_sales,
       max(sum(amount)) over (partition by quarter(payment_date)) max_qrtr_sales
from payment
where year(payment_date) = 2005
group by quarter(payment_date), monthname(payment_date);

## Localized sorting


select quarter(payment_date)                                      quarter,
       rank() over (order by sum(amount) desc),
       rank() over (partition by quarter(payment_date) order by sum(amount) desc),
       monthname(payment_date)                                    month_nm,
       month(payment_date),
       sum(amount)                                                month_sales,
       max(sum(amount)) over ()                                   max_mnth_sales,
       max(sum(amount)) over (partition by quarter(payment_date)) max_qrtr_sales
from payment
where year(payment_date) = 2005
group by quarter(payment_date), monthname(payment_date), month(payment_date)
order by 1, 3;

# Ranking

## Ranking Functions
select customer_id,
       count(*),
       row_number() over (order by count(*) desc) row_number_rank,
       rank() over (order by count(*) desc)       _rank,
       dense_rank() over (order by count(*) desc) _dense_rank
from rental
group by customer_id
order by 2 desc;


select customer_id,
       monthname(rental_date)      rental_month,
       count(*)                    num_rentals,
       rank() over (partition by monthname(rental_date)
           order by count(*) desc) rank_rank
from rental
group by customer_id, rental_month
order by 2, 3 desc;

select customer_id, rental_month, num_rentals, rank_rank as ranking
from (select customer_id,
             monthname(rental_date)      rental_month,
             count(*)                    num_rentals,
             rank() over (partition by monthname(rental_date)
                 order by count(*) desc) rank_rank
      from rental
      group by customer_id, rental_month
      order by 2, 3 desc) as subquery
where rank_rank <= 5
order by rental_month, num_rentals desc, ranking;

# Reporting Functions

select monthname(payment_date) as payment_month,
       amount,
       sum(amount)
           over (
               partition by monthname(payment_date)
               )               as monthly_total,
       sum(amount) over ()        grand_total
from payment;


select monthname(payment_date)                                as payment_month,
       sum(amount)                                               month_total,
       round(sum(amount) / sum(sum(amount)) over () * 100, 2) as pct_of_total
from payment
group by monthname(payment_date);

select monthname(payment_date),
       sum(amount) month_total,
       case sum(amount)
           when max(sum(amount)) over () then 'Highest'
           when min(sum(amount)) over () then 'Lowest'
           else 'Middle'
           end as  descriptor
from payment
group by monthname(payment_date);

## Window Frames
select yearweek(payment_date) as payment_week,
       sum(amount)            as week_total,
       sum(sum(amount)) over (
           order by yearweek(payment_date)
           rows unbounded preceding
           )                  as rolling_sum
from payment
group by yearweek(payment_date);

select yearweek(payment_date) as payment_week,
       sum(amount)            as week_total,
       avg(sum(amount)) over (
           order by yearweek(payment_date)
           rows between 1 preceding and 1 following
           )                     rolling_3wk_avg
from payment
group by yearweek(payment_date)
order by 1;

select date(payment_date),
       sum(amount),
       avg(sum(amount)) over (order by date(payment_date)
           range between interval 3 day preceding
               and interval 3 day following
           ) 7_day_avg
from payment
where payment_date between '2005-07-01' and '2005-09-01'
group by date(payment_date)
order by 1;

## Lag and Lead
select yearweek(payment_date)                   payment_week,
       sum(amount) as                           week_total,
       lag(
               sum(amount), 1
       ) over (order by yearweek(payment_date)) prev_week_total,
       lead(
               sum(amount), 1
       ) over (order by yearweek(payment_date)) next_week_total
from payment
group by yearweek(payment_date);

select yearweek(payment_date) as payment_week,
       sum(amount)            as week_total,
       round(
               (sum(amount) - lag(sum(amount), 1)
                                  over (order by yearweek(payment_date)))
                   / lag(sum(amount), 1) over (order by yearweek(payment_date)) * 100, 1
       )                         percent_diff
from payment
group by yearweek(payment_date);

# Exercise

-- Create the table
CREATE TABLE Sales_Fact
(
    year_no   INT,
    month_no  INT,
    tot_sales DECIMAL(10, 2)
);

-- Insert data into the table
INSERT INTO Sales_Fact (year_no, month_no, tot_sales)
VALUES (2019, 1, 19228.00),
       (2019, 2, 18554.00),
       (2019, 3, 17325.00),
       (2019, 4, 13221.00),
       (2019, 5, 9964.00),
       (2019, 6, 12658.00),
       (2019, 7, 14233.00),
       (2019, 8, 17342.00),
       (2019, 9, 16853.00),
       (2019, 10, 17121.00),
       (2019, 11, 19095.00),
       (2019, 12, 21436.00),
       (2020, 1, 20347.00),
       (2020, 2, 17434.00),
       (2020, 3, 16225.00),
       (2020, 4, 13853.00),
       (2020, 5, 14589.00),
       (2020, 6, 13248.00),
       (2020, 7, 8728.00),
       (2020, 8, 9378.00),
       (2020, 9, 11467.00),
       (2020, 10, 13842.00),
       (2020, 11, 15742.00),
       (2020, 12, 18636.00);


## Exercise 16-1

select year_no, month_no, tot_sales, rank() over (order by tot_sales desc)
from Sales_Fact;

## Exercise 16-2

select year_no, month_no, tot_sales, rank() over (partition by year_no order by tot_sales desc)
from Sales_Fact;

## Exercise 16-3

select year_no, month_no, tot_sales, lag(tot_sales, 1) over () prev_month_total
from Sales_Fact
where year_no = 2020;

