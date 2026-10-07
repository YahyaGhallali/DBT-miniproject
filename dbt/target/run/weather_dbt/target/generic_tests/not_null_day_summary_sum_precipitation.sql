
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select sum_precipitation
from "warehouse"."analytics"."day_summary"
where sum_precipitation is null



  
  
      
    ) dbt_internal_test