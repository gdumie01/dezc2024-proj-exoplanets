-- IMPORT PARQUET FILES TO EXTERNAL TABLE
CREATE OR REPLACE EXTERNAL TABLE `exo_planets.nasa_exo_planets_raw_ext`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://dezc2024-project-exoplanets/*.parquet']
);

CREATE OR REPLACE TABLE `exo_planets.nasa_exo_planets_raw_optimized`
--PARTITION BY DATE_TRUNC(DATE(TIMESTAMP_ADD(TIMESTAMP('0001-01-01'), INTERVAL disc_year YEAR)), YEAR)
CLUSTER BY default_flag AS
SELECT * FROM `exo_planets.nasa_exo_planets_raw_ext`;