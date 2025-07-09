{#
{{ config(pre_hook = "copy into ANALYTICS.DBT_MKT.stg_dealership from @ANALYTICS.DBT_MKT.s3temp/dealership.dat file_format = ANALYTICS.DBT_MKT.ff_csv_dq force = true
", post_hook = "copy into @~ from ANALYTICS.DBT_MKT.stg_dealership file_format = ANALYTICS.DBT_MKT.ff_csv_dq overwrite=true")}}
#}
with customer as (
select * from {{ ref('Analytics_TCS','stg_customers') }}
),

nation as (
select * from {{ ref('stg_nations') }}
),

region as (
select * from {{ ref('stg_regions') }}
),
final as (
select
        customer.customer_id,
        customer.name,
        nation.name as nation,
        region.name as region,
        customer.account_balance,
        customer.market_segment 
        from customer
        inner join nation
            on customer.nation_id = nation.nation_id
        inner join region
            on nation.region_id = region.region_id

)
select * from final