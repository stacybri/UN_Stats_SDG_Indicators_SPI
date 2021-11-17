# Import packages
import requests
import json
import pandas as pd

# Construct the URL for the API call
URL     = "https://unstats.un.org/SDGAPI/v1/sdg/Indicator/List"

# Submit the API data request
data = requests.get(URL).json()

# Convert the JSON data to a pandas data frame
indicator_metadata  = pd.read_json(json.dumps(data))
indicator_metadata = pd.json_normalize(data, record_path='series',
                                        meta=['goal','target','code','description', 'tier'],
                                        errors='ignore',
                                        record_prefix="m_")


indicator_metadata_t1 = indicator_metadata[indicator_metadata.tier=='1']

series_codes=indicator_metadata['m_code'].tolist()

#fetch data from API
URL = 'https://unstats.un.org/SDGAPI/v1/sdg/Series/Data?seriesCode='+series_codes[0]
sdg_json = requests.get(URL).json()

sdg_df=pd.json_normalize(sdg_json, record_path='data')


pd.read_json(  )