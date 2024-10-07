SELECT 
    CASE
        WHEN month = 'Jan' THEN 1
        WHEN month = 'Feb' THEN 2
        WHEN month = 'Mar' THEN 3
        WHEN month = 'Apr' THEN 4
        WHEN month = 'May' THEN 5
        WHEN month = 'Jun' THEN 6
        WHEN month = 'Jul' THEN 7
        WHEN month = 'Aug' THEN 8
        WHEN month = 'Sep' THEN 9
        WHEN month = 'Oct' THEN 10
        WHEN month = 'Nov' THEN 11
        WHEN month = 'Dec' THEN 12
    END AS month,
    product_category,
    coupon_code,
    discount_pct
FROM {{ ref('stg_coupon_code') }}