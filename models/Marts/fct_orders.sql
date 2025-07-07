{{
    config(
        materialized = 'table'
    )
}}
with orders as (
    
    select * from {{ ref('stg_orders') }}

),
orders_items as (
    
    select * from {{ ref('int_order_items') }}

),
order_item_summary as (

    select 
        order_id as order_key,
        sum(gross_item_sales_amount) as gross_item_sales_amount,
        sum(item_discount_amount) as item_discount_amount,
        sum(item_tax_amount) as item_tax_amount,
        sum(net_item_sales_amount) as net_item_sales_amount
    from orders_items
    group by
        1
),
final as (

    select 

        o.order_id as order_key, 
        o.order_date,
        o.customer_id as customer_key,
        o.status_code as order_status_code,
        o.priority_code as order_priority_code,
        o.clerk_name as order_clerk_name,
        o.priority_code as shipping_priority,
        1 as order_count,                
        s.gross_item_sales_amount,
        s.item_discount_amount,
        s.item_tax_amount,
        s.net_item_sales_amount
    from
        orders o
        join
        order_item_summary s
            on o.order_id = s.order_key
)
select 
    f.*,
    {{ dbt_housekeeping() }}
from
    final f
order by
    f.order_date