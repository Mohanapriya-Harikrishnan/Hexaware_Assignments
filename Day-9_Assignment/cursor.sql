USE telecom_low_balance;
-- TASK 4: Cursor and equivalent set-based insert.
DROP PROCEDURE IF EXISTS sp_notify_cursor;
DELIMITER //
CREATE PROCEDURE sp_notify_cursor()
BEGIN
    DECLARE v_id INT;
    DECLARE done BOOLEAN DEFAULT FALSE;
    DECLARE cur CURSOR FOR SELECT subscriber_id FROM subscribers WHERE account_type='PREPAID' AND balance<50;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=TRUE;
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO v_id;
        IF done THEN LEAVE read_loop; END IF;
        INSERT INTO notifications(subscriber_id,message,method) VALUES(v_id,'Low balance: please recharge','CURSOR');
    END LOOP;
    CLOSE cur;
END //
DELIMITER ;
DROP PROCEDURE IF EXISTS sp_notify_set;
DELIMITER //
CREATE PROCEDURE sp_notify_set()
BEGIN
    INSERT INTO notifications(subscriber_id,message,method)
    SELECT subscriber_id,'Low balance: please recharge','SET_BASED'
    FROM subscribers WHERE account_type='PREPAID' AND balance<50;
END //
DELIMITER ;
-- Benchmark both methods on identical data; rollback each timed run.
-- Both measurements include procedure execution and commit is excluded.
DROP PROCEDURE IF EXISTS sp_compare_timing;
DELIMITER //
CREATE PROCEDURE sp_compare_timing()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE t DATETIME(6);
    DECLARE c BIGINT DEFAULT 0;
    DECLARE s BIGINT DEFAULT 0;
    WHILE i<20 DO
        START TRANSACTION;
        SET t=SYSDATE(6);
        CALL sp_notify_cursor();
        SET c=c+TIMESTAMPDIFF(MICROSECOND,t,SYSDATE(6));
        ROLLBACK;
        START TRANSACTION;
        SET t=SYSDATE(6);
        CALL sp_notify_set();
        SET s=s+TIMESTAMPDIFF(MICROSECOND,t,SYSDATE(6));
        ROLLBACK;
        SET i=i+1;
    END WHILE;
    SELECT 20 AS trials,c/20 AS cursor_avg_us,s/20 AS insert_select_avg_us,
    CASE WHEN c>s THEN 'INSERT SELECT' WHEN c<s THEN 'CURSOR' ELSE 'TIE' END AS faster_method;
END //
DELIMITER ;
-- Assumes default MySQL SYSDATE behavior (not --sysdate-is-now).
CALL sp_compare_timing();
-- Demo only: record both methods once to compare output.
CALL sp_notify_cursor();
CALL sp_notify_set();
SELECT method,COUNT(*) AS notification_count FROM notifications GROUP BY method;
SELECT subscriber_id,method,message FROM notifications ORDER BY subscriber_id,method;
