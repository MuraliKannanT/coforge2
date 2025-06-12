with region as (
select
	r_regionkey as region_id,
	r_name as name,
	r_comment as comment,
    'Testing' as test
from {{ source('src','regions')}}

)

select * from region