-- -- Create the dim_product table
-- WITH product_cte AS (
--   SELECT DISTINCT
--     product_id,
--     product_description,
--     product_category,
--     goods_services_tax,
--     price
--   FROM {{ ref('int_online_sales') }}
-- )

-- select 
--     product_id,
--     product_description,
--     product_category,
--     goods_services_tax,
--     price
-- from product_cte

select
    product_id,
    ANY_VALUE(product_description) as product_description,
    ANY_VALUE(product_category) as product_category,
    ANY_VALUE(goods_services_tax) as goods_services_tax,
    AVG(price) as price
from {{ ref('int_online_sales') }}
group by product_id