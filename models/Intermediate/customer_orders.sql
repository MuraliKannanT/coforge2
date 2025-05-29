select sc.customer_id, max(order_date) dates, sum(quantity) qty 
from {{ ref ('stg_customers')}} sc
join {{ ref('order_items')}} ot on  sc.customer_id = ot.customer_id
group by sc.customer_id