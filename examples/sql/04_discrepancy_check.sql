-- Feeds a conditional alert: "If there's data" → something doesn't reconcile.
-- Compares yesterday's POS bills with what the reporting model shows, per branch.
WITH pos AS (
    SELECT branch_id, COUNT(*) AS pos_orders, SUM(net_amount) AS pos_revenue
    FROM pos_orders_raw
    WHERE order_date = CURDATE() - INTERVAL 1 DAY AND status = 'completed'
    GROUP BY branch_id
),
rpt AS (
    SELECT branch_id, COUNT(*) AS report_orders, SUM(net_amount) AS report_revenue
    FROM orders
    WHERE order_ts >= CURDATE() - INTERVAL 1 DAY AND order_ts < CURDATE() AND status = 'completed'
    GROUP BY branch_id
)
SELECT b.branch_name,
       p.pos_orders, r.report_orders,
       p.pos_revenue, r.report_revenue,
       p.pos_orders - COALESCE(r.report_orders, 0) AS missing_orders
FROM pos p
LEFT JOIN rpt r ON r.branch_id = p.branch_id
JOIN branches b ON b.branch_id = p.branch_id
WHERE p.pos_orders <> COALESCE(r.report_orders, 0)
   OR ABS(p.pos_revenue - COALESCE(r.report_revenue, 0)) > 1
