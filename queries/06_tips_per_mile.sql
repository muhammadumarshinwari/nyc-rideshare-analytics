-- Compare tipping generosity between Uber and Lyft riders (tips per mile)
SELECT 'HV0003' AS hvfhs_license_num, 'Uber' AS company, AVG(tips / trip_miles) AS tips_per_mile
FROM 'data/*.parquet'
WHERE DATE_PART('year', request_datetime) = 2022
  AND trip_miles > 0
  AND hvfhs_license_num = 'HV0003'
UNION ALL
SELECT 'HV0005' AS hvfhs_license_num, 'Lyft' AS company, AVG(tips / trip_miles) AS tips_per_mile
FROM 'data/*.parquet'
WHERE DATE_PART('year', request_datetime) = 2022
  AND trip_miles > 0
  AND hvfhs_license_num = 'HV0005';
