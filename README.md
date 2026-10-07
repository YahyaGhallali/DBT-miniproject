# Weather Data Pipeline

A small, reproducible data pipeline that fetches hourly weather forecasts from
[Open-Meteo](https://open-meteo.com/), stores the raw data in DuckDB, and builds
a city-level summary with dbt. The pipeline can be run locally with `uv` or
scheduled daily with Apache Airflow and Docker.

## Architecture

```text
Open-Meteo API
   |
   v
ingestion.py  --->  raw.weather_daily (DuckDB)
         |
         v
      dbt model: day_summary
         |
         v
     dbt tests and validation
```

The ingestion script retrieves one forecast day for Casablanca, New York,
Paris, Tokyo, and Brasilia. It writes temperature, relative humidity,
precipitation, wind speed, and weather code to `raw.weather_daily`.

## Requirements

- Python 3.14 or newer
- [`uv`](https://docs.astral.sh/uv/)
- Docker and Docker Compose for the Airflow deployment

## Local development

From the repository root, install the locked dependencies:

```bash
uv sync
```

Run the pipeline stages in order:

```bash
uv run python ingestion.py
uv run dbt --project-dir dbt --profiles-dir dbt run
uv run dbt --project-dir dbt --profiles-dir dbt test
```

The local database is written to `dbt/warehouse.duckdb`. To use another
location, set `DUCKDB_PATH` before running ingestion:

```bash
DUCKDB_PATH=./data/warehouse.duckdb uv run python ingestion.py
```

The dbt model is available as `day_summary` and contains one row per city with
average temperature, average relative humidity, total precipitation, and
average wind speed.

## Airflow deployment

Build the pipeline image and initialize the Airflow metadata database:

```bash
docker build -t weather-pipeline:latest .
docker compose up airflow-init
docker compose up -d airflow-webserver airflow-scheduler
```

Open [http://localhost:8080](http://localhost:8080) and sign in with:

```text
Username: airflow
Password: airflow
```

The `weather_pipeline` DAG is paused when created. Enable it in the Airflow
web interface to run the ingestion, dbt build, and dbt tests once per day.

The pipeline container writes its DuckDB database to the named
`weather_dbt_data` volume. Airflow metadata is stored separately in the
`postgres_data` volume.

To stop the services:

```bash
docker compose down
```

To remove the persisted Airflow and warehouse data as well:

```bash
docker compose down -v
```

## Project structure

```text
.
├── ingestion.py                 # Open-Meteo extraction and DuckDB load
├── Dockerfile                   # Runtime image for the pipeline
├── docker-compose.yml           # Airflow and PostgreSQL services
├── airflow/
│   ├── Dockerfile               # Airflow image with Docker provider
│   └── dags/weather_pipeline.py # Daily orchestration DAG
└── dbt/
 ├── dbt_project.yml
 ├── profiles.yml
 └── models/
  ├── sources.yml         # raw.weather_daily source declaration
  ├── day_summary.sql     # City-level transformation
  └── schema.yml          # Model documentation and tests
```

## Configuration

The default DuckDB path is `dbt/warehouse.duckdb`. The `DUCKDB_PATH`
environment variable overrides it and is set to
`/opt/weather/data/warehouse.duckdb` in the pipeline image. API retry and cache
behavior is configured in `ingestion.py`; responses are cached locally in
`.cache` for one hour.
