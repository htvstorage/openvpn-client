#!/usr/bin/env python
# coding: utf-8

# In[2]:


from bs4 import BeautifulSoup
from collections import defaultdict
import requests
import asyncio
import aiohttp
import datetime
import time

# In[13]:


def extract(soup):
    for entry in soup.select('.entry'):
        for big_block in entry.select('.entry-body__el.clrd.js-share-holder'):
            if big_block.select_one('.pos-header .headword'):
                head_word = big_block.select_one('.headword').text

            pos = big_block.select_one('.pos-header .pos').text
            print('---', head_word, pos, '---')

            for block in big_block.select('.sense-block'):
                guideword = ''
                extra_sents = []
                big_sense = defaultdict(list)
                ch_def = ''
                gcs = ''
                en_def = ''

                if block.select_one('.guideword'):  # guide word
                    guideword = block.select_one('.guideword').text.strip()

                if block.select('.extraexamps .eg'):  # extra sents of a block
                    extra_sents = [
                        extra_sent.text for extra_sent in block.select('.extraexamps .eg')]

                for x in block.select('.sense-body .def-block'):
                    temp = {}

                    if x.select_one('.def-info span.epp-xref'):
                        print(x.select_one(
                            '.def-info span.epp-xref').text.strip())  # 等級
                        level = x.select_one(
                            '.def-info span.epp-xref').text.strip()
                    else:
                        print('NONE')
                        level = 'none'

                    if x.select_one('.def-info .gcs'):
                        #                     print(x.select_one('.def-info .gcs').text.strip())
                        gcs = x.select_one('.def-info .gcs').text.strip()

                    if x.select_one('.def'):
                        en_def = x.select_one('.def').text.strip()
    #                 print(x.select_one('.def').text.strip())

                    if x.select_one('.trans').text:
                        ch_def = x.select_one('.trans').text.strip()

                    examples = []
                    for example in x.select('.examp.emphasized'):  # 例句
                        #                 print(example.select_one('.eg').text)
                        #                 print(example.select_one('.trans').text)
                        if example.select_one('.eg'):
                            eg_sent = example.select_one('.eg').text.strip()
                            examples.append(eg_sent)

                        if example.select_one('.trans'):
                            ch_sent = example.select_one('.trans').text.strip()
                            examples.append(ch_sent)

                    small_info = {'en_def': en_def, 'ch_def': ch_def,
                                  'level': level, 'examples': examples, 'gcs': gcs}
                    big_sense['sense'].append(small_info)

                big_sense['extra_sents'] = extra_sents
                big_sense['guideword'] = guideword

                cam_dict[head_word][pos].append(big_sense)


# In[27]:


def extract_phrase(soup):
    for entry in soup.select('#page-content'):
        # print('------------------------------------')
        for big_block in entry.select('div.pr.di'):
            pos = ''
            head_word = ''
            if big_block.select_one('div.di-title .headword'):
                head_word = big_block.select_one('div.di-title .headword').text

            if big_block.select_one('div.posgram .pos'):
                pos = big_block.select_one('div.posgram .pos').text

            # print('--- HEAD WORD:', head_word, 'POS:', pos, '---')

            for block in big_block.select('.sense-block'):
                guideword = ''
                extra_sents = []
                big_sense = defaultdict(list)
                ch_def = ''
                gcs = ''
                en_def = ''

                if block.select_one('.guideword'):  # guide word
                    guideword = block.select_one('.guideword').text.strip()
                    print(guideword)

                if block.select('.extraexamps .eg'):  # extra sents of a block
                    extra_sents = [
                        extra_sent.text for extra_sent in block.select('.extraexamps .eg')]
                    print(extra_sents)

                for x in block.select('.sense-body .def-block'):
                    temp = {}

                    if x.select_one('.def-info span.epp-xref'):
                        #                         print(x.select_one('.def-info span.epp-xref').text.strip()) # 等級
                        level = x.select_one(
                            '.def-info span.epp-xref').text.strip()
                    else:
                        #                         print('NONE')
                        level = 'none'

                    if x.select_one('.def-info .gcs'):
                        print(x.select_one('.def-info .gcs').text.strip())
                        gcs = x.select_one('.def-info .gcs').text.strip()

                    if x.select_one('.def'):
                        en_def = x.select_one('.def').text.strip()
                        print(en_def)

                    if x.select_one('.trans').text:
                        ch_def = x.select_one('.trans').text.strip()
                        print(ch_def)

                    examples = []
                    for example in x.select('.examp.emphasized'):  # 例句
                        print(example.select_one('.eg').text)
                        print(example.select_one('.trans').text)
                        if example.select_one('.eg'):
                            eg_sent = example.select_one('.eg').text.strip()
                            print(eg_sent)
                            examples.append(eg_sent)

                        if example.select_one('.trans'):
                            ch_sent = example.select_one('.trans').text.strip()
                            print(ch_sent)
                            examples.append(ch_sent)

                    small_info = {'en_def': en_def, 'ch_def': ch_def,
                                  'level': level, 'examples': examples, 'gcs': gcs}
                    big_sense['sense'].append(small_info)

                big_sense['extra_sents'] = extra_sents
                big_sense['guideword'] = guideword

                cam_dict[head_word][pos].append(big_sense)


