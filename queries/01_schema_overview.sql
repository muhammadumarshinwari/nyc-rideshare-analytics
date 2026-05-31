CREATE OR REPLACE VIEW nyc_taxi AS SELECT * FROM 'data/*.parquet';
DESCRIBE nyc_taxi;
