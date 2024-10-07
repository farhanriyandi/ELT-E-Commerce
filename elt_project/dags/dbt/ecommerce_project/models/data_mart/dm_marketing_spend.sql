select
    ms.date,
    ms.offline_spend,
    ms.online_spend as ads_spend,
    sum(os.total_amount) as total_amount,
    count(os.transaction_id) as total_transaction
from
    {{ ref('fact_marketing_spend')}} as ms
join 
    {{ ref('fact_online_sales')}} as os on os.transaction_date=ms.date
group by
    ms.date, ms.offline_spend, ms.online_spend



    