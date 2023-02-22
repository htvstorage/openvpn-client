import requests
from bs4 import BeautifulSoup
import operator
from collections import Counter

guidURL = 'https://dictionary.cambridge.org/browse/english-vietnamese/'

guideURLs = []
extendURLs = []


def start(url, op):
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 6.0; WOW64; rv:24.0) Gecko/20100101 Firefox/24.0'}

    source_code = requests.get(url, headers=headers).text
    # print(source_code)
    soup = BeautifulSoup(source_code, 'html.parser')
    # guide url
    if op == 1:
        for each_text in soup.findAll('a', {'class': 'hlh32 hdb dil tcbd'}):
            # print(each_text)
            # print(each_text.get('href'))
            guideURLs.append(each_text.get('href'))
            for href in each_text.findAll('a'):
                print(href)
                guideURLs.append(href.get('href'))
                print(href.get('href'))
    else:  # extend url
        for each_text in soup.findAll('div', {'class': "hlh32 han"}):
            for each in each_text.findAll('a', {'class': 'tc-bd'}):
                # print(each.get('href'))
                # print(each)
                extendURLs.append(each.get('href'))
                for href in each.findAll('a'):
                    extendURLs.append(href.get('href'))
                    print(href.get('href'))


if __name__ == '__main__':
    # guide url
    for i in 'abcdefghijklmnopqrstuvwxyz':
        start(guidURL+i, 1)
    # extend url
    for g in guideURLs:
        start(g, 2)

    fd = open('guideURLs.txt', 'w')
    print(guideURLs, file=fd)
    fd.close()
    fd = open('extendURLs.txt', 'w')
    print(extendURLs, file=fd)
    fd.close()
