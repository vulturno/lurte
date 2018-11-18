import requests
import os

# Importando la variable de entorno con el apikey de la aemet
apikey = os.environ['APIKEY_AEMET']

url = "https://opendata.aemet.es/opendata/api/valores/climatologicos/inventarioestaciones/todasestaciones/"

querystring = {"api_key": apikey}

headers = {
    'cache-control': "no-cache"
    }

response = requests.request("GET", url, headers=headers, params=querystring)

print(response.text)
