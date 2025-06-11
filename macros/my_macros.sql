{% macro joincols (col1, col2) %}
   ( {{col1}} || ' ' || {{col2}} )
{% endmacro %}


{% macro cents_to_dollars(column_name, scale=2) %}
    ({{ column_name }} / 100)::numeric(16, {{ scale }})
{% endmacro %}

{% macro dol_eur(colm, deci=2) -%}
    round( 0.89 * {{ colm }}, {{ deci }})
{%- endmacro %}

{% macro dol_inr(colm, deci=2) -%}
    round( 85.48 * {{ colm }}, {{ deci }})
{%- endmacro %}

{% macro mactest () %}
    {% do run_query ('create table testt (id number, name string)') %}
{% endmacro %}


{% macro dealer () %}
{% set qry %}
    alter session set query_tag = 'Testing from dbt';
    copy into stg_dealership from @s3temp/dealership.dat file_format = ff_csv_dq;
{% endset %}

{% do run_query(qry) %}
{% endmacro %}

{% macro spins() %} 
{% do run_query('create transient table if not exists spins (supplier_id number, supplier_name string)') %}

{% set rand_query %}
    select uniform(1, 10000, random()) rndno limit 1
{% endset %}

{% set results = run_query(rand_query)%}

{% if execute %}
    {% set numbr = results.rows[0]['RNDNO'] %}
{% endif %}

{% set supp_query %}
    select top 1 skey,sname from {{ ref ('supplier_names') }} where skey in {{numbr}}
{% endset %}

{% set results = run_query(supp_query) %}
{% if execute %}
    {% set supkey = results.rows[0] %}
    {% set proquery %}
        insert into spins values ({{supkey['SKEY']}} , '{{ supkey['SNAME'] }}' );
    {% endset %}
    {% do run_query(proquery) %}
 {% endif %}

{% endmacro %}


{% macro money(col) -%}
::decimal(16,4)
{%- endmacro %}
