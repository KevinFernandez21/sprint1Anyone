-- TODO: This query will return a table with the top 10 least revenue categories 
-- in English, the number of orders and their total revenue. The first column 
-- will be Category, that will contain the top 10 least revenue categories; the 
-- second one will be Num_order, with the total amount of orders of each 
-- category; and the last one will be Revenue, with the total revenue of each 
-- catgory.
-- HINT: All orders should have a delivered status and the Category and actual 
-- delivery date should be not null.
WITH valid_orders AS (
    SELECT order_id 
    FROM olist_orders
    WHERE order_status = 'delivered'
    AND order_delivered_customer_date IS NOT NULL
),
order_payments AS (
    SELECT order_id, SUM(payment_value) AS total_payment
    FROM olist_order_payments
    GROUP BY order_id
),
product_categories AS (
    SELECT 
        op.product_id,
        pcnt.product_category_name_english AS category
    FROM olist_products op
    JOIN product_category_name_translation pcnt
        ON op.product_category_name = pcnt.product_category_name
    WHERE pcnt.product_category_name_english IS NOT NULL
)
SELECT
    pc.category AS "Category",
    COUNT(DISTINCT oi.order_id) AS "Num_order",
    ROUND(SUM(op.total_payment), 2) AS "Revenue"
FROM olist_order_items oi
JOIN valid_orders vo ON oi.order_id = vo.order_id
JOIN product_categories pc ON oi.product_id = pc.product_id
JOIN order_payments op ON oi.order_id = op.order_id
GROUP BY pc.category
ORDER BY SUM(op.total_payment)
LIMIT 10;

