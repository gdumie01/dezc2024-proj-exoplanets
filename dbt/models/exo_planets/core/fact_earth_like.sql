{{ config(materialized='table') }}

with planet_features as (
    select *
    from {{ ref('dim_planets') }}
)
select
    (6.67430e-11 * (coalesce(planet_features.planet_mass, 0) * 5.972e24) / power(6371000 * planet_features.planet_radius, 2)) as surface_gravity
from planet_features