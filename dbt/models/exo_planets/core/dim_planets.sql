{{ config(materialized='table') }}

select 
    DISTINCT planet_id, 
    planet_name,
    planet_mass,
    planet_radius,
    planet_distance_to_host,
    (planet_mass * (5.972e24 * 6.67430e-11)) / power(6371000 * planet_radius, 2) as surface_gravity
from {{ ref('stg_exoplanets') }}