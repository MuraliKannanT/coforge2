{# install dbt-utils #}
{{
    config(
        materialized = 'table'
    )
}}
with orders as (
    
    select * from {{ ref('stg_orders') }}

),
line_items as (

    select * from {{ ref('stg_line_items') }}

)
select 

    {{ dbt_utils.generate_surrogate_key(['o.order_id', 'l.order_line_number']) }} as order_item_key,

    o.order_id,
    o.order_date,
    o.customer_id,
    o.status_code as order_status_code,
    
    l.part_id,
    l.supplier_id,
    l.return_flag as return_status_code,
    l.order_line_number,
    l.status_code as order_line_status_code,
    l.ship_date,
    l.commit_date,
    l.receipt_date,
    l.ship_mode as ship_mode_name,

    l.quantity,
    
    -- extended_price is actually the line item total,
    -- so we back out the extended price per item
    (l.extended_price/nullif(l.quantity, 0)){{ money() }} as base_price,
    l.discount_percentage,
    (base_price * (1 - l.discount_percentage)){{ money() }} as discounted_price,

    l.extended_price as gross_item_sales_amount,
    (l.extended_price * (1 - l.discount_percentage)){{ money() }} as discounted_item_sales_amount,
    -- We model discounts as negative amounts
    (-1 * l.extended_price * l.discount_percentage){{ money() }} as item_discount_amount,
    l.tax_rate,
    ((gross_item_sales_amount + item_discount_amount) * l.tax_rate){{ money() }} as item_tax_amount,
    (
        gross_item_sales_amount + 
        item_discount_amount + 
        item_tax_amount
    ){{ money() }} as net_item_sales_amount

from
    orders o
    join
    line_items l
        on o.order_id = l.order_id
order by
    o.order_date