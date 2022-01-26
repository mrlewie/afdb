import time
import random
import unidecode
import cloudscraper
from bs4 import BeautifulSoup as bs

from scripts import helpers

IAFD_ROOT = 'https://www.iafd.com/'
IAFD_SEARCH = 'results.asp?searchtype=comprehensive&searchstring={0}'


def clean_search_title(title):
    """
    Takes a movie title as a string and removes
    bad characters and removes 'The' from beginning
    of title.

    :param title: Name of movie as a string.
    :return: Cleaned title of movie as a string.
    """
    try:
        if title:
            # remove the from start of title
            if title.split(' ', 1)[0] == 'The':
                title = title.split(' ', 1)[1]

            # strip bad characters
            return unidecode.unidecode(title).strip()

    except:
        return


def clean_search_year(year):
    """
    Takes a movie release year as a string checks it
    for digits. Converts to integer on way out.

    :param year: Release year of movie as a string.
    :return: Clean release year as integer.
    """
    try:
        if len(year.strip()) == 4 and year.strip().isdigit():
            return int(year.strip())

    except:
        return


def get_html_from_url(url):
    """
    Given a URL, connects and captures the raw
    HTML from the site page for later parsing.
    Used to scrape IAFD, HotMovies and others.

    :param url: A URL for a website page.
    :return: The raw HTML code as text string.
    """

    try:
        # let's not overload the server... wait a bit...
        time.sleep(random.randint(1, 5))

        # set browser parameters. note: scraperbot solved iafd issues
        browser = {'browser': 'chrome', 'custom': 'ScraperBot/1.0'}

        # fetch html for current url via cloudscraper
        scraper = cloudscraper.create_scraper(browser=browser)
        response = scraper.get(url)

        # convert html (as text) to elements we can parse
        return bs(response.text, 'html.parser')

    except:
        # return a hardcoded error for other methods
        return bs('<h1>page not found </h1>', 'html.parser')


# # # SEARCH HTML PARSERS
def get_title_from_search_html(elem):
    """
    Parse title from an IAFD search result table row element.

    :param elem: HTML element for a single row from table.
    :return: Title of movie as string, or None if not found.
    """
    try:
        if elem.find(class_='pop-execute'):

            # get title from row (first cell)
            value = elem.find_all('td')[0].text.strip()
            if value:
                print('Found title from IAFD html: {}.'.format(value))
                return value

    except:
        print('Error during IAFD title extract.')
        return


def get_year_from_search_html(elem):
    """
    Parse release year from an IAFD search result table row element.

    :param elem: HTML element for a single row from table.
    :return: Release year of movie as integer, or None if not found.
    """
    try:
        if elem.find(class_='pop-execute'):

            # get year from row (second cell)
            value = elem.find_all('td')[1].text.strip()
            if value and len(value) == 4:
                print('Found release year from IAFD html: {}.'.format(value))
                return int(value)

    except:
        print('Error during IAFD release year extract.')
        return


def get_url_from_search_html(elem):
    """
    Parse movie URL from an IAFD search result table row element.

    :param elem: HTML element for a single row from table.
    :return: IAFD URL of movie as string, or None if not found.
    """
    try:
        if elem.find(class_='pop-execute'):

            # get iafd page url from row (3rd element)
            value = elem.find_all('td')[0].find('a').get('href').strip()
            if value:
                print('Found URL from IAFD html: {}.'.format(value))
                return value

    except:
        print('Error during IAFD URL extract.')
        return


def get_iafd_search_results(search_title, search_year):
    """
    Takes a movie title and optionally a year of release and sends to
    IAFD search. IAFDSearch result returned is a table HTML object. We
    move through rows and parse title, year, url to IAFD movie page. These
    results are stored in dictionaries, with a score value indicating how
    close the movie title matched the IAFD movie title.

    :param search_title:
    :param search_year:
    :return:
    """

    # check and conform plex input title and year values
    search_title = clean_search_title(search_title)
    search_year = clean_search_year(search_year)

    # create iafd encoded search url and grab content
    encoded_title = helpers.encode_text_for_url(search_title)

    # form dynamic url and fetch content
    search_url = IAFD_ROOT + IAFD_SEARCH.format(encoded_title)
    content = get_html_from_url(search_url)

    # check if page found, if yes break into list of rows
    page_check = content.find('h1').text.strip().lower()
    if page_check != 'page not found':

        # get html contents / elements
        elements = content.find(id='titleresult').find_all('tr')

        # loop through content rows and build movies
        results = []
        for elem in elements:

            # extract title, release year, movie url from iafd search table row element
            result = {
                'title': get_title_from_search_html(elem),
                'year': get_year_from_search_html(elem),
                'url': get_url_from_search_html(elem),
                'score': None
            }

            # if title is empty, row is no good, so skip
            if result.get('title') is None:
                continue

            # when search year provided in app/filename, skip if no matching
            if search_year and search_year != result.get('year'):
                continue

            # if movie found, add similarity score and add to results list
            match_score = helpers.calc_similarity(search_title, result.get('title'))
            if match_score is not None and match_score > 50:  # todo implement 50? misses signular results < 50 that could be right
                result['score'] = match_score
                results.append(result)

        return results


