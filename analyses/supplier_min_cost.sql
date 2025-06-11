{# parameterize the following variables #}
{% set size = 15 %}
{% set type = 'BRASS' %}
{% set region = 'EUROPE' %}

{#
-- can use already declared variables in a .yml file
{% set size = var('size') %}
{% set type = var('type') %}
{% set region = var('region') %}
#}

select
    s_acctbal,
    s_name,
    n_name,
    p_partkey,
    p_mfgr,
    s_address,
    s_phone,
    s_comment
from
    {{ source('src', 'parts') }}, {{ source('src', 'suppliers') }},
    {{ source('src', 'partsupps') }}, {{ source('src', 'nations') }}, 
    {{ source('src', 'regions') }}

where
    p_partkey = ps_partkey
    and s_suppkey = ps_suppkey
    and p_size = {{ size }}
    and p_type like '%{{ type }}%'
    and s_nationkey = n_nationkey
    and n_regionkey = r_regionkey
    and r_name = '{{ region }}'
    and ps_supplycost = (
        select 
            min(ps_supplycost)
        from
        {{ source('src', 'partsupps') }}, {{ source('src', 'suppliers') }},
        {{ source('src', 'nations') }}, {{ source('src', 'regions') }}
        where
            p_partkey = ps_partkey
            and s_suppkey = ps_suppkey
            and s_nationkey = n_nationkey
            and n_regionkey = r_regionkey
            and r_name = '{{ region }}'
    )
order by
    s_acctbal desc,
    n_name,
    s_name,
    p_partkey