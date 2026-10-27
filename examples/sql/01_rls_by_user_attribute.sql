-- Custom SQL element: each viewer only gets their own restaurant's rows.
-- The user attribute "restaurant" is set per user/team in Administration → User Attributes.
-- Sigma injects the running user's value at query time.
SELECT
    o.order_id,
    o.order_ts,
    r.restaurant_name,
    b.branch_name,
    o.channel,
    o.net_amount
FROM orders o
JOIN branches    b ON b.branch_id     = o.branch_id
JOIN restaurants r ON r.restaurant_id = b.restaurant_id
WHERE r.restaurant_name = {{#formula CurrentUserAttributeText('restaurant')}}
  AND o.status = 'completed'
