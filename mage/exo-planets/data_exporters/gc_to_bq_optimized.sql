-- IMPORT PARQUET FILES TO EXTERNAL TABLE
CREATE OR REPLACE EXTERNAL TABLE `exo_planets.nasa_exo_planets_raw_ext`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://dezc2024-project-exoplanets/*.parquet']
);

-- As we are filtering out all non-default plant configurations on the layers above we should cluster by default_flag
-- In order to prepare for future use cases I am also partioning by discovery Year, although that would not be needed at this stage
CREATE OR REPLACE TABLE `exo_planets.nasa_exo_planets_raw_optimized`
PARTITION BY TIMESTAMP_TRUNC(discovery_date, YEAR)
CLUSTER BY default_flag AS 
SELECT * FROM `exo_planets.nasa_exo_planets_raw_ext`;