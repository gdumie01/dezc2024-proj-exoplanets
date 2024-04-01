{{ config(materialized='table') }}

with planet_data as (
    select 
        planet_id,
        planet_name,
        planet_distance_to_host,
        planet_mass,
        planet_radius,
        surface_gravity,
        case
            when planet_distance_to_host between 0.75 and 1.75 and surface_gravity between (0.2*9.8) and (5*9.8) then 'Potentially Habitable'
            when planet_distance_to_host between 0.75 and 1.75 then 'Within Goldilock Zone'
            when planet_mass is null or planet_radius is null or planet_distance_to_host is null then 'Features Unknown'
            else 'Not habitable'
        end as earth_like
    from {{ ref('dim_planets') }}
)

select 
    planet_id,
    planet_name,
    earth_like
from planet_data