"""Fetch selected weather features for multiple cities from Open-Meteo."""

import os

import pandas as pd
import duckdb
import openmeteo_requests
import requests_cache
from retry_requests import retry

CITIES = [
    {"city": "Casablanca", "latitude": 33.5731, "longitude": -7.5898},
    {"city": "New York", "latitude": 40.7128, "longitude": -74.0060},
    {"city": "Paris", "latitude": 48.8566, "longitude": 2.3522},
    {"city": "Tokyo", "latitude": 35.6762, "longitude": 139.6503},
    {"city": "Brasilia", "latitude": -15.7939, "longitude": -47.8828},
]

FEATURES = [
    "temperature_2m",
    "relative_humidity_2m",
    "precipitation",
    "wind_speed_10m",
    "weather_code",
]

cache_session = requests_cache.CachedSession(".cache", expire_after=3600)
retry_session = retry(cache_session, retries=5, backoff_factor=0.2)
openmeteo = openmeteo_requests.Client(session=retry_session)

url = "https://api.open-meteo.com/v1/forecast"
frames = []

for city in CITIES:
    params = {
        "latitude": city["latitude"],
        "longitude": city["longitude"],
        "hourly": FEATURES,
        "timezone": "auto",
        "forecast_days": 1,
    }

    responses = openmeteo.weather_api(url, params=params)
    response = responses[0]
    hourly = response.Hourly()

    dates = pd.date_range(
        start=pd.to_datetime(hourly.Time(), unit="s", utc=True),
        end=pd.to_datetime(hourly.TimeEnd(), unit="s", utc=True),
        freq=pd.Timedelta(seconds=hourly.Interval()),
        inclusive="left",
    )

    hourly_data = {
        "city": [city["city"]] * len(dates),
        "date": dates,
    }

    for index, feature in enumerate(FEATURES):
        hourly_data[feature] = hourly.Variables(index).ValuesAsNumpy()

    frames.append(pd.DataFrame(hourly_data))

weather_df = pd.concat(frames, ignore_index=True)
weather_df = weather_df[["city", "date", *FEATURES]]

print(weather_df)
print(f"\nTotal rows: {len(weather_df)}")

database_path = os.getenv("DUCKDB_PATH", "dbt/warehouse.duckdb")
con = duckdb.connect(database_path)
con.execute("CREATE SCHEMA IF NOT EXISTS raw")
con.execute("CREATE OR REPLACE TABLE raw.weather_daily AS SELECT * FROM weather_df")
print(con.execute("SELECT count(*) FROM raw.weather_daily").fetchone())
con.close()
