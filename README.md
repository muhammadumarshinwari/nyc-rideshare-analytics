# NYC Rideshare Analysis (DuckDB + Parquet)

New York City had 212 million Uber and Lyft rides in 2022. That is roughly 582,000 rides every single day, or about 24,000 per hour around the clock.

I pulled the full year of trip data from the NYC Taxi and Limousine Commission and wrote a set of SQL queries to explore it. The dataset is 5.2 GB of Parquet files, one per month. Instead of loading it into a database, I used DuckDB, which can query Parquet files directly on disk without any server setup. All queries ran on a laptop in a few seconds.

The data covers only high-volume for-hire vehicles, which means Uber and Lyft. Yellow cabs and green cabs are separate datasets. Each row is one trip and includes pickup/dropoff location IDs, timestamps, trip distance, trip time, driver pay, tips, and surcharge amounts.

Data source: [NYC TLC High Volume FHV Trip Records](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page)

---

## Findings

**Uber vs Lyft market share**

Uber dominates. Across all 12 months in 2022, Uber ran about 73% of rides and Lyft ran about 27%. The gap was consistent every single month, never narrowing or widening much. In December, Uber completed 14 million rides vs Lyft's 5.7 million.

```
Month       Uber        Lyft
-------     --------    --------
Jan 2022    10,826,774   3,925,415
Feb 2022    11,440,712   4,578,376
Mar 2022    13,137,531   5,317,731
Apr 2022    13,013,210   4,741,984
May 2022    13,322,236   4,831,145
Jun 2022    13,050,448   4,730,469
Jul 2022    12,575,345   4,888,835
Aug 2022    12,500,792   4,684,992
Sep 2022    12,903,754   4,891,902
Oct 2022    14,102,015   5,202,729
Nov 2022    12,967,402   5,117,739
Dec 2022    14,006,682   5,657,204
```

**Traffic speed by hour**

Average trip speed drops from 21 MPH at 4am down to 11.3 MPH at 4pm. That is nearly a 2x difference, and you can see exactly when the morning commute kicks in and when it starts to ease up in the evening. The 4-7pm window is consistently the slowest part of the day.

```
Hour    Speed (MPH)
----    -----------
0       16.3
1       16.7
2       17.2
3       18.8
4       21.1   <- fastest
5       21.0
6       17.9
7       14.4
8       13.3
9       13.7
10      13.7
11      13.3
12      12.9
13      12.6
14      11.9
15      11.5
16      11.3   <- slowest
17      11.3
18      12.0
19      13.1
20      14.1
21      14.9
22      15.2
23      15.8
```

**Most popular routes by hour**

The single most popular pickup-dropoff pair changes depending on the time of day. From about 6am onward, JFK Airport to outside NYC takes the top spot for most hours, peaking at nearly 50,000 rides in a single hour-of-day bucket during the late evening. During the early morning and midday, Brooklyn neighborhoods like East New York and Bushwick dominate, which makes sense given the density of shift workers in those areas.

```
Hour    Top Route                                        Count
----    -----                                            -----
0       Queens - JFK Airport to Outside of NYC           30,886
5       Brooklyn - East New York to East New York        15,128
7       Brooklyn - East New York to East New York        36,411
8       Brooklyn - East New York to East New York        40,656
14      Queens - JFK Airport to Outside of NYC           38,108
21      Queens - JFK Airport to Outside of NYC           49,037
```

**Tipping: Uber vs Lyft**

Uber riders tip slightly more per mile ($0.319 vs $0.304 for Lyft). The difference is small but consistent across the full year of data. Worth noting this only counts trips where a tip was recorded, so cash tips are not included.

**Congestion surcharge by borough**

NYC charges a congestion surcharge for rides that pass through certain zones in Manhattan. In 2022, Manhattan generated $194 million of the $231 million total collected across all boroughs. Brooklyn and Queens together accounted for about $33 million. Staten Island was a distant fifth at $216,000.

```
Borough         Total Surcharge
----------      ---------------
Manhattan       $194,048,957
Brooklyn         $17,680,594
Queens           $15,529,260
Bronx             $3,815,187
Staten Island       $216,170
```

---

## Queries

All queries are in the `queries/` folder. Run any of them with the DuckDB CLI:

```bash
duckdb < queries/03_uber_vs_lyft_monthly.sql
```

| File | What it does |
|---|---|
| `01_schema_overview.sql` | Inspect column names and data types |
| `02_total_rides.sql` | Count total rides in 2022 |
| `03_uber_vs_lyft_monthly.sql` | Monthly ride volume split by platform |
| `04_avg_speed_by_hour.sql` | Average trip speed in MPH for each hour of the day |
| `05_top_routes_by_hour.sql` | Most popular pickup-dropoff pair for each hour |
| `06_tips_per_mile.sql` | Average tip per mile for Uber vs Lyft |
| `07_congestion_surcharge_by_borough.sql` | Total congestion surcharge collected by borough |

Query 05 joins the trip data with the [NYC TLC zone lookup CSV](https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv) directly over HTTP inside the SQL query, no download needed.

---

## Setup

Install DuckDB:

```bash
pip install duckdb
```

Download the data. This grabs all 12 monthly Parquet files for 2022 from the NYC TLC (~5.2 GB total):

```bash
python download_data.py
```

Files go into a `data/` folder. The `.gitignore` makes sure they do not get committed.

---

[Data dictionary](https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_hvfhs.pdf) for full column reference.
