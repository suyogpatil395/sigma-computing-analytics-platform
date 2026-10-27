-- Feeds a conditional alert: "If a condition is met → Any value in column target_achieved is True".
-- Month-to-date revenue per branch against the monthly target (targets kept in an input table / warehouse table).
SELECT
    b.branch_name,
    t.monthly_target,
    SUM(o.net_amount)                                        AS mtd_revenue,
    ROUND(100.0 * SUM(o.net_amount) / t.monthly_target, 1)  AS pct_of_target,
    SUM(o.net_amount) >= t.monthly_target                    AS target_achieved
FROM orders o
JOIN branches b       ON b.branch_id = o.branch_id
JOIN branch_targets t ON t.branch_id = o.branch_id
                     AND t.month     = DATE_FORMAT(CURDATE(), '%Y-%m-01')
WHERE o.status = 'completed'
  AND o.order_ts >= DATE_FORMAT(CURDATE(), '%Y-%m-01')
GROUP BY b.branch_name, t.monthly_target
