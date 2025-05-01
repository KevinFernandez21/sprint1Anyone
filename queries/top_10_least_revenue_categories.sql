-- TODO: This query will return a table with the top 10 least revenue categories 
-- in English, the number of orders and their total revenue. The first column 
-- will be Category, that will contain the top 10 least revenue categories; the 
-- second one will be Num_order, with the total amount of orders of each 
-- category; and the last one will be Revenue, with the total revenue of each 
-- catgory.
-- HINT: All orders should have a delivered status and the Category and actual 
-- delivery date should be not null.
WITH traslate AS (
    SELECT pcnt.product_category_name_english AS Category, op.product_id
    FROM olist_products AS op
    JOIN product_category_name_translation AS pcnt
        ON op.product_category_name = pcnt.product_category_name
)
SELECT 
    tl.Category,
    COUNT(DISTINCT oo.order_id) AS Num_order,  
    SUM(oop.payment_value) AS Revenue
FROM 
    olist_order_items AS ooi
JOIN traslate AS tl
    ON ooi.product_id = tl.product_id
JOIN olist_orders AS oo
    ON oo.order_id = ooi.order_id
JOIN olist_order_payments AS oop
    ON oop.order_id = ooi.order_id
WHERE 
    oo.order_status = 'delivered'
    AND tl.Category IS NOT NULL
    AND oo.order_estimated_delivery_date IS NOT NULL
GROUP BY 
    tl.Category
ORDER BY 
    Revenue
LIMIT 10;

