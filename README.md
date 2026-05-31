# NYC Rideshare Analytics — DuckDB + Parquet

Exploratory analysis of **212 million Uber and Lyft trips** in New York City during 2022, using [DuckDB](https://duckdb.org/) to query columnar Parquet data directly on disk — no database server required.

Data source: [NYC Taxi & Limousine Commission — High Volume FHV Trip Records](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page)

---

## Key Findings

- **212.4M rides** were requested across NYC in 2022 — roughly 582,000 per day
- **Uber held ~73% market share** vs Lyft's ~27%, consistently across all 12 months
- **Traffic is slowest at 4–5 PM** (~11.3 MPH average) and fastest at 4–5 AM (~21 MPH) — a near 2x difference
- **JFK Airport → Outside NYC** is the single most popular route from 6 AM onward, dominating evening and overnight hours
- **Uber riders tip marginally more** per mile ($0.319 vs $0.304 for Lyft)
- **Manhattan accounts for 90%+ of congestion surcharge revenue** — $194M out of $231M total collected in 2022

---

## Queries

| File | Question |
|---|---|
| [`01_schema_overview.sql`](queries/01_schema_overview.sql) | Inspect dataset columns and types |
| [`02_total_rides.sql`](queries/02_total_rides.sql) | Total rides requested in 2022 |
| [`03_uber_vs_lyft_monthly.sql`](queries/03_uber_vs_lyft_monthly.sql) | Monthly volume: Uber vs Lyft |
| [`04_avg_speed_by_hour.sql`](queries/04_avg_speed_by_hour.sql) | Average trip speed by hour of day |
| [`05_top_routes_by_hour.sql`](queries/05_top_routes_by_hour.sql) | Most popular pickup-dropoff pair per hour |
| [`06_tips_per_mile.sql`](queries/06_tips_per_mile.sql) | Tipping rate comparison: Uber vs Lyft |
| [`07_congestion_surcharge_by_borough.sql`](queries/07_congestion_surcharge_by_borough.sql) | Congestion surcharge revenue by borough |

---

## Running the Queries

### 1. Install DuckDB

```bash
pip install duckdb
# or download the CLI: https://duckdb.org/docs/installation/
```

### 2. Download the data (~5.2 GB)

```bash
python download_data.py
```

This pulls all 12 monthly Parquet files for 2022 from the NYC TLC into a local `data/` directory.

### 3. Run a query

```bash
duckdb < queries/03_uber_vs_lyft_monthly.sql
```

---

## Why DuckDB + Parquet?

Parquet is a columnar storage format optimized for analytical workloads — it compresses well and allows queries to skip irrelevant columns entirely. DuckDB can query Parquet files directly without loading them into memory or spinning up a server, making it practical for large datasets on a laptop. Query 05 also demonstrates joining Parquet data with a remote CSV file over HTTP in a single SQL statement.

---

## Dataset

- **Source:** NYC Taxi & Limousine Commission
- **Period:** January–December 2022
- **Coverage:** Uber (HV0003) and Lyft (HV0005) trips only
- **Format:** Parquet (columnar), ~5.2 GB uncompressed
- **Reference:** [Data dictionary](https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_hvfhs.pdf)
