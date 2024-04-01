{{ config(materialized='table') }}

select 
    DISTINCT planet_id, 
    planet_name,
    dicovery_year,
    discovery_locale,
    discovery_method
from {{ ref('stg_exoplanets') }}