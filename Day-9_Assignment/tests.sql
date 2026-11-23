USE telecom_low_balance;
-- TASK 2: Successful recharge. Expected balance 180 on a fresh setup.
CALL sp_recharge(103,1,100,@new_balance);
SELECT @new_balance AS new_balance;
SELECT * FROM recharge_history WHERE subscriber_id=103;
-- TASK 5: Run the next CALL statements individually: errors are intentional.
CALL sp_recharge(103,1,-10,@new_balance); -- amount error
CALL sp_recharge(103,999,100,@new_balance); -- invalid plan
CALL sp_recharge(103,1,200,@new_balance); -- amount mismatch
CALL sp_recharge(104,1,100,@new_balance); -- postpaid not allowed
CALL sp_recharge(999,1,100,@new_balance); -- nonexistent subscriber
-- Verify unchanged balance and history after rejected calls.
SELECT balance FROM subscribers WHERE subscriber_id=103;
SELECT COUNT(*) AS history_count FROM recharge_history WHERE subscriber_id=103;
