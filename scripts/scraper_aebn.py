import time
import random
import unidecode
import cloudscraper
from bs4 import BeautifulSoup as bs

from scripts import helpers

IAFD_ROOT = 'https://www.iafd.com/'
IAFD_SEARCH = 'results.asp?searchtype=comprehensive&searchstring={0}'


def get_html_from_url(url):
    """
    Given a URL, connects and captures the raw
    HTML from the site page for later parsing.
    Used to scrape AEBN.

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
        # return a hardcoded error for other methods todo how we handle empty aebn?
        return bs('<h1>page not found </h1>', 'html.parser')


def get_aebn_meta_from_shop_urls(shop_dicts, iafd_year):
    """
    Takes a list of shop name/url dictionaries from iafd result, and an iafd
    year of release, and parses movie information from aebn webpage for aebn
    url (if exists). Result is a dictionary. The iafd year is required.

    :param shop_dicts:
    :param iafd_year:
    :return:
    """

    # iterate each shop and if aebn, parse metadata
    for shop in shop_dicts:
        if shop.get('name') == 'AEBN':

            # form dynamic url and fetch content
            search_url = IAFD_ROOT + shop.get('url')
            content = get_html_from_url(search_url)

            # check if page found, if yes break into list of rows
            page_check = content.find('h1').text.strip().lower()
            if page_check != 'page not found':

                # extract title, release year, movie url from iafd search table row element
                result = {
                    'aebn_title': get_title_from_movie_html(content),
                    'aebn_year': get_year_from_movie_html(content),
                    'aebn_series': get_series_from_movie_html(content),
                    'aebn_synopsis': get_synopsis_from_movie_html(content),
                }

                # if title is empty, url is no good, so skip
                if result.get('aebn_title') is None:
                    continue

                # when iafd year provided, skip if no matching
                if iafd_year and iafd_year != result.get('aebn_year'):  # todo check if int str conflict
                    continue

                # notify and return
                print('Extracted all metadata from AEBN movie html: {}.'.format(result))
                return result


def get_title_from_movie_html(elem):
    """
    Parse movie title from an AEBN movie page element.

    :param elem: HTML element for a page of HTML.
    :return: Movie title as string, or None if not found.
    """
    try:
        # check element
        if elem.find(class_='md-movieTitle'):

            # get title from header
            value = elem.find(class_='md-movieTitle').text.strip()
            if value:
                print('Found movie title from AEBN html: {}.'.format(value))
                return value

    except:
        print('Error during AEBN movie title extract.')
        return


def get_year_from_movie_html(elem):
    """
    Parse movie release year from an AEBN movie page element.

    :param elem: HTML element for a page of HTML.
    :return: Movie release year as string, or None if not found.
    """
    try:
        # check element
        if elem.find(class_='md-detailsRelease'):

            # get year from header, split title off start and cut brackets
            elem = elem.find(class_='md-detailsRelease')
            value = elem.find(class_='detailsLink').text.strip().split('/')[1]
            if value:
                print('Found movie year from AEBN html: {}.'.format(value))
                return value

    except:
        print('Error during AEBN movie year extract.')
        return


def get_series_from_movie_html(elem):
    """
    Parse movie series from an AEBN movie page element.

    :param elem: HTML element for a page of HTML.
    :return: Movie series as string, or None if not found.
    """
    try:
        # check element
        if elem.find(class_='md-detailsSeries'):

            # get title from header
            elem = elem.find(class_='md-detailsSeries')
            value = elem.find(class_='detailsLink').text.strip()
            if value:
                print('Found movie series from AEBN html: {}.'.format(value))
                return value

    except:
        print('Error during AEBN movie series extract.')
        return


def get_synopsis_from_movie_html(elem):
    """
    Parse movie synopsis from an AEBN movie page element.

    :param elem: HTML element for a page of HTML.
    :return: Movie synopsis as string, or None if not found.
    """

    try:
        value = None

        # check element if long description exists
        if elem.find(class_='movieDetailDescriptionFull longDescription'):
            elem = elem.find(class_='movieDetailDescriptionFull longDescription')
            value = elem.findAll('span')[1].text.strip()

        elif elem.find(class_='movieDetailDescriptionOnly'):
            elem = elem.find(class_='movieDetailDescriptionOnly')
            value = elem.findAll('span')[1].text.strip()

        if value:
            print('Found movie synopsis from AEBN html: {}.'.format(value))
            return value

    except:
        print('Error during AEBN movie synopsis extract.')
        return
