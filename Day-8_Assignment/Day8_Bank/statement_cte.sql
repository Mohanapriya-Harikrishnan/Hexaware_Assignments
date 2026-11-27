-- Task 4 - Monthly statement using CTE and window functions.

use day8_bank;
set @month_start = cast(date_format(current_date,'%Y-%m-01') as date);
set @month_end = date_add(@month_start, interval 1 month);

with balance_history as (
    select account_id, entry_id, entry_date, description, amount, balance_after,
           lag(balance_after,1,0) over (
               partition by account_id order by entry_date,entry_id
           ) as previous_balance
    from bank_entry
), monthly_statement as (
    select * from balance_history
    where entry_date >= @month_start and entry_date < @month_end
)
select account_id,
       row_number() over (partition by account_id order by entry_date,entry_id) as serial_no,
       entry_date, description, previous_balance, amount, balance_after
from monthly_statement
order by account_id,serial_no;

-- LAG is calculated before filtering the month, so the first entry
-- can refer to a balance from an earlier month. Opening balance starts at 0.
-- Expected for account 101: 0 -> 10000 -> 8000 -> 7500.
-- Expected for account 102: 0 -> 5000 -> 7000 -> 7500.
