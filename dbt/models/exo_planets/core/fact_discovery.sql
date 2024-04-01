{{ config(materialized='table') }}

select 
    DISTINCT planet_id, 
    planet_name,
    dicovery_year,
    discovery_locale
from {{ ref('stg_exoplanets') }}