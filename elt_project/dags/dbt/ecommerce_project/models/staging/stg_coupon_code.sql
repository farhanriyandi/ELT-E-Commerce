select 
    Month as month,
    Product_Category as product_category,
    Coupon_Code as coupon_code,
    Discount_pct as discount_pct
from {{source('my_e_commerce_dataset1', 'Discount_Coupon')}}
