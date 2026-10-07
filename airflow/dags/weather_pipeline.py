from datetime import datetime, timedelta

from airflow import DAG
from airflow.providers.docker.operators.docker import DockerOperator
from docker.types import Mount

with DAG(
    dag_id="weather_pipeline",
    start_date=datetime(2026, 1, 1),
    schedule="@daily",
    catchup=False,
    default_args={
        "retries": 2,
        "retry_delay": timedelta(minutes=5),
    },
    tags=["weather", "duckdb", "dbt"],
) as dag:
    run_weather_pipeline = DockerOperator(
        task_id="run_weather_pipeline",
        image="weather-pipeline:latest",
        api_version="auto",
        auto_remove="success",
        docker_url="unix://var/run/docker.sock",
        network_mode="weather_default",
        mounts=[
            Mount(
                source="weather_dbt_data",
                target="/opt/weather/data",
                type="volume",
            )
        ],
        environment={"DUCKDB_PATH": "/opt/weather/data/warehouse.duckdb"},
    )
