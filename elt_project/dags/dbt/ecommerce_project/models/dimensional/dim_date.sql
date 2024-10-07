select 
    transaction_date,
    EXTRACT(DAY FROM transaction_date) AS day,
    EXTRACT(MONTH FROM transaction_date) AS month,
    EXTRACT(YEAR FROM transaction_date) AS year,
from {{ ref('int_online_sales') }}