# Weather Data Pipeline

[![Python](https://img.shields.io/badge/Python-3.14%2B-blue?logo=python)](https://www.python.org/)
[![dbt](https://img.shields.io/badge/dbt-DuckDB-orange?logo=dbt)](https://www.getdbt.com/)
[![DuckDB](https://img.shields.io/badge/DuckDB-1.5%2B-yellow?logo=duckdb)](https://duckdb.org/)
[![uv](https://img.shields.io/badge/Package%20Manager-uv-purple)](https://docs.astral.sh/uv/)

An end-to-end, reproducible Data Engineering pipeline that extracts hourly weather forecast data from the [Open-Meteo REST API](https://open-meteo.com/), stores the raw data into an embedded [DuckDB](https://duckdb.org/) analytical database, and transforms it into city-level daily summary aggregations using [dbt](https://www.getdbt.com/).

---

## Table of Contents

- [Architecture](#architecture)
- [Project Features](#project-features)
- [Target Locations & Metrics](#target-locations--metrics)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
  - [1. Installation](#1-installation)
  - [2. Ingest Weather Data](#2-ingest-weather-data)
  - [3. Transform Data with dbt](#3-transform-data-with-dbt)
  - [4. Validate Data Quality](#4-validate-data-quality)
- [Configuration](#configuration)
- [Data Models & Schema](#data-models--schema)
- [Testing & Quality Assurance](#testing--quality-assurance)

---

## Architecture

```text
               +-----------------------+
               |  Open-Meteo REST API  |
               +-----------+-----------+
                           |
                           | HTTP (cached & retry)
                           v
               +-----------------------+
               |     ingestion.py      |
               +-----------+-----------+
                           |
                           | DuckDB SQL
                           v
+------------------------------------------------------+
|                       DuckDB                         |
|                                                      |
|  [raw.weather_daily] ----> [analytics.day_summary]   |
|         (Raw Data)                (dbt Model)        |
+------------------------------------------------------+
                           |
                           v
               +-----------------------+
               |  dbt Data Validation  |
               | (unique, not_null...) |
               +-----------------------+
```

1. **Ingestion Layer (`ingestion.py`)**: Fetches hourly weather metrics using `openmeteo-requests` with response caching (`requests-cache`) and automated exponential backoff (`retry-requests`). Writes raw records into the `raw.weather_daily` DuckDB table.
2. **Transformation Layer (`dbt`)**: Aggregates hourly weather metrics into city-wide daily statistics, outputting to the `analytics.day_summary` DuckDB table.
3. **Data Quality Layer (`dbt test`)**: Enforces schema validation, uniqueness constraints, and non-null guarantees across key attributes.

---

## Project Features

- **Automated API Ingestion**: Resilient API fetching with automatic retries (5 retries with backoff) and local request caching (1-hour TTL) to prevent rate limits.
- **Embedded OLAP Database**: Utilizes DuckDB for fast, serverless columnar data processing and zero-config analytics storage.
- **dbt Modeling**: Structured SQL transformation adhering to analytics engineering best practices (source declarations, model definitions, materializations).
- **Modern Python Tooling**: Managed with [`uv`](https://docs.astral.sh/uv/) for fast, deterministic dependency resolution.

---

## Target Locations & Metrics

### Cities Tracked

- **Casablanca** (33.5731° N, -7.5898° W)
- **New York** (40.7128° N, -74.0060° W)
- **Paris** (48.8566° N, 2.3522° E)
- **Tokyo** (35.6762° N, 139.6503° E)
- **Brasilia** (-15.7939° S, -47.8828° W)

### Weather Metrics

- `temperature_2m`: Air temperature at 2 meters above ground (°C)
- `relative_humidity_2m`: Relative humidity at 2 meters above ground (%)
- `precipitation`: Total precipitation (rain/snow) (mm)
- `wind_speed_10m`: Wind speed at 10 meters above ground (km/h)
- `weather_code`: WMO Weather interpretation code

---

## Project Structure

```text
.
├── dbt/                         # dbt project directory
│   ├── models/                  # dbt models and schema declarations
│   │   ├── day_summary.sql      # SQL transformation model (City daily aggregations)
│   │   ├── schema.yml           # Column descriptions and data quality tests
│   │   └── sources.yml          # Raw DuckDB source declaration
│   ├── dbt_project.yml          # dbt project configuration & materializations
│   ├── profiles.yml             # DuckDB connection profile configuration
│   └── warehouse.duckdb         # DuckDB database file (created upon execution)
├── ingestion.py                 # Open-Meteo API extractor & DuckDB loader
├── pyproject.toml               # Python project configuration & dependencies
├── uv.lock                      # Locked dependency environment
└── README.md                    # Project documentation
```

---

## Prerequisites

- **Python**: Version `3.14` or newer
- **uv**: Fast Python package installer and dependency resolver ([Installation Guide](https://docs.astral.sh/uv/getting-started/installation/))

---

## Getting Started

### 1. Installation

Clone the repository and install dependencies using `uv`:

```bash
uv sync
```

### 2. Ingest Weather Data

Run the ingestion script to fetch data from Open-Meteo and populate DuckDB:

```bash
uv run python ingestion.py
```

*Output:*

- Creates schema `raw` in DuckDB (default path: `dbt/warehouse.duckdb`).
- Creates table `raw.weather_daily` with hourly weather metrics.

### 3. Transform Data with dbt

Execute dbt models to build the analytics summary table:

```bash
uv run dbt run --project-dir dbt --profiles-dir dbt
```

*Output:*

- Creates schema `analytics` in DuckDB.
- Materializes table `analytics.day_summary`.

### 4. Validate Data Quality

Run dbt tests to verify schema constraints and data integrity:

```bash
uv run dbt test --project-dir dbt --profiles-dir dbt
```

---

## Configuration

### Environment Variables

| Variable | Description | Default Value |
| :--- | :--- | :--- |
| `DUCKDB_PATH` | Path to the DuckDB database file | `dbt/warehouse.duckdb` |

To run the pipeline with a custom database location:

```bash
# Set custom DuckDB location for ingestion and dbt execution
DUCKDB_PATH=./data/custom_warehouse.duckdb uv run python ingestion.py
DUCKDB_PATH=./data/custom_warehouse.duckdb uv run dbt run --project-dir dbt --profiles-dir dbt
```

---

## Data Models & Schema

### `raw.weather_daily` (Source Table)

| Column | Type | Description |
| :--- | :--- | :--- |
| `city` | VARCHAR | Name of the city |
| `date` | TIMESTAMP | Timestamp of the forecast hour |
| `temperature_2m` | DOUBLE | Hourly temperature |
| `relative_humidity_2m` | DOUBLE | Hourly relative humidity |
| `precipitation` | DOUBLE | Hourly precipitation |
| `wind_speed_10m` | DOUBLE | Hourly wind speed |
| `weather_code` | INT64 | WMO Weather code |

### `analytics.day_summary` (dbt Model Table)

| Column | Type | Description | Aggregation |
| :--- | :--- | :--- | :--- |
| `city` | VARCHAR | Primary Key / City name | Group By |
| `avg_temperature_2m` | DOUBLE | Average temperature | `AVG(temperature_2m)` |
| `avg_relative_humidity_2m` | DOUBLE | Average relative humidity | `AVG(relative_humidity_2m)` |
| `sum_precipitation` | DOUBLE | Total precipitation | `SUM(precipitation)` |
| `avg_wind_speed_10m` | DOUBLE | Average wind speed | `AVG(wind_speed_10m)` |

---

## Testing & Quality Assurance

Data quality tests are specified in [`schema.yml`](file:///c:/Users/yahya/Desktop/DE/dbt/models/schema.yml):

- **Uniqueness**: `city` column in `day_summary` must be unique across records.
- **Non-null constraints**: All metric columns (`avg_temperature_2m`, `avg_relative_humidity_2m`, `sum_precipitation`, `avg_wind_speed_10m`, `city`) are asserted to contain no `NULL` values.
