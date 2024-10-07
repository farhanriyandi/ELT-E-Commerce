select 
    CustomerID as customer_id,
    Transaction_ID as transaction_id,
    Transaction_Date as transaction_date,
    Product_SKU as product_id,
    Product_Description as product_description,
    Product_Category as product_category,
    Quantity as quantity,
    Avg_Price as avg_price,
    Delivery_Charges as delivery_charges,
    Coupon_Status as coupon_status
from {{source('my_e_commerce_dataset1', 'Online_Sales')}}
