WITH trips AS (
  SELECT *
  FROM 'data/*.parquet'
  WHERE DATE_PART('year', request_datetime) = 2022
),
zones AS (
  SELECT *
  FROM read_csv_auto('https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv')
),
hourly_pairs AS (
  SELECT
    DATE_PART('hour', trips.request_datetime)::BIGINT AS hour,
    pu_zone.Borough || ' - ' || pu_zone.Zone AS pu_location,
    do_zone.Borough || ' - ' || do_zone.Zone AS do_location,
    COUNT(*)::BIGINT AS cnt
  FROM trips
  INNER JOIN zones AS pu_zone ON trips.PULocationID = pu_zone.LocationID
  INNER JOIN zones AS do_zone ON trips.DOLocationID = do_zone.LocationID
  GROUP BY 1, 2, 3
),
ranked AS (
  SELECT
    hour,
    pu_location,
    do_location,
    cnt,
    ROW_NUMBER() OVER (PARTITION BY hour ORDER BY cnt DESC) AS rn
  FROM hourly_pairs
)
SELECT hour, pu_location, do_location, cnt AS count
FROM ranked
WHERE rn = 1
ORDER BY hour;
