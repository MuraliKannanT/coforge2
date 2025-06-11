    select

        -- ids
        s_suppkey as supplier_id,
        s_nationkey as nation_id,

        -- descriptions
        s_name as supplier_name,
        s_address as supplier_address,
        s_phone as phone_number,
        {{ joincols('s_name','s_address')}} as nameaddr,
        s_comment as comment,
        -- amounts
        s_acctbal as account_balance,
        {{ cents_to_dollars('s_acctbal',4)}} as balcents,
        updated_time

    from {{ source('src', 'suppliers') }} supps 
    
