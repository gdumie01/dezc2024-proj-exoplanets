{{ config(materialized='table') }}

select 
    DISTINCT planet_id, 
    planet_name,
    discovery_date,
    discovery_locale,
    discovery_method
from {{ ref('stg_exoplanets') }}