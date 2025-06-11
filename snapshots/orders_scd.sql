{% snapshot orders_snapshot %}

{{
    config(
      target_database='analytics',
      target_schema='snapshots',
      unique_key='order_id',
      strategy='timestamp',
      updated_at='order_date',
    )
}}

select 
order_id, customer_id, clerk_name, status_code, 
total_price as price_usd,
{{ dol_eur('total_price')}} as price_euros,
{{ dol_inr('total_price')}} as price_rupees,
priority_code, ship_priority, order_date, comment
from {{ ref ('stg_orders') }}

{% endsnapshot %}