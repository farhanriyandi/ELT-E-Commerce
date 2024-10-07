select 
    Product_Category as product_category,
    GST as goods_services_tax
from {{source('my_e_commerce_dataset1', 'Tax_Amount')}}
