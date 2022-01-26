# imports
import os
import re
import uuid
from subprocess import call

from PySide6.QtCore import Qt, Slot, QRunnable, QThreadPool, QAbstractListModel, QModelIndex, QObject
from PySide6.QtSql import QSqlDatabase, QSqlQuery
from scripts import scraper_iafd, scraper_aebn

# globals
MOVIES_FOLDER = r'G:\Film\Complete'
DB_FOLDER = r'.\db\adb.db'

# https://wiki.qt.io/Selectable-list-of-Python-objects-in-QML good listmodel to object


class MoviesModel(QAbstractListModel):

    def __init__(self, parent=None):
        super(MoviesModel, self).__init__(parent)
        self.movies = []

        # get all existing movies in db
        self.get_movies()

    def data(self, index=QModelIndex(), role=Qt.DisplayRole):
        movie = self.movies[index.row()]
        value = movie.get(list(movie)[role - Qt.UserRole])

        return value

    def roleNames(self):
        roles = {
            hash(Qt.UserRole):      'raw_folder'.encode(),
            hash(Qt.UserRole + 1):  'raw_title'.encode(),
            hash(Qt.UserRole + 2):  'raw_year'.encode(),
            hash(Qt.UserRole + 3):  'iafd_title'.encode(),
            hash(Qt.UserRole + 4):  'iafd_year'.encode(),
            hash(Qt.UserRole + 5):  'iafd_length'.encode(),
            hash(Qt.UserRole + 6):  'iafd_directors'.encode(),
            hash(Qt.UserRole + 7):  'iafd_distributor'.encode(),
            hash(Qt.UserRole + 8):  'iafd_studio'.encode(),
            hash(Qt.UserRole + 9):  'iafd_all_girl'.encode(),
            hash(Qt.UserRole + 10): 'iafd_compilation'.encode(),
            hash(Qt.UserRole + 11): 'iafd_synopsis'.encode(),
            hash(Qt.UserRole + 12): 'iafd_acts'.encode(),
            hash(Qt.UserRole + 13): 'aebn_title'.encode(),
            hash(Qt.UserRole + 14): 'aebn_year'.encode(),
            hash(Qt.UserRole + 15): 'aebn_series'.encode(),
            hash(Qt.UserRole + 16): 'aebn_synopsis'.encode(),
            hash(Qt.UserRole + 17): 'img_fcover_filename'.encode(),
            hash(Qt.UserRole + 18): 'img_bcover_filename'.encode(),
            hash(Qt.UserRole + 19): 'vid_filename'.encode(),
            hash(Qt.UserRole + 20): 'progress'.encode(),
            hash(Qt.UserRole + 21): 'info_lock'.encode()
        }

        return roles

    def rowCount(self, parent=QModelIndex()):
        num_rows = len(self.movies)

        return num_rows

    @Slot()
    def get_movies(self):
        """
        Queries Sql daatabase and returns every movie
        currently within. Resets existing items in qml
        view.

        :return: None.
        """

        # notify
        print('Getting all existing movies')

        # begin the reset model
        self.beginResetModel()

        # open db
        db = connect_to_db('movies_get')

        # query db
        query = QSqlQuery(query='SELECT * FROM MOVIES ORDER BY raw_folder', db=db)
        query.exec()

        # reset movies list and repopulate it
        self.movies = []
        while query.next():
            self.movies.append({
                'raw_filename': query.value(0),
                'raw_title': query.value(1),
                'raw_year': query.value(2),
                'iafd_title': query.value(3),
                'iafd_year': query.value(4),
                'iafd_length': query.value(5),
                'iafd_directors': query.value(6),
                'iafd_distributor': query.value(7),
                'iafd_studio': query.value(8),
                'iafd_all_girl': query.value(9),
                'iafd_compilation': query.value(10),
                'iafd_synopsis': query.value(11),
                'iafd_acts': query.value(12),
                'aebn_title': query.value(13),
                'aebn_year': query.value(14),
                'aebn_series': query.value(15),
                'aebn_synopsis': query.value(16),
                'img_fcover_filename': query.value(17),
                'img_bcover_filename': query.value(18),
                'vid_filename': query.value(19),
                'progress': query.value(20),
                'info_lock': query.value(21)
            })

        # end and emit the reset
        self.endResetModel()

        # close db
        db.close()

    @staticmethod  # todo get around update whole page by using self, see add_movie
    def update_movie(raw_folder, result):
        """

        :param raw_folder:
        :param result:
        :return:
        """

        # notify
        print('Updating movie id: {} with IAFD metadata: {}'.format(raw_folder, result))

        # open db
        db_conn = uuid.uuid4().hex
        db = connect_to_db('movies_update_{}'.format(db_conn))

        # update movie record
        query = QSqlQuery(db=db)
        query.prepare('UPDATE MOVIES SET '
                      'iafd_title =  :iafd_title, '
                      'iafd_year = :iafd_year, '
                      'iafd_length = :iafd_length, '
                      'iafd_directors = :iafd_directors, '
                      'iafd_distributor = :iafd_distributor, '
                      'iafd_studio = :iafd_studio, '
                      'iafd_all_girl = :iafd_all_girl, '
                      'iafd_compilation = :iafd_compilation, '
                      'iafd_synopsis = :iafd_synopsis, '
                      'iafd_acts = :iafd_acts, '
                      'aebn_title = :aebn_title, '           
                      'aebn_year = :aebn_year, '           
                      'aebn_series = :aebn_series, '           
                      'aebn_synopsis = :aebn_synopsis '           
                      'WHERE raw_folder = :raw_folder')

        query.bindValue(':iafd_title', result.get('iafd_title'))
        query.bindValue(':iafd_year', result.get('iafd_year'))
        query.bindValue(':iafd_length', result.get('iafd_length'))
        query.bindValue(':iafd_directors', result.get('iafd_directors'))
        query.bindValue(':iafd_distributor', result.get('iafd_distributor'))
        query.bindValue(':iafd_studio', result.get('iafd_studio'))
        query.bindValue(':iafd_all_girl', result.get('iafd_all_girl'))
        query.bindValue(':iafd_compilation', result.get('iafd_compilation'))
        query.bindValue(':iafd_synopsis', result.get('iafd_synopsis'))
        query.bindValue(':iafd_acts', result.get('iafd_acts'))
        query.bindValue(':aebn_title', result.get('aebn_title'))
        query.bindValue(':aebn_year', result.get('aebn_year'))
        query.bindValue(':aebn_series', result.get('aebn_series'))
        query.bindValue(':aebn_synopsis', result.get('aebn_synopsis'))
        query.bindValue(':raw_folder', raw_folder)
        query.exec()

        # close db
        db.close()

    @staticmethod
    def insert_cast(r_id, actor):
        """
        :param r_id:
        :param actor:
        :return:
        """

        # notify
        print('Inserting actor: {} IAFD metadata into CAST table.'.format(actor.get('name')))

        # open db
        db_conn = uuid.uuid4().hex
        db = connect_to_db('movies_insert_cast_{}'.format(db_conn))

        # add cast members to cast table and associative entity
        query = QSqlQuery(db=db)
        query.prepare('INSERT OR IGNORE INTO CAST (i_name, i_gender, i_bio_url, i_img_url) '
                      'VALUES (:i_name, :i_gender, :i_bio_url, :i_img_url)')
        query.bindValue(':i_name', actor.get('name'))
        query.bindValue(':i_gender', actor.get('gender'))
        query.bindValue(':i_bio_url', actor.get('bio_url'))
        query.bindValue(':i_img_url', actor.get('img_url'))
        query.exec()

        # notify
        print('Associating actor {} with movie: {}.'.format(actor.get('name'), r_id))

        # associate actor and acts with movie
        query = QSqlQuery(db=db)
        query.prepare('INSERT OR IGNORE INTO MOVIE_CAST (m_id, c_id, acts) '
                      'VALUES (:m_id, :c_id, :acts)')
        query.bindValue(':m_id', r_id)
        query.bindValue(':c_id', actor.get('name'))

        # add acts
        if actor.get('acts') is not None:
            query.bindValue(':acts', ', '.join([act for act in actor.get('acts') if act is not None]))

        # execute
        query.exec()

        # close db
        db.close()

    @staticmethod
    def insert_scene(r_id, scene):
        """

        :param r_id:
        :param scene:
        :return:
        """

        # notify
        print('Inserting scene: {} IAFD metadata into SCENE table.'.format(scene.get('scene')))

        # open db
        db_conn = uuid.uuid4().hex
        db = connect_to_db('movies_insert_scene_{}'.format(db_conn))

        # add cast members to cast table and associative entity
        query = QSqlQuery(db=db)
        query.prepare('INSERT OR IGNORE INTO SCENES (r_id, i_scene, i_cast) '
                      'VALUES (:r_id, :i_scene, :i_cast)')
        query.bindValue(':r_id', r_id)
        query.bindValue(':i_scene', scene.get('scene'))
        query.bindValue(':i_cast', scene.get('cast'))
        query.exec()

        # execute
        query.exec()

        # close db
        db.close()

    @Slot(int, str, str, str)
    def sync_with_iafd_worker(self, index, raw_folder, raw_title, raw_year):

        # set up kwargs dict
        kwargs = {
            'index': index,
            'raw_folder': raw_folder,
            'raw_title': raw_title,
            'raw_year': raw_year,
        }

        #self._sync_with_iafd(**kwargs)
        #raise

        # create worker
        worker = Worker(self._sync_with_iafd, **kwargs)

        # add to app global threadpool
        QThreadPool.globalInstance().start(worker)

    def _sync_with_iafd(self, index, raw_folder, raw_title, raw_year):

        # notify
        print('Clicked movie card title: {} and year: {}.'.format(raw_title, raw_year))

        # send to iafd search query scraper
        results = scraper_iafd.get_iafd_search_results(raw_title, raw_year)
        if len(results) > 0:

            # pick best result if exist
            best_result = scraper_iafd.get_best_iafd_search_match(results)

            # extract iafd movie metadata from html
            iafd_url = scraper_iafd.IAFD_ROOT + best_result.get('url')
            iafd_html_content = scraper_iafd.get_html_from_url(iafd_url)
            result_iafd = scraper_iafd.get_all_meta_from_movie_html(iafd_html_content)

            # notify
            print('Found iafd movie metadata: {}'.format(result_iafd))

            # send shop urls to aebn scraper to get associated movie
            result_aebn = scraper_aebn.get_aebn_meta_from_shop_urls(result_iafd.get('iafd_shops'),
                                                                    result_iafd.get('iafd_year'))

            # merge dicts into one if exist, else use iafd only
            result_all = {**result_iafd, **result_aebn} if result_aebn else result_iafd

            # update movie record with iafd
            self.update_movie(raw_folder, result_all)

            # add movie cast to cast table, ignore if already there
            for actor in result_iafd.get('iafd_cast'):
                self.insert_cast(raw_folder, actor)

            # add movie scenes to scene table, ignore if already there
            for scene in result_iafd.get('iafd_scenes'):
                for actor in scene.get('cast').split(','):
                    actor = {
                        'scene': scene.get('scene'),
                        'cast': actor.strip(),
                    }
                    self.insert_scene(raw_folder, actor)

            # get row index from clicked card
            ix = self.index(index, 0)

            # update movie  # todo include others
            movie = self.movies[index]
            movie['iafd_title'] = result_all.get('iafd_title')
            movie['iafd_year'] = result_all.get('iafd_year')
            movie['iafd_distributor'] = result_all.get('iafd_distributor')
            movie['iafd_studio'] = result_all.get('iafd_studio')
            movie['iafd_compilation'] = result_all.get('iafd_compilation')
            movie['iafd_synopsis'] = result_all.get('iafd_synopsis')
            movie['iafd_acts'] = result_all.get('iafd_acts')
            movie['aebn_title'] = result_all.get('aebn_title')
            movie['aebn_year'] = result_all.get('aebn_year')
            movie['aebn_series'] = result_all.get('aebn_series')
            movie['aebn_synopsis'] = result_all.get('aebn_synopsis')

            # replace movie row
            self.movies[index] = movie

            # emit change to qml
            self.dataChanged.emit(ix, ix, self.roleNames())

        else:
            # notify
            print('No movie metadata found.')

    @Slot(str)
    def log(self, msg):
        print(msg)