def get_best_iafd_search_match(results):
    """
    Takes a list of dicts containing IAFD search result
    values, finds the highest match score, and returns
    only that movie as a dictionary.

    :param results: A list of IAFD result dicts.
    :return: A single result dict.
    """

    # sort results by score (asc) and get first element (highest)
    sorted_results = sorted(results, key=lambda x: x['score'], reverse=True)
    return sorted_results[0]


# # # MOVIE HTML PARSERS
def get_id_from_movie_html(elem):
    """
    Parse movie id from an IAFD movie page element.

    :param elem: HTML element for a page of HTML.
    :return: Movie ID as string, or None if not found.
    """
    try:
        # check element
        input_name = {'name': 'FilmID'}
        if elem.find('input', input_name):

            # get id from input called film id
            value = elem.find('input', input_name).get('value').strip()
            if value:
                print('Found movie id from IAFD html: {}.'.format(value))
                return value

    except:
        print('Error during IAFD movie id extract.')
        return


def get_title_from_movie_html(elem):
    """
    Parse movie title from an IAFD movie page element.

    :param elem: HTML element for a page of HTML.
    :return: Movie title as string, or None if not found.
    """
    try:
        # check element
        if elem.find('h1'):

            # get title from header, split year off end
            value = elem.find('h1').text.strip().rsplit(' ', 1)[0]
            if value:
                print('Found movie title from IAFD html: {}.'.format(value))
                return value

    except:
        print('Error during IAFD movie title extract.')
        return


def get_year_from_movie_html(elem):
    """
    Parse movie release year from an IAFD movie page element.

    :param elem: HTML element for a page of HTML.
    :return: Movie release year as string, or None if not found.
    """
    try:
        # check element
        if elem.find('h1'):

            # get year from header, split title off start and cut brackets
            value = elem.find('h1').text.strip().rsplit(' ', 1)[1][1:-1]
            if value:
                print('Found movie year from IAFD html: {}.'.format(value))
                return value

    except:
        print('Error during IAFD movie year extract.')
        return


def get_length_from_movie_html(elem):
    """
    Parse movie length from an IAFD movie page element.

    :param elem: HTML element for a page of HTML.
    :return: Movie length as integer, or None if not found.
    """
    try:
        # check element
        if elem.find(class_='bioheading', text='Minutes'):

            # get length from header
            value = elem.find(class_='bioheading', text='Minutes').nextSibling.text.strip()
            if value:
                print('Found movie length from IAFD html: {}.'.format(value))
                return value

    except:
        print('Error during IAFD movie length extract.')
        return


def get_directors_from_movie_html(elem):
    """
    Parse movie director(s) from an IAFD movie page element.

    :param elem: HTML element for a page of HTML.
    :return: Movie director(s) as list, or None if not found.
    """
    try:
        # check element
        if elem.find(class_='bioheading', text='Directors'):

            # get director(s) from header, add to list for multiple, convert to string
            dirs = elem.find(class_='bioheading', text='Directors').nextSibling.find_all('a')
            value = [dir.text.strip() for dir in dirs]
            value = ','.join(value)

            if value:
                print('Found movie directors from IAFD html: {}.'.format(value))
                return value

    except:
        print('Error during IAFD movie directors extract.')
        return


# todo check if this can hold multiple
def get_distributor_from_movie_html(elem):
    """
    Parse movie distributor from an IAFD movie page element.

    :param elem: HTML element for a page of HTML.
    :return: Movie distributor as list, or None if not found.
    """
    try:
        # check element
        if elem.find(class_='bioheading', text='Distributor'):

            # get distributor from header
            value = elem.find(class_='bioheading', text='Distributor').nextSibling.text.strip()
            if value:
                print('Found movie distributor from IAFD html: {}.'.format(value))
                return value

    except:
        print('Error during IAFD movie distributor extract.')
        return


