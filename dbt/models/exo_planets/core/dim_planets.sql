{{ config(materialized='table') }}

select 
    DISTINCT planet_id, 
    planet_name
from {{ ref('stg_exoplanets') }}