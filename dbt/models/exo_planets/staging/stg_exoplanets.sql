{{
    config(
        materialized='view'
    )
}}

select
    -- identifiers
    {{ dbt_utils.generate_surrogate_key(['pl_name']) }} as planet_id,
    -- {{ dbt.safe_cast("disc_year", api.Column.translate_type("integer")) }} as pickup_locationid,
    
    -- timestamps
    --cast(pickup_datetime as timestamp) as pickup_datetime

    cast(pl_name as string) as planet_name,
    cast(hostname as string) as star_name,

from {{ source('staging','planets') }}
-- where EXTRACT(YEAR from pickup_datetime) = 2019

-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var('is_test_run', default=true) %}
  limit 100
{% endif %}