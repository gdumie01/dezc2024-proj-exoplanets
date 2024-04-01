{{ config(materialized='table') }}

select 
    star_id, 
    star_name
from {{ ref('stg_exoplanets') }}