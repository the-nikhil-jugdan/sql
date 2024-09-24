set autocommit = 0;

# Exercise 12-1

start transaction

insert into transaction (txn_date, account_id, txn_type_cd) values ('2019-05-15', 123, 'C');
update account set avail_balance = avail_balance - 50 where account_id = 123;

insert into transaction (txn_date, account_id, txn_type_cd) values ('2019-05-15', 789, 'D');
update account set avail_balance = avail_balance + 50 where account_id = 789;

commit
