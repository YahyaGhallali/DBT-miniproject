FROM python:3.14-slim

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /opt/weather

ENV UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    PATH="/opt/weather/.venv/bin:$PATH"

COPY pyproject.toml uv.lock ./
RUN uv sync --locked --no-dev

COPY ingestion.py ./
COPY dbt ./dbt

ENV DUCKDB_PATH=/opt/weather/data/warehouse.duckdb

CMD ["sh", "-c", "python ingestion.py && dbt --project-dir dbt --profiles-dir dbt run && dbt --project-dir dbt --profiles-dir dbt test"]