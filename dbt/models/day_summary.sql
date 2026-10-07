SELECT
    "city",
    AVG("temperature_2m") AS "avg_temperature_2m",
    AVG("relative_humidity_2m") AS "avg_relative_humidity_2m",
    SUM("precipitation") AS "sum_precipitation",
    AVG("wind_speed_10m") AS "avg_wind_speed_10m",
FROM
    {{ source('raw', 'weather_daily') }}
GROUP BY
    "city";