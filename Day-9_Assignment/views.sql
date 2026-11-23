USE telecom_low_balance;
-- TASK 1: Hide postpaid accounts and private contact information.
CREATE OR REPLACE VIEW vw_prepaid_subscribers AS
SELECT subscriber_id, subscriber_name, balance, validity_end
FROM subscribers WHERE account_type='PREPAID';
CREATE OR REPLACE VIEW vw_recharge_summary AS
SELECT s.subscriber_id,s.subscriber_name,COUNT(r.recharge_id) AS recharge_count,
COALESCE(SUM(r.amount),0) AS total_recharged,MAX(r.recharged_at) AS last_recharge
FROM vw_prepaid_subscribers s LEFT JOIN recharge_history r ON s.subscriber_id=r.subscriber_id
GROUP BY s.subscriber_id,s.subscriber_name;
SELECT * FROM vw_prepaid_subscribers;
SELECT * FROM vw_recharge_summary;
