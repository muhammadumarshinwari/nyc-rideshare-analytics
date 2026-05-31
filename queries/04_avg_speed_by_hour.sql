-- Average trip speed (MPH) by hour of day — reveals NYC traffic congestion patterns
SELECT
  DATE_PART('hour', request_datetime)::BIGINT AS hour,
  AVG(trip_miles / (trip_time / 3600.0)) AS speed_mph
FROM 'data/*.parquet'
WHERE DATE_PART('year', request_datetime) = 2022
  AND trip_time > 0
GROUP BY 1
ORDER BY 1;
