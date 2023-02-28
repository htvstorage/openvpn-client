import aiohttp
import asyncio
import logging
import json

logging.basicConfig(level=logging.INFO)


class Exchange:
    @staticmethod
    async def transaction(symbol):
        url = f"""https://api-finance-t19.24hmoney.vn/v1/web/stock/transaction-list-ssi?
device_id=web&device_name=INVALID&device_model=Windows+10&network_carrier=INVALID
&connection_type=INVALID&os=Chrome&os_version=92.0.4515.131&app_version=INVALID
&access_token=INVALID&push_token=INVALID&locale=vi&browser_id=web16693664wxvsjkxelc6e8oe325025&symbol={symbol}&page=1&per_page=2000000"""

        async with aiohttp.ClientSession() as session:
            async with session.get(url) as response:
                data = await response.text()
                if data.startswith("{") and data.endswith("}"):
                    json_data = json.loads(data)
                    json_data["Code"] = symbol
                    logging.info(f"Response data: {json_data}")
                    return json_data
                else:
                    logging.info(f"Response data: {data}")
                    return {"Code": symbol}

    @staticmethod
    async def transaction(symbol, per_page):
        headers = {
            "accept": "application/json, text/plain, */*",
            "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
            "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
            "sec-ch-ua-mobile": "?0",
            "sec-fetch-dest": "empty",
            "sec-fetch-mode": "cors",
            "sec-fetch-site": "same-site",
            "referrer": "https://24hmoney.vn/",
            "referrerPolicy": "strict-origin-when-cross-origin"
        }
        async with aiohttp.ClientSession() as session:
            async with session.get(f"https://api-finance-t19.24hmoney.vn/v1/web/stock/transaction-list-ssi?device_id=web&device_name=INVALID&device_model=Windows+10&network_carrier=INVALID&connection_type=INVALID&os=Chrome&os_version=92.0.4515.131&app_version=INVALID&access_token=INVALID&push_token=INVALID&locale=vi&browser_id=web16693664wxvsjkxelc6e8oe325025&symbol={symbol}&page=1&per_page={per_page}", headers=headers) as response:
                txt = await response.text()
                if txt.startswith("{") and txt.endswith("}"):
                    x = json.loads(txt)
                    x["Code"] = symbol
                    return x
                else:
                    return {"Code": symbol}

    @staticmethod
    async def financial_report(symbol):
        ret = {
            1: {1: {'data': {'headers': [], 'rows': []}}, 2: {'data': {'headers': [], 'rows': []}}, 3: {'data': {'headers': [], 'rows': []}}},
            2: {1: {'data': {'headers': [], 'rows': []}}, 2: {'data': {'headers': [], 'rows': []}}, 3: {'data': {'headers': [], 'rows': []}}},
        }

        async def fetch_data(symbol, page, period, view):
            async with aiohttp.ClientSession(timeout=aiohttp.ClientTimeout(total=1)) as session:
                async with session.get(f"https://api-finance-t19.24hmoney.vn/v1/ios/company/financial-report?device_id=web&device_name=INVALID&device_model=Windows+10&network_carrier=INVALID&connection_type=INVALID&os=Chrome&os_version=92.0.4515.131&app_version=INVALID&access_token=INVALID&push_token=INVALID&locale=vi&browser_id=web16693664wxvsjkxelc6e8oe325025&symbol={symbol}&period={period}&view={view}&page={page}&expanded=true", headers={
                    'accept': 'application/json, text/plain, */*',
                    'accept-language': 'en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7',
                    'sec-ch-ua': '\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"',
                    'sec-ch-ua-mobile': '?0',
                    'sec-fetch-dest': 'empty',
                    'sec-fetch-mode': 'cors',
                    'sec-fetch-site': 'same-site'
                }) as response:
                    return await response.json()

        periods = [1, 2]
        views = [1, 2, 3]

        for period in periods:
            for view in views:
                data = await fetch_data(symbol, 1, period, view)
                ret[period][view]['data']['headers'] = data['data']['headers']
                ret[period][view]['data']['rows'] = data['data']['rows']

                if data['total_page'] > 1:
                    for i in range(2, data['total_page']+1):
                        data = await fetch_data(symbol, i, period, view)
                        ret[period][view]['data']['headers'] += data['data']['headers']
                        for idx, row in enumerate(ret[period][view]['data']['rows']):
                            row['values'] += data['data']['rows'][idx]['values']

                if all([len(ret[p][v]['data']['rows']) > 0 for p in periods for v in views]):
                    return ret

        return ret

    @staticmethod
    async def getlistallstock():
        url = "https://bgapidatafeed.vps.com.vn/getlistallstock"
        headers = {
            "accept": "application/json, text/plain, */*",
            "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
            "if-none-match": "W/\"5ac92-c+NqjXQ6D2JFKgaxgUoTpIzr5z8\"",
            "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
            "sec-ch-ua-mobile": "?0",
            "sec-fetch-dest": "empty",
            "sec-fetch-mode": "cors",
            "sec-fetch-site": "same-site"
        }
        async with aiohttp.ClientSession() as session:
            async with session.get(url, headers=headers) as response:
                response_text = await response.text()
                json_data = json.loads(response_text)
                logging.info(
                    f"Get list all stock success. Length: {len(json_data)}")
                return json_data

    @staticmethod
    async def getlistallsymbol():
        exchange = ["hose", "hnx", "upcom"]
        ret = []
        c = 0

        async def fetch_symbols(url):
            async with aiohttp.ClientSession() as session:
                async with session.get(url) as response:
                    response_text = await response.text()
                    response_text = response_text[1:-1]
                    symbols = response_text.split(",")
                    symbols = [symbol.replace("\"", "") for symbol in symbols]
                    return symbols

        tasks = []
        for ex in exchange:
            url = f"https://bgapidatafeed.vps.com.vn/getlistckindex/{ex}"
            task = asyncio.create_task(fetch_symbols(url))
            tasks.append(task)
        results = await asyncio.gather(*tasks)
        for result in results:
            ret.extend(result)
        logging.info(f"Get list all symbol success. Length: {len(ret)}")
        return ret

    @staticmethod
    async def getliststockdata(list):
        max_url_length = 2048
        url = "https://bgapidatafeed.vps.com.vn/getliststockdata/"
        ret = []
        async with aiohttp.ClientSession() as session:
            for i in range(len(list)):
                url += list[i] + ","
                if len(url) > max_url_length or i == len(list) - 1:
                    url = url[:-1]
                    async with session.get(url) as response:
                        response_text = await response.text()
                        if response_text.startswith("[{") and response_text.endswith("}]"):
                            data = json.loads(response_text)
                            ret.extend(data)
                    url = "https://bgapidatafeed.vps.com.vn/getliststockdata/"
        logging.info(f"Get list stock data success. Length: {len(ret)}")
        return ret

    @staticmethod
    async def get_list_stock_trade(symbol):
        async with aiohttp.ClientSession() as session:
            async with session.get(f"https://bgapidatafeed.vps.com.vn/getliststocktrade/{symbol}") as response:
                logging.info(f"get_list_stock_trade status: {response.status}")
                response_text = await response.text()
                return json.loads(response_text)

    @staticmethod
    async def get_corporate():
        cop = []
        url = "https://finance.vietstock.vn/data/corporateaz"
        headers = {
            "accept": "*/*",
            "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
            "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
            "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
            "sec-ch-ua-mobile": "?0",
            "sec-fetch-dest": "empty",
            "sec-fetch-mode": "cors",
            "sec-fetch-site": "same-origin",
            "x-requested-with": "XMLHttpRequest",
            "referrer": "https://finance.vietstock.vn/doanh-nghiep-a-z?page=0",
            "referrerPolicy": "strict-origin-when-cross-origin",
            "cookie": "_cc_id=bd4b49a4b7a58cfaeb38724516b82171; dable_uid=35370669.1668475569175; dable_uid=35370669.1668475569175; __gads=ID=af0897d5e697b47b-2219cdf973d800fc:T=1668475507:S=ALNI_MaL0TTHW6nK5yq36h7SKojzDZdS3w; language=vi-VN; AnonymousNotification=; vst_usr_lg_token=EOEnV6giRkGbsPZqfVJs8Q==; ASP.NET_SessionId=vxffeht10pmri4sqknpcpue5; __RequestVerificationToken=ju8e-zQJz4XOM0sXzza6gQ8yHh1z5bAnPl7ptlG4EerGwFUS4tjY-RKSPBBmBKyxSfqBaKpHzakxWCDu4fItiBRbBkUNg12uP2Gxo26FDcc1; Theme=Light; __gpi=UID=00000b7c20f7c81e:T=1668475507:RT=1677583420:S=ALNI_MbZNgtWTtbRI1MrLcfM5qFq0RIBMQ; _gid=GA1.2.876734480.1677583421; _pbjs_userid_consent_data=3524755945110770; panoramaId_expiry=1677669821355; panoramaId=4d0c5a1ada413b921c9b37c6d8d4a9fb927a0d4a71477931e7d9d438d60721a2; cto_bundle=DVKyFF9GalVXbDclMkJNeHNwS0pTN0VtbThsUDFERzRua1VUdllkVWslMkJsQUVyTkU3WmxwQWFsRnhnNzM0Q1dnRFlTbFhuUDNycnJtdEk4NkxrYVFraEV6WkpwWjIxOFNZOVc4SzVNdEJOVFFhd3BTQ1lqTUVRTyUyRlR0ajgwNGdMRkhTOW40SCUyRlVwRzFVSVdaVm0xT0Nudm9BbDRZQSUzRCUzRA; _ga_EXMM0DKVEX=GS1.1.1677583420.4.1.1677583684.0.0.0; _ga=GA1.2.70802173.1668475499; _gat_UA-1460625-2=1",
        }
        data = {
            "catID": "0",
            "industryID": "0",
            "page": "1",
            "pageSize": "1000",
            "type": "0",
            "code": "",
            "businessTypeID": "0",
            "orderBy": "Code",
            "orderDir": "ASC",
            "__RequestVerificationToken": "vcAX57aBcCnw7NMT5NQls0J4b0cTXasI2HbH83w5JMXxogZnp3eBB0UVoqsSCddTd-6UBqv6Pz81t46uInWhjcnoXiV0_OoEzz79GJTE3Fw1"
        }

        async with aiohttp.ClientSession() as session:
            for i in range(1, 2):
                data['page'] = i
                async with session.post(url, headers=headers, data=data) as response:
                    x = await response.json()
                    logging.info(f"{x}")
                    cop.extend(x)
                    logging.info(f"{len(x)} {i}")
            logging.info(f"{len(cop)}")
            data = json.dumps(cop)
            # with open('cop.json', 'w') as f:
            #     f.write(data)
            result = "\"" in data
            logging.info(f"result {result}")
