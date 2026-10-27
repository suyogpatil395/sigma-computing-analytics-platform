-- Optimised custom report: branch × channel performance with item mix.
-- Techniques: filter early, aggregate each grain separately (no fan-out),
-- join small aggregates instead of raw rows, let controls drive the range.
WITH bills AS (                         -- bill grain, filtered as early as possible
    SELECT order_id, branch_id, channel, net_amount, discount
    FROM orders
    WHERE status = 'completed'
      AND order_ts >= {{start-date}}            -- Date control (control id: start-date)
      AND order_ts <  {{end-date}}              -- Date control (control id: end-date)
),
bill_kpis AS (                          -- aggregate bills once
    SELECT branch_id, channel,
           COUNT(*)            AS orders,
           SUM(net_amount)     AS net_revenue,
           SUM(discount)       AS discount
    FROM bills
    GROUP BY branch_id, channel
),
item_kpis AS (                          -- aggregate lines separately: avoids double counting bills
    SELECT b.branch_id, b.channel,
           SUM(oi.qty)                                         AS items_sold,
           SUM(CASE WHEN oi.is_modifier = 1 THEN oi.qty END)   AS modifiers_sold
    FROM bills b
    JOIN order_items oi ON oi.order_id = b.order_id
    GROUP BY b.branch_id, b.channel
)
SELECT br.branch_name,
       k.channel,
       k.orders,
       k.net_revenue,
       ROUND(k.net_revenue / NULLIF(k.orders, 0), 2)          AS avg_order_value,
       ROUND(100.0 * k.discount / NULLIF(k.net_revenue + k.discount, 0), 1) AS discount_pct,
       i.items_sold,
       i.modifiers_sold
FROM bill_kpis k
JOIN branches br     ON br.branch_id = k.branch_id
LEFT JOIN item_kpis i ON i.branch_id = k.branch_id AND i.channel = k.channel