class CastModel(QAbstractListModel):

    def __init__(self, parent=None):
        super(CastModel, self).__init__(parent)
        self.cast = []

        # get all existing cast in db for movie
        self.get_cast()

    def data(self, index=QModelIndex(), role=Qt.DisplayRole):
        actor = self.cast[index.row()]
        value = actor.get(list(actor)[role - Qt.UserRole])

        return value

    def roleNames(self):
        roles = {
            hash(Qt.UserRole):      'i_name'.encode(),
            hash(Qt.UserRole + 1):  'i_gender'.encode(),
            hash(Qt.UserRole + 2):  'i_bio_url'.encode(),
            hash(Qt.UserRole + 3):  'i_img_url'.encode()
        }

        return roles

    def rowCount(self, parent=QModelIndex()):
        num_rows = len(self.cast)

        return num_rows

    @Slot(str)
    def get_cast(self, movie_id=None):
        """
        Queries Sql daatabase and returns every cast member
        for a specific movie within. Resets existing items in qml
        view.

        :return: None.
        """

        # todo handle none or empty movie id

        # notify
        print('Getting all existing cast')

        # begin the reset model
        self.beginResetModel()

        # open db
        db = connect_to_db('cast_get')

        # query db
        query = QSqlQuery(db=db)
        query.prepare('SELECT C.* '
                      'FROM MOVIE_CAST MC, CAST C '
                      'WHERE MC.m_id = :r_id AND '
                      'MC.c_id = C.i_name '
                      'ORDER BY C.i_gender, C.i_name')
        query.bindValue(':r_id', movie_id)
        query.exec()

        # reset movies list and repopulate it
        self.cast = []
        while query.next():
            self.cast.append({
                'i_name': query.value(0),
                'i_gender': query.value(1),
                'i_bio_url': query.value(2),
                'i_img_url': query.value(3)
            })

        # end and emit the reset
        self.endResetModel()

        # close db
        db.close()


