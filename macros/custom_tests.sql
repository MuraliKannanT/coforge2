{% test lesservalues(model, column_name, pk_name, threshold) %}
with ttable as (
    select * from {{ model }} )
 
select {{ pk_name }} id, sum({{column_name}}) total from ttable
group by 1 
having (total<={{ threshold }})
{% endtest %}