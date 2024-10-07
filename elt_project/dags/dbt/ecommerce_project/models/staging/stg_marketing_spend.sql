select 
    Date as date,
    Offline_Spend as offline_spend,
    Online_Spend as online_spend,
from {{source('my_e_commerce_dataset1', 'Marketing_Spend')}}