{{
    config(
        materialized='view'
    )
}}

select
    -- identifiers
    {{ dbt_utils.generate_surrogate_key(['pl_name']) }} as planet_id,
    {{ dbt_utils.generate_surrogate_key(['hostname']) }} as star_id,
    {{ dbt.safe_cast("disc_year", api.Column.translate_type("integer")) }} as dicovery_year,
    
    -- timestamps
    --cast(pickup_datetime as timestamp) as pickup_datetime

    cast(pl_name as string) as planet_name,
    cast(hostname as string) as star_name,
    cast(disc_locale as string) as discovery_locale,
    cast(discoverymethod as string) as discovery_method,
    cast(pl_masse as numeric) as planet_mass,
    cast(pl_orbsmax as numeric) as planet_distance_to_host,
    cast(pl_rade as numeric) as planet_radius

from {{ source('staging','nasa_exo_planets_raw_optimized') }}
where default_flag = 1

-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var('is_test_run', default=true) %}
  limit 100
{% endif %}