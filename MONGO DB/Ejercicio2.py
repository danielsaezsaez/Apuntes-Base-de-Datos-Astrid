"""Ejercicio 2

Crea la base de datos 'biblioteca' y gestiona sus colecciones.
1. Crea la base de datos 'biblioteca' y dentro de ella las colecciones 'libros', 'autores' y
'socios'.
2. Lista todas las colecciones de 'biblioteca' para verificar que se crearon correctamente.
3. Renombra la colección 'socios' a 'usuarios'.
4. Elimina la colección 'autores'.
5. Muestra el estado final de las colecciones en 'biblioteca'.
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


db = client['biblioteca']
# 1. Crear colecciones con un documento inicial
db['libros'].insert_one({'titulo': 'El Quijote', 'año': 1605})
db['autores'].insert_one({'nombre': 'Cervantes'})
db['socios'].insert_one({'nombre': 'Ana García'})
# 2. Listar colecciones
print(db.list_collection_names())
# 3. Renombrar
db['socios'].rename('usuarios')
# 4. Eliminar colección
db['autores'].drop()
# 5. Estado final
print('Final:', db.list_collection_names())
# Resultado: ['libros', 'usuarios']
