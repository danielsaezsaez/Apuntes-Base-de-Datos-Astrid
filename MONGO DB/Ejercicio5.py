"""Ejercicio 5

Usa la colección 'productos' del ejercicio anterior para realizar actualizaciones.
1. Actualiza el precio del 'Libro Python' a 29.95€.
2. Añade el campo 'descuento': 10 a todos los productos de la categoría 'electronica'.
3. Incrementa en 50 unidades el stock de todos los productos de la categoría 'libros'.
4. Usa un upsert para añadir el producto {'nombre': 'Auriculares', 'precio': 89.99, 'stock': 60}
si no existe.
5. Elimina el campo 'descuento' de todos los documentos usando $unset.
6. Muestra el estado final de todos los productos.
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

db = client['tienda_online']
col = db['productos']

# 1. Actualizar precio
col.update_one({'nombre': 'Libro Python'}, {'$set': {'precio': 29.95}})
# 2. Añadir campo 'descuento' a electronica
col.update_many({'categoria': 'electronica'}, {'$set': {'descuento': 10}})
# 3. Incrementar stock de libros
col.update_many({'categoria': 'libros'}, {'$inc': {'stock': 50}})
# 4. Upsert
col.update_one(
 {'nombre': 'Auriculares'},
 {'$set': {'precio': 89.99, 'stock': 60}},
 upsert=True
)
# 5. Eliminar campo 'descuento'
col.update_many({}, {'$unset': {'descuento': ''}})
# 6. Estado final
for doc in col.find({}, {'_id': 0}): print(doc)
