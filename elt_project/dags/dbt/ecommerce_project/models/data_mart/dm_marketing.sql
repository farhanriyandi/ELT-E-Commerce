select
    fs.transaction_date,
    dd.month as sales_month,
    fs.transaction_id,
    fs.customer_id,
    dc.gender as customer_gender,
    dc.location as customer_location,
    dp.product_category,
    fs.quantity,
    fs.total_amount,
    fs.coupon_code,
    fs.coupon_status,
from 
    {{ ref('fact_online_sales') }} as fs
left join 
    {{ ref('dim_date') }} as dd on fs.transaction_date=dd.transaction_date
left join
    {{ ref('dim_customers') }} as dc on fs.customer_id=dc.customer_id
left join
    {{ref('dim_product') }} as dp on fs.product_id=dp.product_id