class ScenesModel(QAbstractListModel):

    def __init__(self, parent=None):
        super(ScenesModel, self).__init__(parent)
        self.scenes = []

        # get all existing scenes in db for movie
        self.get_scenes()

    def data(self, index=QModelIndex(), role=Qt.DisplayRole):
        scene = self.scenes[index.row()]
        value = scene.get(list(scene)[role - Qt.UserRole])

        return value

    def roleNames(self):
        roles = {
            hash(Qt.UserRole):      'i_scene_num'.encode(),
            hash(Qt.UserRole + 1):  'i_scene_cast_name'.encode(),
            hash(Qt.UserRole + 2):  'i_scene_gender'.encode(),
            hash(Qt.UserRole + 3):  'i_scene_img_url'.encode(),
            hash(Qt.UserRole + 4):  'i_scene_acts'.encode()
        }

        return roles

    def rowCount(self, parent=QModelIndex()):
        num_rows = len(self.scenes)

        return num_rows

    @Slot(str) # todo this needs clean up
    def get_scenes(self, movie_id=None):
        """
        Queries Sql daatabase and returns every cast member
        for a specific movie within. Resets existing items in qml
        view.

        :return: None.
        """

        # todo handle none or empty movie id
        # todo this fails if something like '5 guys' exists, skips whole scene see white trash whore 6

        # notify
        print('Getting all existing scenes')

        # begin the reset model
        self.beginResetModel()

        # open db
        db = connect_to_db('scenes_get')

        query = QSqlQuery(db=db)
        query.prepare('SELECT SV.* '
                      'FROM SCENES_VIEW SV '
                      'WHERE SV.r_id = :r_id '
                      'ORDER BY SV.i_scene, SV.i_gender, SV.i_cast')
        query.bindValue(':r_id', movie_id)
        query.exec()

        self.scenes = []
        idx, prev_num = 0, 0
        while query.next():

            # if new scene, append fresh dict to scenes
            if query.value(1) != prev_num:
                self.scenes.append({
                    'i_scene_num': 'Scene {}'.format(query.value(1)),
                    'i_scene_cast_name': [query.value(2)],
                    'i_scene_gender': [query.value(3)],
                    'i_scene_img_url': [query.value(4)],
                    'i_scene_acts': query.value(5).split(', ')
                })

                idx = len(self.scenes) - 1
                prev_num = query.value(1)

            # else append values to existing scenes
            else:
                self.scenes[idx]['i_scene_cast_name'].append(query.value(2))
                self.scenes[idx]['i_scene_gender'].append(query.value(3))
                self.scenes[idx]['i_scene_img_url'].append(query.value(4))

                # only include new act and sort todo this could be more efficient
                exist_acts = self.scenes[idx]['i_scene_acts']
                new_acts = [a.strip() for a in query.value(5).split(', ')]
                new_acts = [a for a in new_acts if a not in exist_acts]
                self.scenes[idx]['i_scene_acts'] += new_acts

                # clean up
                self.scenes[idx]['i_scene_acts'] = [a for a in self.scenes[idx]['i_scene_acts'] if a != '']
                self.scenes[idx]['i_scene_acts'].sort()

        # do some final clean ups
        for scene in self.scenes:
            cast_count = len(scene.get('i_scene_cast_name'))
            female_count = len([g for g in scene.get('i_scene_gender') if g == 'Female'])
            male_count = len([g for g in scene.get('i_scene_gender') if g == 'Male'])

            if cast_count == 1 and female_count == 1:
                scene.update({'i_scene_acts': ['Solo']})

            elif cast_count > 1 and cast_count == female_count:
                scene.update({'i_scene_acts': ['Lesbian']})

            elif cast_count > 1 and male_count == 1:
                bad_acts = ['Double Penetration', 'Double Vaginal', 'Double Anal',
                            'Triple Penetration', 'Triple Vaginal', 'Triple Anal', 'Lesbian']
                new_acts = list(set(scene.get('i_scene_acts')) - set(bad_acts))
                scene.update({'i_scene_acts': sorted(new_acts)})

            elif cast_count > 1 and male_count > 1:
                new_acts = list(set(scene.get('i_scene_acts')) - set(['Lesbian']))
                scene.update({'i_scene_acts': sorted(new_acts)})

        # end and emit the reset
        self.endResetModel()

        # close db
        db.close()

    @Slot() # todo this doesnt really get used yet
    def get_max_cast_count(self):

        max_cast_count = 0
        for scene in self.scenes:
            cast_count = len(scene.get('i_scene_cast_name'))
            if cast_count > max_cast_count:
                max_cast_count = cast_count

        print(max_cast_count)
        return max_cast_count


