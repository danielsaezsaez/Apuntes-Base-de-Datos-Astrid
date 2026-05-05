"""Ejercicio 1

Conecta a tu cluster Atlas y realiza las siguientes operaciones de gestión de bases de
datos.
1. Lista todas las bases de datos disponibles en tu cluster y muéstralas por pantalla.
2. Crea una nueva base de datos llamada 'academia'.
3. Verifica que 'academia' no aparece todavía en la lista (recuerda: aún no tiene datos).
4. Inserta un documento temporal en una colección 'prueba' de 'academia' para que se
materialice.
5. Vuelve a listar las bases de datos y confirma que 'academia' ya aparece.
6. Elimina la base de datos 'academia' y comprueba que desapareció.
"""

from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi
import os 
from dotenv import load_dotenv
load_dotenv()

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
dotenv_path = os.path.join(BASE_DIR, '.env') 
load_dotenv(dotenv_path)

uri = os.getenv("MONGO_URI")

# Create a new client and connect to the server
client = MongoClient(uri, server_api=ServerApi('1'))



# 1. Listar BDs
print(client.list_database_names())
# 2-3. Crear y verificar (no aparece aún)
db = client['academia']
print('academia' in client.list_database_names()) # False
# 4. Materializar la BD
db['prueba'].insert_one({'temp': True})
# 5. Verificar que ahora sí aparece
print('academia' in client.list_database_names()) # True
# 6. Eliminar
client.drop_database('academia')
print(client.list_database_names())
