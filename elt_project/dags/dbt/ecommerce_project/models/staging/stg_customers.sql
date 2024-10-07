select 
    CustomerID as customer_id,
    Gender as gender,
    Location as location,
    Tenure_Months as tenure_months
from {{source('my_e_commerce_dataset1', 'Customers_Data')}}