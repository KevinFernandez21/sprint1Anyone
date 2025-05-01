-- TODO: This query will return a table with two columns; customer_state, and 
-- Revenue. The first one will have the letters that identify the top 10 states 
-- with most revenue and the second one the total revenue of each.
-- HINT: All orders should have a delivered status and the actual delivery date 
-- should be not null. 
WITH filter_pay AS (
    SELECT
        order_id,
        SUM(payment_value) AS total_paid
    FROM olist_order_payments
    GROUP BY order_id
)
SELECT
    c.customer_state AS customer_state,
    CAST(SUM(ft.total_paid) AS DECIMAL(20,10)) AS Revenue 
FROM olist_orders AS o
JOIN filter_pay AS ft ON ft.order_id = o.order_id
JOIN olist_customers AS c ON c.customer_id = o.customer_id
WHERE
    o.order_status = 'delivered'
    AND o.order_delivered_customer_date IS NOT NULL
GROUP BY
    c.customer_state
ORDER BY
    Revenue DESC
LIMIT 10;