# todo check if this can hold multiple
def get_studio_from_movie_html(elem):
    """
    Parse movie studio from an IAFD movie page element.

    :param elem: HTML element for a page of HTML.
    :return: Movie studio as list, or None if not found.
    """
    try:
        # check element
        if elem.find(class_='bioheading', text='Studio'):

            # get studio from header
            value = elem.find(class_='bioheading', text='Studio').nextSibling.text.strip()
            if value:
                print('Found movie studio from IAFD html: {}.'.format(value))
                return value

    except:
        print('Error during IAFD movie studio extract.')
        return


def get_compilation_from_movie_html(elem):
    """
    Parse movie compilation from an IAFD movie page element.

    :param elem: HTML element for a page of HTML.
    :return: Movie compilation as list, or None if not found.
    """
    try:
        # check element
        if elem.find(class_='bioheading', text='Compilation'):

            # get studio from header
            value = elem.find(class_='bioheading', text='Compilation').nextSibling.text.strip()
            if value:
                print('Found movie compilation from IAFD html: {}.'.format(value))
                return value

    except:
        print('Error during IAFD movie compilation extract.')
        return


def get_all_girl_from_movie_html(elem):
    """
    Parse movie all girl information from an IAFD movie page element.

    :param elem: HTML element for a page of HTML.
    :return: Movie all girl as text, or None if not found.
    """
    try:
        # check element
        if elem.find(class_='bioheading', text='All-Girl'):

            # get all girl from header
            value = elem.find(class_='bioheading', text='All-Girl').nextSibling.text.strip()
            if value:
                print('Found movie all girl from IAFD html: {}.'.format(value))
                return value

    except:
        print('Error during IAFD movie all girl extract.')
        return


def get_synopsis_from_movie_html(elem):
    """
    Parse movie synopsis from an IAFD movie page element.

    :param elem: HTML element for a page of HTML.
    :return: Movie synopsis as list, or None if not found.
    """
    try:
        # check element
        if elem.find(id='synopsis'):

            # get synopsis from header
            value = elem.find(id='synopsis').find('li').text

            if value:
                print('Found movie synopsis from IAFD html: {}.'.format(value))

                return value

    except:
        print('Error during IAFD movie synopsis extract.')
        return


def get_cast_from_movie_html(elem):
    """
    Parse movie cast from an IAFD movie page element.

    :param elem: HTML element for a page of HTML.
    :return: Movie cast as a list of dicts, or None if not found.
    """
    try:
        # check element
        if elem.find_all(class_='castbox'):

            cast = []
            for castbox in elem.find_all(class_='castbox'):

                # get name, bio page url and gender
                name = castbox.find('p').find('a').text.strip()
                bio_url = castbox.find('p').find('a').get('href').strip()
                gender = 'Female' if 'gender=f' in bio_url else 'Male'

                # get profile photo url, set to None if nophoto
                img_url = castbox.find('p').find('a').find('img').get('src').strip()
                img_url = None if 'nophoto' in img_url else img_url

                # grab and unpack sex acts if exist, else none
                acts = None
                if castbox.find_all('br')[-4].nextSibling.text:
                    acts = castbox.find_all('br')[-4].nextSibling.text.strip().split(' ')
                    acts = clean_act_names(acts)

                # create actor dictionary
                actor = {
                    'name': name,
                    'gender': gender,
                    'acts': acts,
                    'bio_url': bio_url,
                    'img_url': img_url
                }

                # append to cast
                cast.append(actor)

            # if somehow cast is still empty, set to None
            if len(cast) > 0:
                print('Found cast from IAFD html: {}.'.format(cast))
                return cast

    except:
        print('Error during IAFD movie cast extract.')
        return


def get_scenes_from_movie_html(elem):
    """
    Parse movie scene information from an IAFD movie page element.

    :param elem: HTML element for a page of HTML.
    :return: Movie scenes as a dict, or None if not found.
    """
    try:
        # check element
        if elem.find(id='sceneinfo'):

            # get scenes from table
            scenes = []
            for idx, scene in enumerate(elem.find(id='sceneinfo').find_all('li'), start=1):

                # remove pre-text scene from cast list
                cast = scene.text
                if cast.lower().startswith('scene '):
                    cast = ' '.join(cast.split(' ')[2:]).strip()

                # create actor dictionary
                scene = {
                    'scene': idx,
                    'cast': cast
                }

                # append to cast
                scenes.append(scene)

            # return scenes if exist, else None
            if len(scenes) > 0:
                print('Found movie scenes from IAFD html: {}.'.format(scenes))
                return scenes

    except:
        print('Error during IAFD movie scenes extract.')
        return


