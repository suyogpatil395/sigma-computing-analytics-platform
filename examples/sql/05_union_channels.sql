-- The SQL equivalent of a Sigma Union element: same-shaped sources stacked.
-- (In the UI: Add element → Table → Union, match columns, Done. Sigma uses UNION ALL.)
SELECT 'Aggregator' AS source, order_id, branch_id, order_ts, net_amount FROM aggregator_orders
UNION ALL
SELECT 'In-store'   AS source, order_id, branch_id, order_ts, net_amount FROM pos_orders
