-- Inspect the schema of the NYC TLC high-volume FHV trip data
CREATE OR REPLACE VIEW nyc_taxi AS SELECT * FROM 'data/*.parquet';
DESCRIBE nyc_taxi;