def get_shops_for_movie_html(elem):
    """
    Parse movie shop items from an IAFD movie page element.

    :param elem: HTML element for a page of HTML.
    :return: Movie shop items as list, or None if not found.
    """
    try:
        # check element
        if elem.find(id='commerce'):
            shops = []

            for elem in elem.find(id='commerce').find(class_='item').find_all('a'):

                # build shop dictionaries
                shop_dict = {
                    'name': elem.text,
                    'url': elem.get('href')
                }

                # add to list
                shops.append(shop_dict)

            # if shops exist, return list else None
            if len(shops) > 0:
                print('Found shops from IAFD html: {}.'.format(shops))
                return shops

    except:
        print('Error during IAFD movie shops extract.')
        return


def get_all_acts_from_movie_html(elem):
    """
    Parse all unique movie sex acts from an IAFD movie page element.

    :param elem: HTML element for a page of HTML.
    :return: Movie cast as a list of dicts, or None if not found.
    """
    try:
        # check element
        if elem.find_all(class_='castbox'):

            all_acts = []
            for castbox in elem.find_all(class_='castbox'):

                # grab and unpack sex acts if exist, else none
                acts = []
                for sibling in castbox.find('a').next_siblings:
                    sibling = sibling.text.strip()

                    if sibling != '' and not sibling.startswith('(Credited:'):
                        acts = sibling.split(' ')
                        acts = clean_act_names(acts)

                # append to cast
                all_acts += acts

            # if somehow cast is still empty, set to None
            if len(all_acts) > 0:

                # get unique and sort
                all_acts = list(set(all_acts))
                all_acts.sort()

                # convert to string
                all_acts = ','.join([act for act in all_acts])

                # gimme it all
                print('Found all unique acts from IAFD html: {}.'.format(all_acts))
                return all_acts

    except:
        print('Error during IAFD movie all acts extract.')
        return


def get_all_meta_from_movie_html(elem):
    """
    Takes all

    :param elem:
    :return:
    """
    try:
        meta = {
            #'iafd_id': get_id_from_movie_html(elem),
            'iafd_title': get_title_from_movie_html(elem),
            'iafd_year': get_year_from_movie_html(elem),
            'iafd_length': get_length_from_movie_html(elem),
            'iafd_directors': get_directors_from_movie_html(elem),
            'iafd_distributor': get_distributor_from_movie_html(elem),
            'iafd_studio': get_studio_from_movie_html(elem),
            'iafd_all_girl': get_all_girl_from_movie_html(elem),
            'iafd_compilation': get_compilation_from_movie_html(elem),
            'iafd_synopsis': get_synopsis_from_movie_html(elem),
            'iafd_acts': get_all_acts_from_movie_html(elem),
            'iafd_cast': get_cast_from_movie_html(elem),
            'iafd_scenes': get_scenes_from_movie_html(elem),
            'iafd_shops': get_shops_for_movie_html(elem)
        }

        # notify and return
        print('Extracted all metadata from IAFD movie html.')
        return meta

    except:
        print('Something went wrong during extraction of all metadata from IAFD movie html.')


def clean_act_names(acts):
    """
    Takes a list of raw IAFD sex act labels and
    makes them neat. Example: DP to Double Penetration.

    :param raw_acts: A list of raw sex act strings.
    :return: A list of clean sex act strings.
    """

    # map of acts
    act_map = {
        'DP': 'Double Penetration',
        'DAP': 'Double Anal',
        'DPP': 'Double Vaginal',
        'TP': 'Triple Penetration',
        'TAP': 'Triple Anal',
        'TPP': 'Triple Vaginal',
        'A2M': 'Ass to Mouth',
        'GS': 'Golden Shower',
        'IR': 'Interracial',
        'LezOnly': 'Lesbian',
        'BJOnly': 'Blow Job',
        'Footjob': 'Foot Job',
        'CumSwap': 'Cum Swapping',
        'MastOnly': 'Masturbation',
        'NonSex': 'Non-Sex',
        'AnalToy': 'Anal Toys',
        'Swallow': 'Swallowing',
        'Clip': '',
        'DVDOnly': '',
        'Foreign': '',
        'Porn': '',
        ' ': ''
    }

    # replace dirty value with clean from above map
    clean_acts = []
    if acts:
        for act in acts:
            clean_acts.append(act_map.get(act) if act_map.get(act) else act)

        return clean_acts


def detect_gangbang_from_title(title):
    """
    From a movie title, detect if a gang bang type
    feature based on words common to the genre.

    :param title: Movie title as string
    :return: Boolean whether movie is a gangbang feature or not.
    """

    # gangbang flag words
    word_flags = [
        'gangbang',
        'gang-bang',
        'gang bang',
        'orgy',
        'orgies'
    ]

    # iterate flag words and check if in title
    for word_flag in word_flags:
        if word_flag in title:
            print('Found gangbang film from IAFD title.')
            return True

    return False
