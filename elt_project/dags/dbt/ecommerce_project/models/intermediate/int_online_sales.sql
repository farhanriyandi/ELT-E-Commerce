SELECT
    os.transaction_id,
    os.customer_id,
    os.transaction_date,
    os.product_id,
    os.product_category,
    os.product_description,
    os.delivery_charges,
    os.coupon_status,
    os.avg_price as price,
    os.quantity,
    ta.goods_services_tax,
    os.quantity * os.avg_price AS total_amount
FROM {{ref('stg_online_sales')}} os 
JOIN {{ref('stg_tax_amount')}} ta ON os.product_category = ta.product_category


