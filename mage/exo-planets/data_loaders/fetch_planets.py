import io
import pandas as pd
import requests
if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@data_loader
def load_data_from_api(*args, **kwargs):
    """
    Template for loading data from API
    """
    query_columns = [
        'pl_name', ## Planet name
        'hostname', ## Host star name
        'sy_snum', 
        'sy_pnum', 
        'disc_year', 
        'disc_locale', 
        'pl_masse', 
        'pl_controv_flag', 
        'pl_orbsmax', 
        'pl_rade', ## Planet radius
        'discoverymethod' ## Planet discovery method
    ]

    base_url = 'https://exoplanetarchive.ipac.caltech.edu/TAP/sync?'
    columns_str = ','.join(query_columns)
    query = f"query=select+{query_columns}+from+ps&format=csv"
    url = base_url + query
    response = requests.get(url)
    
    url = 'https://exoplanetarchive.ipac.caltech.edu/TAP/sync?query=select+pl_name,hostname,sy_snum,sy_pnum,disc_year,disc_locale,pl_masse,pl_controv_flag,pl_orbsmax,pl_orbsmax,pl_rade,discoverymethod+from+ps&format=csv'
    response = requests.get(url)

    return pd.read_csv(io.StringIO(response.text), sep=',')


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'
