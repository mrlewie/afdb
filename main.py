import sys

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

from scripts import data
from scripts.data import MoviesModel, CastModel, ScenesModel
from scripts.data import MovieFunctions

# globals
MOVIE_FOLDER = r'G:\Film\Complete'

if __name__ == "__main__":

    # init app, db
    app = QGuiApplication(sys.argv)
    #app.setAttribute(Qt.AA_UseOpenGLES)

    # init engine and load qml file
    engine = QQmlApplicationEngine()
    engine.load("qml/main.qml")

    # connect to db, open db, check tables, sync folder and db, close
    db = data.connect_to_db('db_init')
    data.create_movies_table(db=db)
    data.create_cast_table(db=db)
    data.create_movies_cast_table(db=db)
    data.create_scenes_table(db=db)
    data.create_scenes_view(db=db)
    data.sync_db_and_folders(db=db)
    data.sync_covers(db=db)
    db.close()

    # connect to db and get tables
    movies = MoviesModel()
    cast = CastModel()
    scenes = ScenesModel()

    # set model to qml app
    engine.rootContext().setContextProperty("moviesModel", movies)
    engine.rootContext().setContextProperty("castModel", cast)
    engine.rootContext().setContextProperty("scenesModel", scenes)

    movie_functions = MovieFunctions()
    engine.rootContext().setContextProperty('movieFunctions', movie_functions)

    # quit if nada...
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
