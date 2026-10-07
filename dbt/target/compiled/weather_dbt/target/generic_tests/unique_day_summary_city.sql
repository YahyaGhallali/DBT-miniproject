
    
    

select
    city as unique_field,
    count(*) as n_records

from "warehouse"."analytics"."day_summary"
where city is not null
group by city
having count(*) > 1


