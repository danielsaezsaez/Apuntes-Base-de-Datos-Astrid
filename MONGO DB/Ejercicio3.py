"""Ejercicio 3

Crea una colección 'empleados' con validación de datos obligatorios.
1. Crea la base de datos 'empresa'.
2. Crea la colección 'empleados' con un validador JSON Schema que exija los campos:
'nombre' (string), 'departamento' (string) y 'salario' (number).
3. Intenta insertar un documento válido y otro inválido (sin salario). Observa qué ocurre.
4. Lista las colecciones de 'empresa' y muestra la información del validador.
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


db = client['empresa']
# 2. Crear con validación
"""
db.create_collection('empleados', validator={
 '$jsonSchema': {
 'bsonType': 'object',
 'required': ['nombre', 'departamento', 'salario'],
 'properties': {
 'nombre': {'bsonType': 'string'},
 'departamento': {'bsonType': 'string'},
 'salario': {'bsonType': 'number'},
 }
 }
})
"""
# 3. Documento válido
db['empleados'].insert_one(
 {'nombre': 'Luis', 'departamento': 'IT', 'salario': 35000}
)
# Documento inválido (lanza WriteError)
try:
 db['empleados'].insert_one({'nombre': 'Sin salario'})
except Exception as e:
 print('Error esperado:', e)