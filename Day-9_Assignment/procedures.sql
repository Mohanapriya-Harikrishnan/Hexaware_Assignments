USE telecom_low_balance;
-- TASK 2: Validate amount, plan and subscriber; update and log atomically.
DROP PROCEDURE IF EXISTS sp_recharge;
DELIMITER //
CREATE PROCEDURE sp_recharge(IN p_subscriber INT, IN p_plan INT, IN p_amount DECIMAL(10,2), OUT p_new_balance DECIMAL(12,2))
BEGIN
    DECLARE v_price DECIMAL(10,2) DEFAULT NULL;
    DECLARE v_days INT;
    DECLARE v_balance DECIMAL(12,2) DEFAULT NULL;
    DECLARE v_type VARCHAR(10);
    -- TASK 5: Handle SQL errors and propagate the original error.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_new_balance=NULL;
        RESIGNAL;
    END;
    SET p_new_balance=NULL;
    START TRANSACTION;
    IF p_amount IS NULL OR p_amount <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Recharge amount must be positive';
    END IF;
    SELECT MAX(amount),MAX(validity_days) INTO v_price,v_days FROM plans WHERE plan_id=p_plan;
    IF v_price IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Invalid recharge plan';
    END IF;
    IF p_amount <> v_price THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Amount must match plan price';
    END IF;
    BEGIN
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_balance=NULL;
        SELECT balance,account_type INTO v_balance,v_type FROM subscribers WHERE subscriber_id=p_subscriber FOR UPDATE;
    END;
    IF v_balance IS NULL OR v_type <> 'PREPAID' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Invalid prepaid subscriber';
    END IF;
    UPDATE subscribers SET balance=balance+p_amount,
        validity_end=DATE_ADD(GREATEST(validity_end,CURRENT_DATE),INTERVAL v_days DAY)
    WHERE subscriber_id=p_subscriber;
    INSERT INTO recharge_history(subscriber_id,plan_id,amount) VALUES(p_subscriber,p_plan,p_amount);
    SELECT balance INTO p_new_balance FROM subscribers WHERE subscriber_id=p_subscriber;
    COMMIT;
END //
DELIMITER ;
-- TASK 3: Remaining validity, with expired validity shown as zero.
DROP FUNCTION IF EXISTS fn_validity_days_left;
DELIMITER //
CREATE FUNCTION fn_validity_days_left(p_validity_end DATE)
RETURNS INT NOT DETERMINISTIC NO SQL
BEGIN
    RETURN GREATEST(DATEDIFF(p_validity_end,CURRENT_DATE),0);
END //
DELIMITER ;
SELECT subscriber_id,subscriber_name,fn_validity_days_left(validity_end) AS days_left FROM vw_prepaid_subscribers;

