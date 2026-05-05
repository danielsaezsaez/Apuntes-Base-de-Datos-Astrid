"""Ejercicio 8

Implementa un sistema de biblioteca con gestión de libros, autores y préstamos.
1. Crea la BD 'biblioteca_digital' con las colecciones: 'libros', 'autores' y 'prestamos'.
2. Inserta al menos 3 autores con: nombre, nacionalidad, año_nacimiento.
3. Inserta al menos 6 libros con: titulo, autor_nombre, año, genero, disponible (bool),
copias.
4. Inserta 3 préstamos con: usuario, libro_titulo, fecha_prestamo, devuelto (bool).
5. Consulta: muestra todos los libros disponibles ordenados por título.
6. Consulta: muestra todos los préstamos no devueltos.
7. Actualización: marca como 'devuelto: True' uno de los préstamos y aumenta en 1 las
copias del libro correspondiente.
8. Actualización: descuenta 1 copia y marca 'disponible: False' a los libros con copias = 0.
9. Eliminación: borra todos los préstamos devueltos.
10. Muestra el recuento total de documentos en cada colección al finalizar.
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


#Crea la BD 'biblioteca_digital' con las colecciones: 'libros', 'autores' y 'prestamos'.
db = client['biblioteca_digital']
libros = db ['libros']
autores = db ['autores']
prestamos = db ['prestamos']

#Inserta al menos 3 autores con: nombre, nacionalidad, año_nacimiento.
autores.insert_many([
    {'nombre': 'Keiji Inafune', 'nacionalidad': 'Japones', 'año_nacimiento': 1965},
    {'nombre': 'Robert Kirkman', 'nacionalidad': 'Estadounidense', 'año_nacimiento': 1978},
    {'nombre': 'Garth Ennis', 'nacionalidad': 'Estadounidense', 'año_nacimiento': 1970},
    {'nombre': 'Joshua Ortega', 'nacionalidad': 'Estadounidense', 'año_nacimiento': 1974},
    {'nombre': 'H.P. Lovecraft', 'nacionalidad': 'Estadounidense', 'año_nacimiento': 1890},
])

#Inserta al menos 6 libros con: titulo, autor_nombre, año, genero, disponible (bool), copias.
libros.insert_many([
    {'titulo': 'Dead Rising: Road to Fortune', 'autor_nombre': 'Keiji Inafune', 'año': 2012, 'genero': 'Zombies', 'disponible': True, 'copias': 12},
    {'titulo': 'La llamada de Cthulhu', 'autor_nombre': 'H.P. Lovecraft', 'año': 1928, 'genero': 'Terror', 'disponible': True, 'copias': 70},
    {'titulo': 'Gears of War Omnibus', 'autor_nombre': 'Joshua Ortega', 'año': 2018, 'genero': 'Guerra', 'disponible': True, 'copias': 7},
    {'titulo': 'Invencible Volumen 1', 'autor_nombre' : 'Robert Kirkman', 'año': 2003, 'genero': 'Superheroes', 'disponible': True, 'copias': 20},
    {'titulo': 'The Boys Volumen 1', 'autor_nombre': 'Garth Ennis', 'año': 2007, 'genero': 'Superheroes', 'disponible': True, 'copias': 10},
    {'titulo': 'The Punisher: Welcome Back, Frank', 'autor_nombre': 'Garth Ennis', 'año': 2001, 'genero': 'Superheroes', 'disponible': True, 'copias': 45},
])

#Inserta 3 préstamos con: usuario, libro_titulo, fecha_prestamo, devuelto (bool).
prestamos.insert_many([
    {'usuario': 'Dani', 'libro_titulo': 'Dead Rising: Road to Fortune', 'fecha_prestamo': '2025-05-03', 'devuelto': True},
    {'usuario': 'Francisco', 'libro_titulo': 'Gears of War Omnibus', 'fecha_prestamo': '2025-05-01', 'devuelto': True},
    {'usuario': 'Samuel', 'libro_titulo': 'La llamada de Cthulhu', 'fecha_prestamo': '2025-04-25', 'devuelto': False},
])

#Consulta: muestra todos los libros disponibles ordenados por título.
print("Libros disponibles:")
for l in libros.find({'disponible': True}, {'_id': 0}).sort('titulo', 1):
    print(l)
print("---------------------------------------------------------------------")

#Consulta: muestra todos los préstamos no devueltos.
print("Préstamos no devueltos:")
for p in prestamos.find({'devuelto': False}, {'_id': 0}):
    print(p)
print("---------------------------------------------------------------------")

#Actualización: marca como 'devuelto: True' uno de los préstamos y aumenta en 1 las copias del libro correspondiente.
prestamo = prestamos.find_one({'devuelto': False})
if prestamo: 
    prestamos.update_one({'_id': prestamo['_id']}, {'$set': {'devuelto': True}})
    libros.update_one({'titulo': prestamo['libro_titulo']}, {'$inc': {'copias': 1}})


#Actualización: descuenta 1 copia y marca 'disponible: False' a los libros con copias = 0.
libros.update_many({'copias': 0}, {
    '$inc': {'copias': -1},
    '$set': {'disponible': False}
})

#Eliminación: borra todos los préstamos devueltos.
prestamos.delete_many({'devuelto': True})

#Muestra el recuento total de documentos en cada colección al finalizar.
print("Recuento final:")
print("Libros:", libros.count_documents({}))
print("Autores:", autores.count_documents({}))
print("Préstamos:", prestamos.count_documents({}))


