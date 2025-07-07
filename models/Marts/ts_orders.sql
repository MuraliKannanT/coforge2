{{
    config(
        materialized = 'table'
    )
}}
with orders as (
    
    select * from {{ ref('stg_orders') }} where order_id <= 100

),
orders_items as (
    
    select * from {{ ref('int_order_items') }} where order_id <= 100

),
order_item_summary as (

    select 
        o.order_id,
        sum(o.gross_item_sales_amount) as gross_amount,
        sum(o.item_discount_amount) as discount_amount
    from orders_items o
    group by
        1
),

final as (

    select 
        o.order_id, 
        o.order_date,
        s.gross_amount,
        s.discount_amount,
    from
        orders o
        join
        order_item_summary s
            on o.order_id = s.order_id
)
select 
    f.*
from
    final f
order by
    f.order_date
