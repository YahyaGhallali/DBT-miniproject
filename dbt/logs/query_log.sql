-- created_at: 2026-10-07T16:15:25.661038600+00:00
-- finished_at: 2026-10-07T16:15:25.677618300+00:00
-- elapsed: 16ms
-- outcome: success
-- dialect: duckdb
-- node_id: test.weather_dbt.unique_day_summary_city.1bfa6ad5ff
-- query_id: not available
-- desc: execute adapter call
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.weather_dbt.unique_day_summary_city.1bfa6ad5ff", "profile_name": "weather_dbt", "target_name": "dev"} */

    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    city as unique_field,
    count(*) as n_records

from "warehouse"."analytics"."day_summary"
where city is not null
group by city
having count(*) > 1



  
  
      
    ) dbt_internal_test;

-- created_at: 2026-10-07T16:15:25.661014900+00:00
-- finished_at: 2026-10-07T16:15:25.677618500+00:00
-- elapsed: 16ms
-- outcome: success
-- dialect: duckdb
-- node_id: test.weather_dbt.not_null_day_summary_sum_precipitation.e0d1583e32
-- query_id: not available
-- desc: execute adapter call
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.weather_dbt.not_null_day_summary_sum_precipitation.e0d1583e32", "profile_name": "weather_dbt", "target_name": "dev"} */

    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select sum_precipitation
from "warehouse"."analytics"."day_summary"
where sum_precipitation is null



  
  
      
    ) dbt_internal_test;

-- created_at: 2026-10-07T16:15:25.661020700+00:00
-- finished_at: 2026-10-07T16:15:25.677618700+00:00
-- elapsed: 16ms
-- outcome: success
-- dialect: duckdb
-- node_id: test.weather_dbt.not_null_day_summary_city.516861ee8f
-- query_id: not available
-- desc: execute adapter call
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.weather_dbt.not_null_day_summary_city.516861ee8f", "profile_name": "weather_dbt", "target_name": "dev"} */

    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select city
from "warehouse"."analytics"."day_summary"
where city is null



  
  
      
    ) dbt_internal_test;

-- created_at: 2026-10-07T16:15:25.661014900+00:00
-- finished_at: 2026-10-07T16:15:25.677618900+00:00
-- elapsed: 16ms
-- outcome: success
-- dialect: duckdb
-- node_id: test.weather_dbt.not_null_day_summary_avg_relative_humidity_2m.9dd40b7b18
-- query_id: not available
-- desc: execute adapter call
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.weather_dbt.not_null_day_summary_avg_relative_humidity_2m.9dd40b7b18", "profile_name": "weather_dbt", "target_name": "dev"} */

    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select avg_relative_humidity_2m
from "warehouse"."analytics"."day_summary"
where avg_relative_humidity_2m is null



  
  
      
    ) dbt_internal_test;

-- created_at: 2026-10-07T16:15:25.661037800+00:00
-- finished_at: 2026-10-07T16:15:25.677644200+00:00
-- elapsed: 16ms
-- outcome: success
-- dialect: duckdb
-- node_id: test.weather_dbt.not_null_day_summary_avg_wind_speed_10m.ded6b80db0
-- query_id: not available
-- desc: execute adapter call
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.weather_dbt.not_null_day_summary_avg_wind_speed_10m.ded6b80db0", "profile_name": "weather_dbt", "target_name": "dev"} */

    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select avg_wind_speed_10m
from "warehouse"."analytics"."day_summary"
where avg_wind_speed_10m is null



  
  
      
    ) dbt_internal_test;

-- created_at: 2026-10-07T16:15:25.661020700+00:00
-- finished_at: 2026-10-07T16:15:25.677659800+00:00
-- elapsed: 16ms
-- outcome: success
-- dialect: duckdb
-- node_id: test.weather_dbt.not_null_day_summary_avg_temperature_2m.4ff0f13c8a
-- query_id: not available
-- desc: execute adapter call
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.weather_dbt.not_null_day_summary_avg_temperature_2m.4ff0f13c8a", "profile_name": "weather_dbt", "target_name": "dev"} */

    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select avg_temperature_2m
from "warehouse"."analytics"."day_summary"
where avg_temperature_2m is null



  
  
      
    ) dbt_internal_test;

