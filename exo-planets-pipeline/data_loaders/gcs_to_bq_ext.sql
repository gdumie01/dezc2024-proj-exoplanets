-- IMPORT PARQUET FILES TO EXTERNAL TABLE
CREATE OR REPLACE EXTERNAL TABLE `nasa_exo_planets.nasa_exo_planets_raw_ext`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://dezc2024-project-exoplanets/*.parquet']
);

CREATE OR REPLACE TABLE `nasa_exo_planets.nasa_exo_planets_raw`
--PARTITION BY DATE_TRUNC(DATE(TIMESTAMP_ADD(TIMESTAMP('0001-01-01'), INTERVAL disc_year YEAR)), YEAR)
CLUSTER BY pl_name AS
SELECT * FROM `nasa_exo_planets.nasa_exo_planets_raw_ext`;