# NYC Rideshare Analysis (DuckDB + Parquet)

I wanted to dig into the NYC TLC rideshare data for 2022 — 212 million Uber and Lyft trips — and DuckDB turned out to be a great fit for this. No database server, just query the Parquet files directly. Ran everything on my laptop.

Data: [NYC TLC High Volume FHV Trip Records](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page)

---

## What I looked at

- How many rides happened in 2022, and how Uber vs Lyft split that volume each month
- Average trip speed by hour — you can clearly see rush hour in the numbers (speeds drop almost in half between 4am and 4pm)
- Which pickup-dropoff routes dominate each hour of the day (JFK to outside NYC is huge in the evenings)
- Whether Uber or Lyft riders tip more per mile
- How congestion surcharge revenue breaks down by borough — Manhattan is overwhelmingly dominant

---

## Queries

All queries are in the `queries/` folder and can be run with the DuckDB CLI:

```bash
duckdb < queries/03_uber_vs_lyft_monthly.sql
```

| File | What it answers |
|---|---|
| `01_schema_overview.sql` | Column names and types |
| `02_total_rides.sql` | Total 2022 ride count |
| `03_uber_vs_lyft_monthly.sql` | Monthly volume by platform |
| `04_avg_speed_by_hour.sql` | Average MPH by hour of day |
| `05_top_routes_by_hour.sql` | Busiest route for each hour |
| `06_tips_per_mile.sql` | Tipping comparison: Uber vs Lyft |
| `07_congestion_surcharge_by_borough.sql` | Surcharge revenue by borough |

---

## Setup

Install DuckDB:

```bash
pip install duckdb
```

Download the data (~5.2 GB):

```bash
python download_data.py
```

This pulls the 12 monthly Parquet files from the NYC TLC into a `data/` folder. The `.gitignore` excludes them so they won't get committed.

---

[Data dictionary](https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_hvfhs.pdf) for column reference.
