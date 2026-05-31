SELECT
  COALESCE(zone.Borough, 'Unknown') AS pickup_borough,
  SUM(t.congestion_surcharge) AS total_surcharge
FROM 'data/*.parquet' AS t
LEFT JOIN read_csv_auto('https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv') AS zone
  ON t.PULocationID = zone.LocationID
WHERE DATE_PART('year', t.request_datetime) = 2022
GROUP BY 1
ORDER BY total_surcharge DESC;
