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