class Worker(QRunnable):

    def __init__(self, fn, *args, **kwargs):
        super(Worker, self).__init__()

        # Store constructor arguments (re-used for processing)
        self.fn = fn
        self.args = args
        self.kwargs = kwargs

    #@Slot()
    def run(self):

        # todo https://realpython.com/python-pyqt-qthread/#multithreading-the-basics
        # Retrieve args/kwargs here; and fire processing using them
        try:
            self.fn(**self.kwargs)  # no result for this method

        except Exception as e:
            raise ValueError(e)

        #else:
            #self.signals.result.emit(result)  # Return the result of the processing

        #finally:
            #self.signals.finished.emit()  # Done


# # # SQL
def connect_to_db(connection_name=None):
    """
    Connect to database, accepts custom connection name
    for threading, if required.

    :param connection_name: Custom name of connection.
    :return: QSqlDatabase file.
    """

    # create db
    db = QSqlDatabase.addDatabase('QSQLITE', connection_name)
    db.setDatabaseName(DB_FOLDER)

    if db.open():
        return db
    else:
        raise ValueError('Cannot initialise database.')


def create_movies_table(db=None):
    """
    Check if MOVIE table exists in db, else create one.
    """

    sql = """
        CREATE TABLE IF NOT EXISTS MOVIES (
            raw_folder TEXT NOT NULL,
            raw_title TEXT NOT NULL,
            raw_year TEXT,
            iafd_title TEXT,
            iafd_year TEXT,
            iafd_length TEXT,
            iafd_directors TEXT,
            iafd_distributor TEXT,
            iafd_studio TEXT,
            iafd_all_girl TEXT,
            iafd_compilation TEXT,
            iafd_synopsis TEXT,
            iafd_acts TEXT,
            aebn_title TEXT,
            aebn_year TEXT,
            aebn_series TEXT,
            aebn_synopsis TEXT,
            img_fcover_filename TEXT,
            img_bcover_filename TEXT,
            vid_filename TEXT,
            progress TEXT,
            info_lock TEXT,
            PRIMARY KEY (raw_folder)
        )
        """

    # ok if table exists, if not create it
    if 'MOVIES' in db.tables():
        return

    # if not, attempt to create it
    query = QSqlQuery(db=db)
    if not query.exec(sql):
        print('Failed to create MOVIES table.')


