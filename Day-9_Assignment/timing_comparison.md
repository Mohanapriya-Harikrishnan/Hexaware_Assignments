# Task 4 – Cursor versus INSERT ... SELECT

Both methods insert one notification per prepaid subscriber with balance strictly below 50. Initially the eligible IDs are 101, 102 and 105. Postpaid 104 and balance-50 subscriber 106 are excluded.

| Criterion | Cursor | INSERT ... SELECT |
|---|---|---|
| Approach | Fetch and insert row by row | Single set-based statement |
| Expected rows per demo | 3 | 3 |
| Average elapsed time (microseconds) | Run benchmark to obtain | Run benchmark to obtain |
| Best use | Individual procedural logic | Bulk operations |

Run `CALL sp_compare_timing();` in MySQL. The output reports average wall-clock microseconds for 20 runs of each method and the observed winner. Each run rolls back inserts, maintaining the same input and logical output size. Transaction setup and rollback are outside the measured interval. This assumes standard SYSDATE behavior. Auto-increment gaps can occur after rollback. Small samples are sensitive to timer resolution, caching and server load; the cursor is always timed first in each pair, which may bias results. No measured timings are claimed because a MySQL server was not available for validation here.

Expected conclusion: INSERT ... SELECT generally scales better because it avoids repeated procedural fetches and inserts. Use the actual measured winner in your submission. The two demo calls intentionally create separate notification rows for comparison; a production scheduler should choose one method and implement deduplication.
