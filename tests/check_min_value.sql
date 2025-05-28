{{ config(store_failures = true) }}

with orders as (
    select * from {{ ref('stg_orders') }}
)

select order_id, sum(total_price) ordertotal 
from orders 
group by 1
having (ordertotal<=800)
