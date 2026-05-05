"""Ejercicio 6

Crea una colección 'contactos' en la BD 'agenda' y realiza el ciclo completo CRUD.
1. Crea la BD 'agenda' y la colección 'contactos'.
2. Inserta 5 contactos con los campos: nombre, telefono, email, grupo ('amigos', 'trabajo' o
'familia').
3. Busca y muestra todos los contactos del grupo 'trabajo'.
4. Actualiza el teléfono de uno de los contactos.
5. Añade el campo 'favorito': True a todos los contactos del grupo 'familia'.
6. Elimina todos los contactos del grupo 'trabajo'.
7. Muestra el recuento final de contactos por grupo.
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


db = client['agenda']
col = db['contactos']
# 2. Insertar contactos
col.insert_many([
 {'nombre': 'Ana', 'telefono': '600111222', 'email': 'ana@mail.com',
'grupo': 'amigos'},
 {'nombre': 'Luis', 'telefono': '600222333', 'email': 'luis@emp.com',
'grupo': 'trabajo'},
 {'nombre': 'María', 'telefono': '600333444', 'email': 'maria@mail.com',
'grupo': 'familia'},
 {'nombre': 'Pedro', 'telefono': '600444555', 'email': 'pedro@emp.com',
'grupo': 'trabajo'},
 {'nombre': 'Elena', 'telefono': '600555666', 'email': 'elena@mail.com',
'grupo': 'familia'},
])
# 3. Filtrar por grupo
for c in col.find({'grupo': 'trabajo'}): print(c['nombre'])
# 4. Actualizar teléfono
col.update_one({'nombre': 'Ana'}, {'$set': {'telefono': '699000111'}})
# 5. Campo favorito a familia
col.update_many({'grupo': 'familia'}, {'$set': {'favorito': True}})
# 6. Eliminar trabajo
col.delete_many({'grupo': 'trabajo'})
# 7. Recuento
for grupo in ['amigos', 'familia']:
 print(grupo, ':', col.count_documents({'grupo': grupo}))