{{ config(materialized='table') }}

select 
    DISTINCT planet_id, 
    planet_name,
    planet_mass,
    planet_radius,
    planet_distance_to_host
from {{ ref('stg_exoplanets') }}