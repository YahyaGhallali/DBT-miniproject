
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select avg_wind_speed_10m
from "warehouse"."analytics"."day_summary"
where avg_wind_speed_10m is null



  
  
      
    ) dbt_internal_test