# In[5]:

timeout = aiohttp.ClientTimeout(total=10)


async def get_request(url, headers):
    try:
        async with aiohttp.ClientSession(timeout=timeout) as session:
            async with session.get(url, headers=headers) as response:
                text = await response.text()
                if len(text) <= 1024:
                    return await get_request(url, headers)
                else:
                    return text
    except:
        return await get_request(url, headers)


async def start(url, head, stat):

    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 6.0; WOW64; rv:24.0) Gecko/20100101 Firefox/24.0'}

    source_code = await get_request(url, headers=headers)
    # print(source_code)
    stat['res'] += 1
    now = int(time.time())
    if stat['res'] % 10 == 0:
        print(stat, "tps ", stat['res']/(now-stat['start']))
    soup = BeautifulSoup(source_code, 'html.parser')
    extract_phrase(soup)


# In[8]:


# if __name__ == '__main__':
#     cam_dict = defaultdict(lambda:  defaultdict(lambda: []))
#     urls = eval(open('extendURLs.txt').read())
#     for r in urls:
#         print(r)
#         w = r.split('/')[-1]
#         if len(w.split('-')) < 2:
#             start(r,r.split('/')[-1])

#     import json
#     with open('cambridge.word.json', 'w') as outfile:
#         json.dump(cam_dict, outfile)


# In[28]:


# if __name__ == '__main__':
#     cam_dict = defaultdict(lambda:  defaultdict(lambda: []))
#     # urls = eval(open('extendURLs.txt').read())
#     urls = ['https://dictionary.cambridge.org/dictionary/english-chinese-traditional/a-heavy-cross-to-bear',
#            'https://dictionary.cambridge.org/dictionary/english-chinese-traditional/take-off',
#            'https://dictionary.cambridge.org/dictionary/english-chinese-traditional/abide-by-sth'
#            ]
#     for r in urls:
#         print(r)
#         w = r.split('/')[-1]
#         if len(w.split('-')) >= 2:
# #             print(w)
#             start(r,r.split('/')[-1])

#     import json
#     with open('cambridge.phrase.json', 'w') as outfile:
#         json.dump(cam_dict, outfile)


async def main():
    cam_dict = defaultdict(lambda:  defaultdict(lambda: []))
    urls = eval(open('extendURLs.txt').read())
    # urls = ['https://dictionary.cambridge.org/dictionary/english-chinese-traditional/a-heavy-cross-to-bear',
    #        'https://dictionary.cambridge.org/dictionary/english-chinese-traditional/take-off',
    #        'https://dictionary.cambridge.org/dictionary/english-chinese-traditional/abide-by-sth',
    #        'https://dictionary.cambridge.org/dictionary/english-chinese-traditional/a-blinding-flash'
    #    ]
    now = datetime.datetime.now()
    epoch_time = int((now - datetime.datetime(1970, 1, 1)).total_seconds())
    print(epoch_time)
    nano_time = int(time.time())
    print(nano_time)
    stat = {'req': 0, 'res': 0, 'start': nano_time}
    for r in urls:
        # print(r)
        w = r.split('/')[-1]
        if len(w.split('-')) >= 1:
            #             print(w)
            while (stat['req'] - stat['res'] >= 100):
                # print(stat)
                await asyncio.sleep(1)
            stat['req'] += 1
            asyncio.create_task(start(r, r.split('/')[-1], stat))

    import json
    with open('cambridge.phrase.json', 'w') as outfile:
        json.dump(cam_dict, outfile)

asyncio.run(main())


# In[15]:


# In[ ]:
