SELECT
  DATE_TRUNC('month', request_datetime)::DATE AS month,
  COUNT(*) FILTER (WHERE hvfhs_license_num = 'HV0003')::BIGINT AS uber,
  COUNT(*) FILTER (WHERE hvfhs_license_num = 'HV0005')::BIGINT AS lyft
FROM 'data/*.parquet'
WHERE DATE_PART('year', request_datetime) = 2022
GROUP BY 1
ORDER BY 1;
