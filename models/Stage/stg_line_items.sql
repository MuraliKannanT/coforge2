{# install dbt-utils #}

with source as (

    select * from {{ source('src', 'lineitems') }}

),

changed as (

    select

        -- ids

        l_orderkey    as order_item_id,
        l_orderkey as order_id,
        l_partkey as part_id,
        l_suppkey as supplier_id,

        -- descriptions
        l_linenumber as line_number,
        l_comment as comment,
        l_shipmode as ship_mode,
        l_shipinstruct as ship_instructions,
        
        -- numbers
        l_quantity as quantity,
        l_extendedprice as extended_price,
        l_discount as discount_percentage,
        l_tax as tax_rate,
        
        -- status
        l_linestatus as status_code,
        l_returnflag as return_flag,
        
        -- dates
        l_shipdate as ship_date,
        l_commitdate as commit_date,
        l_receiptdate as receipt_date

    from source

)

select * from changed