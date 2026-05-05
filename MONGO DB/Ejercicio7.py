"""Ejercicio 7

Gestiona una colección 'puntuaciones' con operaciones avanzadas de actualización.
1. Crea la BD 'videojuegos' y la colección 'puntuaciones'.
2. Inserta 6 jugadores con los campos: jugador, juego, puntos (número), nivel y victorias
(número).
3. Muestra los 3 jugadores con mayor puntuación.
4. Incrementa en 100 puntos y en 1 victoria a todos los jugadores con más de 500 puntos.
5. Usa $mul para doblar el número de puntos del jugador con más victorias.
6. Elimina los jugadores con menos de 200 puntos.
7. Muestra el ranking final ordenado por puntos descendente.
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



db = client['videojuegos']
col = db['puntuaciones']
# 2. Insertar jugadores
col.insert_many([
    {'jugador': 'AlphaWolf', 'juego': 'Quake', 'puntos': 1200, 'nivel': 10,
'victorias': 8},
 {'jugador': 'ByteQueen', 'juego': 'Quake', 'puntos': 850, 'nivel': 7,
'victorias': 5},
 {'jugador': 'PixelKing', 'juego': 'Tetris', 'puntos': 620, 'nivel': 5,
'victorias': 3},
 {'jugador': 'NullPtr', 'juego': 'Tetris', 'puntos': 150, 'nivel': 2,
'victorias': 1},
 {'jugador': 'DataNinja', 'juego': 'Pong', 'puntos': 430, 'nivel': 4,
'victorias': 2},
 {'jugador': 'SyntaxError', 'juego': 'Pong', 'puntos': 90, 'nivel': 1,
'victorias': 0},
])
# 3. Top 3
top3 = col.find({},{'_id':0}).sort('puntos', -1).limit(3)
for p in top3: print(p['jugador'], p['puntos'])
# 4. Incrementar puntos y victorias
col.update_many({'puntos': {'$gt': 500}},
 {'$inc': {'puntos': 100, 'victorias': 1}})
# 5. Doblar puntos del más victorioso
top = col.find_one(sort=[('victorias', -1)])
col.update_one({'_id': top['_id']}, {'$mul': {'puntos': 2}})
# 6. Eliminar puntos bajos
col.delete_many({'puntos': {'$lt': 200}})
# 7. Ranking final
for p in col.find({},{'_id':0}).sort('puntos',-1):
 print(f"{p['jugador']}: {p['puntos']} pts")
