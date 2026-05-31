SELECT COUNT(*)::BIGINT AS rides_in_2022
FROM 'data/*.parquet'
WHERE DATE_PART('year', request_datetime) = 2022;
