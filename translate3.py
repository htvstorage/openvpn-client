
# import simplejson as json
import json
import googletrans
import os
import codecs
import re

from googletrans import Translator


def translateString(data, destLangCode):
    global translator
    if isinstance(data, dict):
        return {k: translateString(v, destLangCode) for k, v in data.items()}
    else:
        return translator.translate(data, src='zh-cn', dest=destLangCode).text


# Main Code
all_languages = {'af': 'afrikaans', 'sq': 'albanian', 'am': 'amharic', 'ar': 'arabic', 'hy': 'armenian', 'az': 'azerbaijani', 'eu': 'basque', 'be': 'belarusian', 'bn': 'bengali', 'bs': 'bosnian', 'bg': 'bulgarian', 'ca': 'catalan', 'ceb': 'cebuano', 'ny': 'chichewa', 'zh-cn': 'chinese (simplified)', 'zh-tw': 'chinese (traditional)', 'co': 'corsican', 'hr': 'croatian', 'cs': 'czech', 'da': 'danish', 'nl': 'dutch', 'en': 'english', 'eo': 'esperanto', 'et': 'estonian', 'tl': 'filipino', 'fi': 'finnish', 'fr': 'french', 'fy': 'frisian', 'gl': 'galician', 'ka': 'georgian', 'de': 'german', 'el': 'greek', 'gu': 'gujarati', 'ht': 'haitian creole', 'ha': 'hausa', 'haw': 'hawaiian', 'iw':
                 'hebrew', 'he': 'hebrew', 'hi': 'hindi', 'hmn': 'hmong', 'hu': 'hungarian', 'is': 'icelandic', 'ig': 'igbo', 'id': 'indonesian', 'ga': 'irish', 'it': 'italian', 'ja': 'japanese', 'jw': 'javanese', 'kn': 'kannada', 'kk': 'kazakh', 'km': 'khmer', 'ko': 'korean', 'ku': 'kurdish (kurmanji)', 'ky': 'kyrgyz', 'lo': 'lao', 'la': 'latin', 'lv': 'latvian', 'lt': 'lithuanian', 'lb': 'luxembourgish', 'mk': 'macedonian', 'mg': 'malagasy', 'ms': 'malay', 'ml': 'malayalam', 'mt': 'maltese', 'mi': 'maori', 'mr': 'marathi', 'mn': 'mongolian', 'my': 'myanmar (burmese)', 'ne': 'nepali', 'no': 'norwegian', 'or': 'odia', 'ps': 'pashto', 'fa': 'persian', 'pl': 'polish', 'pt': 'portuguese',
                 'pa': 'punjabi', 'ro': 'romanian', 'ru': 'russian', 'sm': 'samoan', 'gd': 'scots gaelic', 'sr': 'serbian', 'st': 'sesotho', 'sn': 'shona', 'sd': 'sindhi', 'si': 'sinhala', 'sk': 'slovak', 'sl': 'slovenian', 'so': 'somali', 'es': 'spanish', 'su': 'sundanese', 'sw': 'swahili', 'sv': 'swedish', 'tg': 'tajik', 'ta': 'tamil', 'te': 'telugu', 'th': 'thai', 'tr': 'turkish', 'uk': 'ukrainian', 'ur': 'urdu', 'ug': 'uyghur', 'uz': 'uzbek', 'vi': 'vietnamese', 'cy': 'welsh', 'xh': 'xhosa', 'yi': 'yiddish', 'yo': 'yoruba', 'zu': 'zulu'}

dirname = os.path.dirname(__file__)
src_filename = os.path.join(
    dirname, '1_node_exporter_for_prometheus_dashboard_cn_0413_consulmanager_rev25.json')
destLangCodeList = [
    'en'
]
translator = Translator()

for destLangCode in destLangCodeList:
    print('Starting translation for {:} ... '.format(
        all_languages[destLangCode]), end="")
    with open(src_filename, 'r', encoding="utf-8") as fin:
        # data = json.load(fin)
        # print(isinstance(data, array))
        # with codecs.open('your_file.txt', 'w', encoding='utf-8') as f:
        #     json.dump(data, f, ensure_ascii=False)
        # xx = ['xxxx/splitaa' , 'xxxx/splitac' , 'xxxx/splitae' , 'xxxx/splitag' , 'xxxx/splitai' , 'xxxx/splitak' , 'xxxx/splitam' , 'xxxx/splitao' , 'xxxx/splitaq' ,'xxxx/splitab' , 'xxxx/splitad' , 'xxxx/splitaf' , 'xxxx/splitah' , 'xxxx/splitaj' , 'xxxx/splital' , 'xxxx/splitan' , 'xxxx/splitap' , 'xxxx/splitar']
        # xx = ['xxxx/splitar']

        # for x in xx:
        #     file = open(x, 'r')
        #     content = file.read()
        #     file.close()
        #     translated_json = translateString(content, destLangCode)
        #     print(translated_json)

        file = open(src_filename, 'r')
        content = file.read()
        file.close()
        # translated_json = translateString(content, destLangCode)
        # print(translated_json)

        # print(content)
        ls = content.split("\n")

        i = 1;
        new = "";
        for x in ls:
            # print(x)
            
            if re.search(u'[\u4e00-\u9fff]', x):
                print(str(i) + '---------------' +'found chinese character in ' + x)   
                x2 = x.split(":")
                print(x2[0])
                print(x2[1])
                print(len(x2[0])) 
                print(len(x))
                x3 = x[len(x2[0]):len(x)]
                print(x3)
                if not re.search(u'[\u4e00-\u9fff]', x2[0]):
                    translated_json = translateString(x3, destLangCode)
                    translated_json = translated_json.replace("$ ","$");
                    new = new + "\n" + x2[0]  + translated_json
                else:
                    translated_json = translateString(x, destLangCode)
                    translated_json = translated_json.replace("$ ","$");
                    new = new + "\n"   + translated_json                   
                print(translated_json) 
                i = i+1
                # new = new + "\n" + x2[0]  + translated_json
            else:
                new = new + "\n" + x
               
            # translator.dectect(x)
            # translated_json = translateString(x, destLangCode)
            # print(translated_json)
        # print(data)
        # f = open("demofile2.txt", "w", encoding='utf-8')
        # f.write(json.dumps(data))
        # f.close()
        # dest_filename = os.path.join(dirname, all_languages[destLangCode]+'.json')
        # with open(dest_filename, 'w', encoding="utf-8") as fout:
        #     json_dumps_str = json.dumps(translated_json, indent=4, ensure_ascii=False)
        #     fout.write(json_dumps_str)
        print(new)
        f = open("translated2.json", "w", encoding='utf-8')
        f.write(new)
        f.close()        
    print('done')