def create_cast_table(db=None):
    """
    Check if CAST table exists in db, else create one.
    """

    # sql to create movie table
    sql = """
        CREATE TABLE IF NOT EXISTS CAST (
            i_name TEXT,
            i_gender TEXT,
            i_bio_url TEXT,
            i_img_url TEXT,
            PRIMARY KEY (i_name)
        )
        """

    # ok if table exists, if not create it
    if 'CAST' in db.tables():
        return

    # if not, attempt to create it
    query = QSqlQuery(db=db)
    if not query.exec(sql):
        print('Failed to create CAST table.')


def create_movie_cast_table(db=None):
    """
    Check if MOVIE-CAST M:N table exists in db, else create one.
    """

    # sql to create movie table
    sql = """
        CREATE TABLE IF NOT EXISTS MOVIES_CAST (
            m_id TEXT NOT NULL,
            c_id INTEGER NOT NULL,
            acts TEXT,
            PRIMARY KEY (m_id, c_id),
            FOREIGN KEY (m_id) REFERENCES MOVIES(raw_folder),
            FOREIGN KEY (c_id) REFERENCES CAST(i_name)
        )
        """

    # ok if table exists, if not create it
    if 'MOVIES_CAST' in db.tables():
        return

    # if not, attempt to create it
    query = QSqlQuery(db=db)
    if not query.exec(sql):
        print('Failed to create MOVIE_CAST table.')


def create_scenes_table(db=None):
    """
    Check if SCENES table exists in db, else create one.
    """

    # sql to create scenes table
    sql = """
        CREATE TABLE IF NOT EXISTS SCENES (
            r_id TEXT NOT NULL,
            i_scene INTEGER NOT NULL,
            i_cast TEXT NOT NULL,
            PRIMARY KEY (r_id, i_scene, i_cast),
            FOREIGN KEY (r_id) REFERENCES MOVIES(raw_folder),
            FOREIGN KEY (i_cast) REFERENCES CAST(i_name)
        )
        """

    # ok if table exists, if not create it
    if 'SCENES' in db.tables():
        return

    # if not, attempt to create it
    query = QSqlQuery(db=db)
    if not query.exec(sql):
        print('Failed to create SCENES table.')


def create_scenes_view(db=None):
    """
    Check if SCENES view exists in db, else create one.
    """

    sql = """
        CREATE VIEW SCENES_VIEW AS
        SELECT S.r_id, S.i_scene, S.i_cast, C.i_gender, C.i_img_url, MC.acts
        FROM SCENES S, CAST C, MOVIE_CAST MC
        WHERE C.i_name = S.i_cast AND
              (MC.m_id = S.r_id AND MC.c_id = C.i_name)
        """

    # ok if view exists, if not create it
    if 'SCENES_VIEW' in db.tables():
        return

    # if not, attempt to create it
    query = QSqlQuery(db=db)
    if not query.exec(sql):
        print('Failed to create SCENES view.')


def sync_db_and_folders(db=None):
    """
    Scans movies folder for new movie folders not
    currently in sql database and inserts them in
    with minimal available data. Also checks for
    records where folder no longer exists
    and deletes from sql database.

    :param db: A open QSqlDatabase variable.
    :return: None.
    """

    # execute query on current database
    query = QSqlQuery(query='SELECT raw_folder FROM MOVIES ORDER BY raw_folder ASC', db=db)

    # get all sql movie rows that exist
    rows = []
    while query.next():
        rows.append(query.value(0))

    # get movie folders, prepend root folder
    folders = os.listdir(MOVIES_FOLDER)

    # if movie folder (r_id) not in db, add it
    for folder in folders:
        if folder not in rows:

            # notify
            print('New movie found: {}. Adding to db.'.format(folder))

            # parse raw title and year (if exists)
            raw_title = re.sub(r'\s+\([^)]+\)([^()]*)$', '', folder).strip()
            raw_year = re.findall(r'\b\d{4}\b', folder)
            raw_year = raw_year[0] if len(raw_year) == 1 else None

            # insert new record
            query_insert = QSqlQuery(db=db)
            query_insert.prepare('INSERT INTO MOVIES (raw_folder, raw_title, raw_year) '
                                 'VALUES (:raw_folder, :raw_title, :raw_year)')
            query_insert.bindValue(':raw_folder', folder)
            query_insert.bindValue(':raw_title', raw_title)
            query_insert.bindValue(':raw_year', raw_year)
            query_insert.exec()

    # if db row exists but movie folder is gone, remove from db
    for row in rows:
        if row not in folders:

            # notify
            print('Missing movie found: {}. Removing from db.'.format(row))

            # delete old record
            query_delete = QSqlQuery(db=db)
            query_delete.prepare("DELETE FROM MOVIES WHERE raw_folder = :raw_folder")
            query_delete.bindValue(':raw_folder', row)
            query_delete.exec()


# todo clean this up
def sync_covers(db=None):
    """
    :param db:
    :return:
    """

    # build and execute query
    query = QSqlQuery(query='SELECT raw_folder FROM MOVIES ORDER BY raw_folder ASC', db=db)

    # get all sql movie rows that exist
    rows = []
    while query.next():
        rows.append(query.value(0))

    # read folder, get first cover in order asc
    for row in rows:
        imgs = []
        files = os.listdir(os.path.join(MOVIES_FOLDER, row))

        # try and get file based on name
        for file in files:
            if 'poster' in file or '-1' in file:
                imgs = [file]
                break

        # if empty, try last resort
        if len(imgs) == 0:
            imgs = [f for f in files if f.endswith(('.jpg', '.png', '.jpeg'))]
            imgs.sort()

        if len(imgs) > 0:
            img_cover = os.path.join(os.path.join(MOVIES_FOLDER, row, imgs[0]))

            # update sql row
            print('Adding movie cover: {}.'.format(img_cover))
            query_update = QSqlQuery(db=db)
            query_update.prepare('UPDATE MOVIES SET img_fcover_filename = :img_fcover_filename '
                                 'WHERE raw_folder = :raw_folder')
            query_update.bindValue(':img_fcover_filename', img_cover)
            query_update.bindValue(':raw_folder', row)

            # execute
            query_update.exec()


class MovieFunctions(QObject):

    @Slot(QObject)
    def open_movie(self, movie):

        def _open_movie(movie):

            # notify
            print('Opening movie file.')

            # construct full path
            root = movie.property('r_folder')
            folder = movie.property('r_id')
            #file = movie.property('r_filename')  # todo need filename in table
            path = os.path.join(root, folder, folder + '.mkv')  # todo folder solution is temp

            # create cmd strign
            cmd = r"C:\Program Files\MPC-BE x64\mpc-be64.exe"  # todo need to select file from settings table

            # call file
            call([cmd, path])

        # create worker
        kwargs = {'movie': movie}
        worker = Worker(_open_movie, **kwargs)

        # add to app global threadpool
        QThreadPool.globalInstance().start(worker)

    @Slot(QObject)
    def open_folder(self, movie):

        # notify
        print('Opening movie folder.')

        # construct full path
        folder = movie.property('raw_folder')
        path = os.path.join(MOVIES_FOLDER, folder)

        # open windows folder
        os.startfile(path)
