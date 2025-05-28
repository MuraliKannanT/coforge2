{{ config(materialized='incremental', unique_key='supplier_id')}}

with supplier as (

    select 
        supplier_id,
        supplier_name,
        supplier_address,
        phone_number,
        account_balance,
        updated_time
    from
        {{ ref('stg_suppliers')}}
    {% if is_incremental() %}
    where 
        updated_time > (select max(updated_time) from {{ this }} )
    {% endif %}
)

select * from supplier
