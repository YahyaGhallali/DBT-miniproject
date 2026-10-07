
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select avg_temperature_2m
from "warehouse"."analytics"."day_summary"
where avg_temperature_2m is null



  
  
      
    ) dbt_internal_test