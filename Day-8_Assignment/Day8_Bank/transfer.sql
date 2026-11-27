-- Day 8 - Bank Funds Transfer
create database if not exists day8_bank;
use day8_bank;
set autocommit = 1;
drop procedure if exists transfer_funds;
drop table if exists bank_entry;
drop table if exists account;

create table account (
    account_id int primary key,
    holder_name varchar(50) not null,
    balance decimal(12,2) not null check (balance >= 0),
    status varchar(10) not null check (status in ('Active','Frozen','Closed'))
) engine=InnoDB;

create table bank_entry (
    entry_id int auto_increment primary key,
    account_id int not null,
    entry_date datetime not null default current_timestamp,
    description varchar(40) not null,
    amount decimal(12,2) not null,
    balance_after decimal(12,2) not null,
    foreign key (account_id) references account(account_id)
) engine=InnoDB;

insert into account values
(101,'Anu',10000,'Active'),(102,'Ravi',5000,'Active'),
(103,'Meena',3000,'Frozen');
insert into bank_entry (account_id,description,amount,balance_after)
select account_id,'Opening balance',balance,balance from account;

-- Task 1: validate and transfer. Lock accounts in ID order.
-- Task 2: optional deliberate failure after debit.
-- Task 3: optional reversal of fee only.
delimiter //
create procedure transfer_funds(
    in p_from int, in p_to int, in p_amount decimal(12,2),
    in p_fail boolean, in p_undo_fee boolean
)
begin
    declare v_low decimal(12,2) default null;
    declare v_high decimal(12,2) default null;
    declare v_low_status varchar(10);
    declare v_high_status varchar(10);
    declare v_balance decimal(12,2);
    declare v_message varchar(128);
    declare exit handler for sqlexception
    begin
        get diagnostics condition 1 v_message = message_text;
        rollback;
        select 'Rolled back' as result, v_message as reason;
    end;

    start transaction;
    if p_from is null or p_to is null or p_from = p_to
       or p_amount is null or p_amount <= 0 then
        signal sqlstate '45000' set message_text = 'Invalid transfer details';
    end if;

    select balance, status into v_low, v_low_status
    from account where account_id = least(p_from,p_to) for update;
    select balance, status into v_high, v_high_status
    from account where account_id = greatest(p_from,p_to) for update;

    if v_low is null or v_high is null then
        signal sqlstate '45000' set message_text = 'Account not found';
    end if;
    if v_low_status <> 'Active' or v_high_status <> 'Active' then
        signal sqlstate '45000' set message_text = 'Both accounts must be active';
    end if;
    set v_balance = if(p_from < p_to,v_low,v_high);
    if v_balance < p_amount then
        signal sqlstate '45000' set message_text = 'Insufficient balance';
    end if;

    update account set balance = balance - p_amount where account_id = p_from;
    insert into bank_entry (account_id,description,amount,balance_after)
    select account_id,'Transfer debit',-p_amount,balance from account where account_id = p_from;

    if p_fail then
        select 'After debit, before rollback' as stage, account_id,balance
        from account where account_id in (p_from,p_to) order by account_id;
        signal sqlstate '45000' set message_text = 'Simulated failure after debit';
    end if;

    update account set balance = balance + p_amount where account_id = p_to;
    insert into bank_entry (account_id,description,amount,balance_after)
    select account_id,'Transfer credit',p_amount,balance from account where account_id = p_to;

    if p_undo_fee then
        savepoint before_fee;
        if v_balance - p_amount >= 50 then
            update account set balance = balance - 50 where account_id = p_from;
            insert into bank_entry (account_id,description,amount,balance_after)
            select account_id,'Transfer fee',-50,balance from account where account_id = p_from;
            select 'Fee posted temporarily' as stage, balance from account where account_id = p_from;
            rollback to savepoint before_fee;
            select 'Fee reversed' as stage, balance from account where account_id = p_from;
        else
            select 'Fee skipped: insufficient remaining balance' as stage;
        end if;
        release savepoint before_fee;
    end if;
    commit;
    select 'Transfer committed' as result;
end //
delimiter ;

-- Successful transfer: 101 = 8000, 102 = 7000.
call transfer_funds(101,102,2000,false,false);
select * from account order by account_id;

-- Rollback evidence: compare these two result sets.
select 'Before failure' as stage, account_id,balance from account order by account_id;
call transfer_funds(101,102,1000,true,false);
select 'After rollback' as stage, account_id,balance from account order by account_id;
-- Expected: 8000 and 7000 before and after; temporary debit = 7000.

-- Savepoint: transfer 500, temporarily charge 50, reverse fee.
call transfer_funds(101,102,500,false,true);
select * from account order by account_id;
-- Expected: 7500 and 7500; temporary fee balance = 7450.

-- Validation tests (no balance changes).
call transfer_funds(101,102,99999,false,false);
call transfer_funds(101,103,100,false,false);
call transfer_funds(101,999,100,false,false);
select * from account order by account_id;
select * from bank_entry order by entry_id;
-- Expected: 7 entries (3 opening + 4 successful transfer entries).
