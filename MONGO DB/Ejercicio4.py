"""Ejercicio 4

Trabaja con la colección 'productos' en la base de datos 'tienda_online'.
1. Crea la BD 'tienda_online' y la colección 'productos'.
2. Inserta individualmente un producto: {'nombre': 'Libro Python', 'precio': 34.95, 'stock':
200, 'categoria': 'libros'}.
3. Inserta de una vez 4 productos más de distintas categorías (electrónica, ropa, etc.).
4. Muestra todos los documentos de la colección.
5. Busca y muestra solo los productos con precio superior a 50€.
6. Muestra únicamente los campos 'nombre' y 'precio' (sin _id) de todos los productos,
ordenados de más barato a más caro.
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
# 2. Insertar uno
col.insert_one({'nombre': 'Libro Python', 'precio': 34.95,
 'stock': 200, 'categoria': 'libros'})
# 3. Insertar varios
col.insert_many([
 {'nombre': 'Smartphone', 'precio': 499, 'stock': 30, 'categoria':
'electronica'},
 {'nombre': 'Camiseta', 'precio': 19.99, 'stock': 150, 'categoria': 'ropa'},
 {'nombre': 'Tablet', 'precio': 299, 'stock': 45, 'categoria':
'electronica'},
 {'nombre': 'Zapatillas', 'precio': 65, 'stock': 80, 'categoria': 'ropa'},
])
# 4. Mostrar todos
for doc in col.find(): print(doc)
print("-------------------------- ")
# 5. Precio > 50
for doc in col.find({'precio': {'$gt': 50}}): print(doc)
print("-------------------------- ")
# 6. Proyección y orden
for doc in col.find({}, {'nombre': 1, 'precio': 1, '_id': 0}).sort('precio',
1):
 print(doc)