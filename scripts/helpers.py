# imports
import urllib.parse
from difflib import SequenceMatcher


def encode_text_for_url(text):
    """
    Takes a raw string and encodes to be url
    friendly.
    :param text: Un-encoded, raw string of text.
    :return: A url-encoded string of text.
    """
    return urllib.parse.quote_plus(text)


def calc_similarity(a, b):
    """
    Gets a value on how close two strings match.
    If strings are identical, score = 100. If
    no match, 0.

    :param a: First string to compare (to b).
    :param b: Second strign to compare (to a).
    :return: The similarity of the strings, from 0 to 100.
    """
    try:
        # check strings, compare, get ratio 0 - 100%
        if a and b:
            score = SequenceMatcher(None, a.lower(), b.lower()).ratio()
            return int(score * 100)

    except:
        print('Error during similarity calculating. Skipping.')
        return