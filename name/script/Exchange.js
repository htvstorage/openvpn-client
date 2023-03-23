import fetch from "node-fetch";
import fs from "fs";
import log4js from "log4js";
import http from "node:http";
import https from "node:https";
import { resolve } from "path";
import { start } from "repl";

const httpAgent = new http.Agent({ keepAlive: true });
const httpsAgent = new https.Agent({ keepAlive: true });
const agent = (_parsedURL) => _parsedURL.protocol == 'http:' ? httpAgent : httpsAgent;
var logger = log4js.getLogger();



export function Exchange() {
}
//24hmoney
Exchange.transaction = async function (symbol) {
  let a = await fetch("https://api-finance-t19.24hmoney.vn/v1/web/stock/transaction-list-ssi?device_id=web&device_name=INVALID&device_model=Windows+10&network_carrier=INVALID&connection_type=INVALID&os=Chrome&os_version=92.0.4515.131&app_version=INVALID&access_token=INVALID&push_token=INVALID&locale=vi&browser_id=web16693664wxvsjkxelc6e8oe325025&symbol="
    + symbol
    + "&page=1&per_page=2000000", {
    "headers": {
      "accept": "application/json, text/plain, */*",
      "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
      "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
      "sec-ch-ua-mobile": "?0",
      "sec-fetch-dest": "empty",
      "sec-fetch-mode": "cors",
      "sec-fetch-site": "same-site"
    },
    "referrer": "https://24hmoney.vn/",
    "referrerPolicy": "strict-origin-when-cross-origin",
    "body": null,
    "method": "GET",
    "mode": "cors"
  });
  if (txt.startsWith("{") && txt.endsWith("}")) {
    let x = JSON.parse(txt);
    x["Code"] = symbol;
    return x;
  } else {
    return { "Code": symbol }
  }
}


Exchange.transaction = async function (symbol, per_page) {
  let a = await fetch("https://api-finance-t19.24hmoney.vn/v1/web/stock/transaction-list-ssi?device_id=web&device_name=INVALID&device_model=Windows+10&network_carrier=INVALID&connection_type=INVALID&os=Chrome&os_version=92.0.4515.131&app_version=INVALID&access_token=INVALID&push_token=INVALID&locale=vi&browser_id=web16693664wxvsjkxelc6e8oe325025&symbol="
    + symbol
    + "&page=1&per_page=" + per_page, {
    "headers": {
      "accept": "application/json, text/plain, */*",
      "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
      "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
      "sec-ch-ua-mobile": "?0",
      "sec-fetch-dest": "empty",
      "sec-fetch-mode": "cors",
      "sec-fetch-site": "same-site"
    },
    "referrer": "https://24hmoney.vn/",
    "referrerPolicy": "strict-origin-when-cross-origin",
    "body": null,
    "method": "GET",
    "mode": "cors",
    agent
  });
  let txt = await a.text();
  if (txt.startsWith("{") && txt.endsWith("}")) {
    let x = JSON.parse(txt);
    x["Code"] = symbol;
    return x;
  } else {
    return { "Code": symbol }
  }

}

Exchange.finacialReport = async function (symbol) {
  let ret = {
    1: { 1: { data: { headers: [], rows: [] } }, 2: { data: { headers: [], rows: [] } }, 3: { data: { headers: [], rows: [] } } },
    2: { 1: { data: { headers: [], rows: [] } }, 2: { data: { headers: [], rows: [] } }, 3: { data: { headers: [], rows: [] } } },
  };

  let js = function (data) {
    this.data = data;
    this.json = function () {
      return this.data;
    }
  };

  let f = async (symbol, page, period, views) => {
    return fetch("https://api-finance-t19.24hmoney.vn/v1/ios/company/financial-report?device_id=web&device_name=INVALID&device_model=Windows+10&network_carrier=INVALID&connection_type=INVALID&os=Chrome&os_version=92.0.4515.131&app_version=INVALID&access_token=INVALID&push_token=INVALID&locale=vi&browser_id=web16693664wxvsjkxelc6e8oe325025&" + "symbol=" + symbol + "&period=" + period + "&view=" + views + "&page=" + page + "&expanded=true", {
      "headers": {
        "accept": "application/json, text/plain, */*",
        "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
        "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
        "sec-ch-ua-mobile": "?0",
        "sec-fetch-dest": "empty",
        "sec-fetch-mode": "cors",
        "sec-fetch-site": "same-site"
      },
      "referrer": "https://24hmoney.vn/",
      "referrerPolicy": "strict-origin-when-cross-origin",
      "body": null,
      "method": "GET",
      "mode": "cors",
      agent
    }, { timeout: 1000 });
  }
  let periods = [1, 2]
  let views = [1, 2, 3];
  let promise = new Promise((resolve, reject) => {
    for (let period of periods) {
      for (let view of views) {
        let a = f(symbol, 1, period, view);
        a.then(res => res.json()).then(data => {
          ret[period][view].data.headers = [...ret[period][view].data.headers, ...data.data.headers]
          ret[period][view].data.rows = [...ret[period][view].data.rows, ...data.data.rows]
          if (data.total_page > 1) {
            for (let i = 2; i <= data.total_page; i++) {
              let b = f(symbol, i, period, view);
              b.then(res => res.json()).then(data => {
                ret[period][view].data.headers = [...ret[period][view].data.headers, ...data.data.headers]
                // ret.data.rows = [...ret.data.rows, ...data.data.rows]            
                ret[period][view].data.rows.forEach((value, index) => {
                  value.values = [...value.values, ...data.data.rows[index].values]
                });
                if (i == data.total_page) {
                  if (ret[1][1].data.rows.length > 0 && ret[1][2].data.rows.length > 0 && ret[1][3].data.rows.length > 0
                    && ret[2][1].data.rows.length > 0 && ret[2][2].data.rows.length > 0 && ret[2][3].data.rows.length > 0
                  )
                    resolve(new js(ret));
                }
              })
            }
          }
          else {
            if (ret[1][1].data.rows.length > 0 && ret[1][2].data.rows.length > 0 && ret[1][3].data.rows.length > 0
              && ret[2][1].data.rows.length > 0 && ret[2][2].data.rows.length > 0 && ret[2][3].data.rows.length > 0)
              resolve(new js(ret));
          }
        });

      }
    }
  });

  return promise;
}


//VPS
Exchange.getlistallstock = async function () {
  let cop = [];
  // process.env['NODE_TLS_REJECT_UNAUTHORIZED'] = '0';
  let fet = await fetch("https://bgapidatafeed.vps.com.vn/getlistallstock", {
    "headers": {
      "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9;application/json; charset=utf-8",
    },
    "referrerPolicy": "strict-origin-when-cross-origin",
    "body": null,
    "method": "GET",
    "mode": "cors",
    "credentials": "include"
  });
  let xx = await fet.json();
  // process.env['NODE_TLS_REJECT_UNAUTHORIZED'] = '1'; 
  console.log(xx.length)
  cop = [...cop, ...xx];
  return cop;
}


Exchange.getlistallsymbol = async function () {
  let exchange = ['hose', 'hnx', 'upcom']
  let ret = [];
  let c = 0;

  // process.env['NODE_TLS_REJECT_UNAUTHORIZED'] = '0';
  let f = async (resolve) => {
    for (let ex of exchange) {
      console.log(ex)
      let z = fetch("https://bgapidatafeed.vps.com.vn/getlistckindex/" + ex, {
        "method": "GET",
        "mode": "cors"
      });
      z.then(res => res.text()
      ).then(data => {
        c++;
        let a = data.slice(1, -1).split(",").map(e => e.replaceAll("\"", ""));
        ret = [...ret, ...a];
        if (c == exchange.length) {
          resolve(ret);
          // console.log(ret.length)
        }
      })
    }
  }
  // process.env['NODE_TLS_REJECT_UNAUTHORIZED'] = '1'; 
  let promise = new Promise(f);
  return promise;
}




Exchange.getliststockdata = async function (list, ret) {
  let maxURLLength = 2048;
  let url = "https://bgapidatafeed.vps.com.vn/getliststockdata/";
  let promise = new Promise((resolve) => {
    for (let i = 0; i < list.length; i++) {
      url = url + list[i] + ",";
      if (url.length > 2024 || i == list.length - 1) {
        url.slice(0, -1);
        let a = fetch(url, {
          "headers": {
            "accept": "application/json, text/plain, */*",
            "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
            "cache-control": "max-age=0",
            "if-none-match": "W/\"4d40-JGO04TIpDa6yRnuWE3iB61BlloY\"",
            "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
            "sec-ch-ua-mobile": "?0",
            "sec-fetch-dest": "empty",
            "sec-fetch-mode": "cors",
            "sec-fetch-site": "same-origin",
            "cookie": "_fbp=fb.2.1669623965921.1893403188; _ga_M9VTXEHK9C=GS1.1.1669958644.2.0.1669958644.0.0.0; _gid=GA1.3.658451143.1670224721; _ga=GA1.1.1812813168.1668398014; _ga_4WDBKERLGC=GS1.1.1670316124.25.0.1670316124.0.0.0; _ga_QW53DJZL1X=GS1.1.1670384164.2.1.1670384195.0.0.0; _ga_790K9595DC=GS1.1.1670384139.11.1.1670384402.0.0.0"
          },
          "referrer": "https://bgapidatafeed.vps.com.vn/",
          "referrerPolicy": "strict-origin-when-cross-origin",
          "body": null,
          "method": "GET",
          "mode": "cors",
          agent
        });
        a.then(res => res.text()).then(txt => {

          let data = [];
          if (txt.startsWith("[{") && txt.endsWith("}]")) {
            data = JSON.parse(txt);
          }
          for (let e of data) {
            // console.log(Object.keys(ret).length)
            ret[e.sym] = e;
          }
          if (Object.keys(ret).length == list.length) {
            resolve(ret);
          }
        });
        url = "https://bgapidatafeed.vps.com.vn/getliststockdata/";
      }
    }
  })
  return promise;
}

// fetch("https://bgapidatafeed.vps.com.vn/getliststocktrade/AAA", {
//   "headers": {
//     "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
//     "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
//     "cache-control": "max-age=0",
//     "if-none-match": "W/\"25a64-SgVo+ex6TslKyOzpmFN38r8EP3g\"",
//     "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
//     "sec-ch-ua-mobile": "?0",
//     "sec-fetch-dest": "document",
//     "sec-fetch-mode": "navigate",
//     "sec-fetch-site": "none",
//     "sec-fetch-user": "?1",
//     "upgrade-insecure-requests": "1",
//     "cookie": "_fbp=fb.2.1669623965921.1893403188; _ga_M9VTXEHK9C=GS1.1.1669958644.2.0.1669958644.0.0.0; _ga_4WDBKERLGC=GS1.1.1673506896.55.1.1673507722.0.0.0; _ga_790K9595DC=GS1.1.1673510859.35.1.1673510873.0.0.0; _gid=GA1.3.1853708949.1673510901; _ga_QW53DJZL1X=GS1.1.1673510874.9.1.1673511108.0.0.0; _ga=GA1.1.1812813168.1668398014"
//   },
//   "referrerPolicy": "strict-origin-when-cross-origin",
//   "body": null,
//   "method": "GET",
//   "mode": "cors"
// });

Exchange.getliststocktrade = async function (symbol) {
  return fetch("https://bgapidatafeed.vps.com.vn/getliststocktrade/" + symbol, {
    "method": "GET",
    "mode": "cors",
    // agent
  });
}

Exchange.getCoporate = async function () {
  for (let i = 1; i < 1; i++) {
    let a = await fetch("https://finance.vietstock.vn/data/corporateaz", {
      "headers": {
        "accept": "*/*",
        "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
        "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
        "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
        "sec-ch-ua-mobile": "?0",
        "sec-fetch-dest": "empty",
        "sec-fetch-mode": "cors",
        "sec-fetch-site": "same-origin",
        "x-requested-with": "XMLHttpRequest",
        "cookie": "_ga=GA1.2.70802173.1668475499; _cc_id=bd4b49a4b7a58cfaeb38724516b82171; language=vi-VN; Theme=Light; dable_uid=35370669.1668475569175; dable_uid=35370669.1668475569175; AnonymousNotification=; __gads=ID=af0897d5e697b47b-2219cdf973d800fc:T=1668475507:S=ALNI_MaL0TTHW6nK5yq36h7SKojzDZdS3w; _gid=GA1.2.628877579.1669284322; __gpi=UID=00000b7c20f7c81e:T=1668475507:RT=1669284333:S=ALNI_MbZNgtWTtbRI1MrLcfM5qFq0RIBMQ; panoramaId_expiry=1669370736071; ASP.NET_SessionId=qduvvnqyivh5d4wxgbuml2i4; __RequestVerificationToken=DMLOwjnmuA56MS_Ww2aeEeYKVOqgXC8AokvPdtt4rab-ZCwmqqnVntOncwKpiUMztm716730yD0Ww2wOYftsmgR2LZRIlLaxTIwizl5AHYw1; cto_bundle=Vwxihl9GalVXbDclMkJNeHNwS0pTN0VtbThsUHg3czZzMmJRak9lYW1PckQlMkJlbHZycjlJQTZyUEQ5SVJEZVV0MDV0TnhyYUExTVlGQnljTFVlNDYzJTJGQjVRckZINGtiJTJCYklyWWZSUHRWMWdyVzZ5aVUxMFNsTGxsMENEJTJGekJkdGQybURpMVZaWmlRT1VLRjBmeWRpTldWUW1mdElnJTNEJTNE; vts_usr_lg=FCD52B81DB78650855CAA7CA28FA7C8EDE83A4C07B4D82FF93CB56D4548635D5DDB6EE0FA4C44D0AA886E67E128BE9D4CFD90FFCDD22AE564370A2F149D63A93A693B03B648319091F8447195028A2E131176E743B4A7A2812875BFA74F81A6CE42BB7BB98BF8D02534A1AF82170658BB9C71CA8F0E53D047C661E38E30A2590; vst_usr_lg_token=GkYVXcco60+DaHbLnHxDcw=="
      },
      "referrer": "https://finance.vietstock.vn/doanh-nghiep-a-z?page=0",
      "referrerPolicy": "strict-origin-when-cross-origin",
      "body": "catID=0&industryID=0&page=3&pageSize=1000&type=0&code=&businessTypeID=0&orderBy=Code&orderDir=ASC&__RequestVerificationToken=OG2V3lTnmB0D7vZLkd9pAilFPditBUL6KpJk7C4Fa2-V0LLJuTOgsHRCOyFMXiqz17v8zJfkTNd0K8HGetRIYr1LLGi0hfCIxLSyEJGoG6AvXJeCRtV1ni_2fMEBgh8A0",
      "method": "POST",
      "mode": "cors"
    });

    let x = await a.json();
    cop = [...cop, ...x]
    console.log(x.length, " ", i)
  }
  console.log(cop.length)
  let data = JSON.stringify(cop);
  // fs.writeFileSync('cop.json', data);
  let result = data.includes("\"");
  console.log("result ", result)
}


function loadCoporate() {
  fs.readFile('cop.json', (err, data) => {
    if (err) throw err;
    cop = JSON.parse(data);
  });
  data = fs.readFileSync('cop.json');
  cop = JSON.parse(data);
  console.log(cop.length);
}



//VND

Exchange.vndGetAllSymbols = async function () {
  let a = await fetch("https://finfo-api.vndirect.com.vn/v4/stocks?q=type:stock,ifc~floor:HOSE,HNX,UPCOM&size=9999", {
    "headers": {
      "content-type": "application/json",
      "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
      "sec-ch-ua-mobile": "?0"
    },
    "referrer": "https://dstock.vndirect.com.vn/",
    "referrerPolicy": "strict-origin-when-cross-origin",
    "body": null,
    "method": "GET",
    "mode": "cors"
  });

  let z = await a.text()

  if (z.startsWith("{") && z.endsWith("}")) {
    //   {
    //     "code": "ENF",
    //     "type": "IFC",
    //     "floor": "UPCOM",
    //     "status": "delisted",
    //     "companyName": "Quỹ Đầu tư Năng động Eastspring Investments Việt Nam",
    //     "companyNameEng": "Eastspring Investments Vietnam Navigator Fund",
    //     "shortName": "Quỹ đầu tư ENF",
    //     "listedDate": "2001-01-01",
    //     "delistedDate": "2001-01-01",
    //     "companyId": "3903"
    // }
    let js = JSON.parse(z);
    return js.data.filter(e => { return e.status == "listed" })
  } else {
    return null;
  }
}

Exchange.vndIndustryClassification = async () => {

  let a = await fetch("https://finfo-api.vndirect.com.vn/v4/industry_classification?q=industryLevel:2", {
    "headers": {
      "content-type": "application/json",
      "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
      "sec-ch-ua-mobile": "?0"
    },
    "referrer": "https://dstock.vndirect.com.vn/",
    "referrerPolicy": "strict-origin-when-cross-origin",
    "body": null,
    "method": "GET",
    "mode": "cors",
    agent
  });

  let z = await a.text();
  if (z.startsWith("{") && z.endsWith("}")) {
    return JSON.parse(z).data;
  }
  return {};
}
Exchange.vndIndustryPE = async () => {
  let a = await fetch("https://finfo-api.vndirect.com.vn/v4/ratios/latest?filter=code:0500,1300,1700,2300,2700,3300,3500,3700,4500,5300,5500,5700,6500,7500,8300,8500,8600,8700,9500&where=ratioCode:PRICE_TO_EARNINGS~group:INDUSTRY&order=reportDate", {
    "headers": {
      "content-type": "application/json",
      "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
      "sec-ch-ua-mobile": "?0"
    },
    "referrer": "https://dstock.vndirect.com.vn/",
    "referrerPolicy": "strict-origin-when-cross-origin",
    "body": null,
    "method": "GET",
    "mode": "cors",
    agent
  });
  let z = await a.text();
  if (z.startsWith("{") && z.endsWith("}")) {
    return JSON.parse(z).data;
  }
  return {};
}

Exchange.vndIndustryPB = async () => {
  let a = await fetch("https://finfo-api.vndirect.com.vn/v4/ratios/latest?filter=code:0500,1300,1700,2300,2700,3300,3500,3700,4500,5300,5500,5700,6500,7500,8300,8500,8600,8700,9500&where=ratioCode:PRICE_TO_BOOK~group:INDUSTRY&order=reportDate", {
    "headers": {
      "content-type": "application/json",
      "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
      "sec-ch-ua-mobile": "?0"
    },
    "referrer": "https://dstock.vndirect.com.vn/",
    "referrerPolicy": "strict-origin-when-cross-origin",
    "body": null,
    "method": "GET",
    "mode": "cors",
    agent
  });

  let z = await a.text();
  if (z.startsWith("{") && z.endsWith("}")) {
    return JSON.parse(z).data;
  }
  return {};
}
Exchange.vndIndustryRatio = async (code) => {


  let a = await fetch("https://finfo-api.vndirect.com.vn/v4/ratios/latest?filter=itemCode:51003,51016,51001,51002,51004,57066,51007,51006,51012,51033,51035,&where=code:" + code + "~reportDate:gt:2022-12-23&order=reportDate&fields=itemCode,value", {
    "headers": {
      "accept": "*/*",
      "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
      "content-type": "application/json",
      "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
      "sec-ch-ua-mobile": "?0",
      "sec-fetch-dest": "empty",
      "sec-fetch-mode": "cors",
      "sec-fetch-site": "same-site"
    },
    "referrer": "https://dstock.vndirect.com.vn/",
    "referrerPolicy": "strict-origin-when-cross-origin",
    "body": null,
    "method": "GET",
    "mode": "cors",
    agent
  });
  let z = await a.text();
  // console.log("zzzz",z)
  let out = [];
  if (z.startsWith("{") && z.endsWith("}")) {
    out = [...JSON.parse(z).data];
  } else {
    console.log("Error ", code, z)
  }

  a = await fetch("https://finfo-api.vndirect.com.vn/v4/ratios/latest?filter=itemCode:52002,52001,53007,&where=code:HPG~reportDate:gt:2022-09-24&order=reportDate&fields=itemCode,value", {
    "headers": {
      "accept": "*/*",
      "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
      "content-type": "application/json",
      "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
      "sec-ch-ua-mobile": "?0",
      "sec-fetch-dest": "empty",
      "sec-fetch-mode": "cors",
      "sec-fetch-site": "same-site"
    },
    "referrer": "https://dstock.vndirect.com.vn/",
    "referrerPolicy": "strict-origin-when-cross-origin",
    "body": null,
    "method": "GET",
    "mode": "cors",
    agent
  });
  z = await a.text();

  if (z.startsWith("{") && z.endsWith("}")) {
    out.push(...JSON.parse(z).data);
  } else {
    console.log("Error ", code)
  }
  // '51003': VONHOA
  // '51016': KLGDTB10P
  // '51001': MAX52T
  // '51002': MIN52T
  // '51004': CPLH
  // '57066': FREEFL
  // '51007': BETA
  // '51006': PE
  // '51012': PB
  // '51033': COTUC
  // '51035': BVPS
  // '52002': ROAE
  // '52001': ROAA
  // '53007': EPS

  let map = {
    '51003': 'VONHOA',
    '51016': 'KLGDTB10P',
    '51001': 'MAX52T',
    '51002': 'MIN52T',
    '51004': 'CPLH',
    '57066': 'FREEFL',
    '51007': 'BETA',
    '51006': 'PE',
    '51012': 'PB',
    '51033': 'COTUC',
    '51035': 'BVPS',
    '52002': 'ROAE',
    '52001': 'ROAA',
    '53007': 'EPS'
  }
  let out2 = {};
  out.forEach(v => {
    out2[map[v.itemCode]] = v.value;
  })
  // console.table([out2])
  out2.symbol = code;
  return out2;
}



Exchange.vndRatio = async () => {

  let a = await fetch("https://finfo-api.vndirect.com.vn/v4/ratios/latest?where=reportDate:gt:2022-12-23~itemCode:51012,51006&filter=code:HPG,HSG,TVN,NKG,DTL,POM,TMG,CKD,TIS,SMC,TLH,VGS,TKU,TTS,CBI,HMC,TNB,VGL,VCA,TNI,TDS,MEL,CKA,NSH,BCA,KMT,KVC,ITQ,HSV,TNS,KCB,KKC,DPS,HLA&order=reportDate", {
    "headers": {
      "accept": "*/*",
      "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
      "content-type": "application/json",
      "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
      "sec-ch-ua-mobile": "?0",
      "sec-fetch-dest": "empty",
      "sec-fetch-mode": "cors",
      "sec-fetch-site": "same-site"
    },
    "referrer": "https://dstock.vndirect.com.vn/",
    "referrerPolicy": "strict-origin-when-cross-origin",
    "body": null,
    "method": "GET",
    "mode": "cors"
  });

  z = await a.json()
}


Exchange.ratios = async function (symbol) {
  //itemCode:51003,51016,51001,51002,51004,57066,51007,51006,51012,51033,51035
  return fetch("https://finfo-api.vndirect.com.vn/v4/ratios/latest?filter=itemCode:51007,&where=code:" + symbol + "~reportDate:gt:2022-10-31&order=reportDate&fields=itemCode,value", {
    "headers": {
      "accept": "*/*",
      "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
      "content-type": "application/json",
      "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
      "sec-ch-ua-mobile": "?0",
      "sec-fetch-dest": "empty",
      "sec-fetch-mode": "cors",
      "sec-fetch-site": "same-site"
    },
    "referrer": "https://dstock.vndirect.com.vn/",
    "referrerPolicy": "strict-origin-when-cross-origin",
    "body": null,
    "method": "GET",
    "mode": "cors",
    agent
  });
}


Exchange.stocks = async function () {
  return fetch("https://finfo-api.vndirect.com.vn/v4/stocks?q=type:stock,ifc~floor:HOSE,HNX,UPCOM&size=9999", {
    "headers": {
      "content-type": "application/json",
      "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
      "sec-ch-ua-mobile": "?0"
    },
    "referrer": "https://dstock.vndirect.com.vn/",
    "referrerPolicy": "strict-origin-when-cross-origin",
    "body": null,
    "method": "GET",
    "mode": "cors"
  });
}



//Fireant

Exchange.fundamental = async function (stock_code) {

  let a = fetch("https://restv2.fireant.vn/symbols/" + stock_code + "/fundamental", {
    "headers": {
      "accept": "application/json, text/plain, */*",
      "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
      "authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IkdYdExONzViZlZQakdvNERWdjV4QkRITHpnSSIsImtpZCI6IkdYdExONzViZlZQakdvNERWdjV4QkRITHpnSSJ9.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmZpcmVhbnQudm4iLCJhdWQiOiJodHRwczovL2FjY291bnRzLmZpcmVhbnQudm4vcmVzb3VyY2VzIiwiZXhwIjoxOTQ3MjQ3NzkxLCJuYmYiOjE2NDcyNDc3OTEsImNsaWVudF9pZCI6ImZpcmVhbnQudHJhZGVzdGF0aW9uIiwic2NvcGUiOlsib3BlbmlkIiwicHJvZmlsZSIsInJvbGVzIiwiZW1haWwiLCJhY2NvdW50cy1yZWFkIiwiYWNjb3VudHMtd3JpdGUiLCJvcmRlcnMtcmVhZCIsIm9yZGVycy13cml0ZSIsImNvbXBhbmllcy1yZWFkIiwiaW5kaXZpZHVhbHMtcmVhZCIsImZpbmFuY2UtcmVhZCIsInBvc3RzLXdyaXRlIiwicG9zdHMtcmVhZCIsInN5bWJvbHMtcmVhZCIsInVzZXItZGF0YS1yZWFkIiwidXNlci1kYXRhLXdyaXRlIiwidXNlcnMtcmVhZCIsInNlYXJjaCIsImFjYWRlbXktcmVhZCIsImFjYWRlbXktd3JpdGUiLCJibG9nLXJlYWQiLCJpbnZlc3RvcGVkaWEtcmVhZCJdLCJzdWIiOiIxZDY5YmE3NC0xNTA1LTRkNTktOTA0Mi00YWNmYjRiODA3YzQiLCJhdXRoX3RpbWUiOjE2NDcyNDc3OTEsImlkcCI6Ikdvb2dsZSIsIm5hbWUiOiJ0cmluaHZhbmh1bmdAZ21haWwuY29tIiwic2VjdXJpdHlfc3RhbXAiOiI5NTMyOGNlZi1jZmY1LTQ3Y2YtYTRkNy1kZGFjYWJmZjRhNzkiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJ0cmluaHZhbmh1bmdAZ21haWwuY29tIiwidXNlcm5hbWUiOiJ0cmluaHZhbmh1bmdAZ21haWwuY29tIiwiZnVsbF9uYW1lIjoiVHJpbmggVmFuIEh1bmciLCJlbWFpbCI6InRyaW5odmFuaHVuZ0BnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6InRydWUiLCJqdGkiOiJhMTY2MDQwOGNhMGFkYWQxOTcwZDVhNWZhMmFjNjM1NSIsImFtciI6WyJleHRlcm5hbCJdfQ.cpc3almBHrGu-c-sQ72hq6rdwOiWB1dIy1LfZ6cgjyH4YaBWiQkPt4l7M_nTlJnVOdFt9lM2OuSmCcTJMcAKLd4UmdBypeZUpTZp_bUv1Sd3xV8LHF7FSj2Awgw0HIaic08h1LaRg0pPzzf-IRJFT7YA8Leuceid6rD4BCQ3yNvz8r58u2jlCXuPGI-xA8W4Y3151hpNWCtemyizhzi7EKri_4WWpXrXPAeTAnZSdoSq87shTxm9Kyz_QJUBQN6PIEINl9sIQaKL-I_jR9LogYB_aM3hs81Ga6h-n-vbnFK8JR1JEJQmU-rxyX7XvuL-UjQVag3LxQeJwH7Nnajkkg",
      "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
      "sec-ch-ua-mobile": "?0",
      "sec-fetch-dest": "empty",
      "sec-fetch-mode": "cors",
      "sec-fetch-site": "same-site"
    },
    "referrerPolicy": "no-referrer",
    "body": null,
    "method": "GET",
    "mode": "cors",
    agent
  });

  return a;
}

Exchange.financialIndicators = async function (symbol) {
  return fetch("https://restv2.fireant.vn/symbols/" + symbol + "/financial-indicators", {
    "headers": {
      "accept": "application/json, text/plain, */*",
      "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
      "authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IkdYdExONzViZlZQakdvNERWdjV4QkRITHpnSSIsImtpZCI6IkdYdExONzViZlZQakdvNERWdjV4QkRITHpnSSJ9.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmZpcmVhbnQudm4iLCJhdWQiOiJodHRwczovL2FjY291bnRzLmZpcmVhbnQudm4vcmVzb3VyY2VzIiwiZXhwIjoxOTQ3MjQ3NzkxLCJuYmYiOjE2NDcyNDc3OTEsImNsaWVudF9pZCI6ImZpcmVhbnQudHJhZGVzdGF0aW9uIiwic2NvcGUiOlsib3BlbmlkIiwicHJvZmlsZSIsInJvbGVzIiwiZW1haWwiLCJhY2NvdW50cy1yZWFkIiwiYWNjb3VudHMtd3JpdGUiLCJvcmRlcnMtcmVhZCIsIm9yZGVycy13cml0ZSIsImNvbXBhbmllcy1yZWFkIiwiaW5kaXZpZHVhbHMtcmVhZCIsImZpbmFuY2UtcmVhZCIsInBvc3RzLXdyaXRlIiwicG9zdHMtcmVhZCIsInN5bWJvbHMtcmVhZCIsInVzZXItZGF0YS1yZWFkIiwidXNlci1kYXRhLXdyaXRlIiwidXNlcnMtcmVhZCIsInNlYXJjaCIsImFjYWRlbXktcmVhZCIsImFjYWRlbXktd3JpdGUiLCJibG9nLXJlYWQiLCJpbnZlc3RvcGVkaWEtcmVhZCJdLCJzdWIiOiIxZDY5YmE3NC0xNTA1LTRkNTktOTA0Mi00YWNmYjRiODA3YzQiLCJhdXRoX3RpbWUiOjE2NDcyNDc3OTEsImlkcCI6Ikdvb2dsZSIsIm5hbWUiOiJ0cmluaHZhbmh1bmdAZ21haWwuY29tIiwic2VjdXJpdHlfc3RhbXAiOiI5NTMyOGNlZi1jZmY1LTQ3Y2YtYTRkNy1kZGFjYWJmZjRhNzkiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJ0cmluaHZhbmh1bmdAZ21haWwuY29tIiwidXNlcm5hbWUiOiJ0cmluaHZhbmh1bmdAZ21haWwuY29tIiwiZnVsbF9uYW1lIjoiVHJpbmggVmFuIEh1bmciLCJlbWFpbCI6InRyaW5odmFuaHVuZ0BnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6InRydWUiLCJqdGkiOiJhMTY2MDQwOGNhMGFkYWQxOTcwZDVhNWZhMmFjNjM1NSIsImFtciI6WyJleHRlcm5hbCJdfQ.cpc3almBHrGu-c-sQ72hq6rdwOiWB1dIy1LfZ6cgjyH4YaBWiQkPt4l7M_nTlJnVOdFt9lM2OuSmCcTJMcAKLd4UmdBypeZUpTZp_bUv1Sd3xV8LHF7FSj2Awgw0HIaic08h1LaRg0pPzzf-IRJFT7YA8Leuceid6rD4BCQ3yNvz8r58u2jlCXuPGI-xA8W4Y3151hpNWCtemyizhzi7EKri_4WWpXrXPAeTAnZSdoSq87shTxm9Kyz_QJUBQN6PIEINl9sIQaKL-I_jR9LogYB_aM3hs81Ga6h-n-vbnFK8JR1JEJQmU-rxyX7XvuL-UjQVag3LxQeJwH7Nnajkkg",
      "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
      "sec-ch-ua-mobile": "?0",
      "sec-fetch-dest": "empty",
      "sec-fetch-mode": "cors",
      "sec-fetch-site": "same-site"
    },
    "referrerPolicy": "no-referrer",
    "body": null,
    "method": "GET",
    "mode": "cors",
    "credentials": "include",
    agent
  });
}


Exchange.financialReportFireAnt = async function (symbol) {
  let f = async (symbol, type, period, limit) => {
    return fetch("https://restv2.fireant.vn/symbols/" + symbol + "/financial-reports?type=" + type + "&period=" + period + "&compact=true&offset=0&limit=" + limit, {
      "headers": {
        "accept": "application/json, text/plain, */*",
        "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
        "authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IkdYdExONzViZlZQakdvNERWdjV4QkRITHpnSSIsImtpZCI6IkdYdExONzViZlZQakdvNERWdjV4QkRITHpnSSJ9.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmZpcmVhbnQudm4iLCJhdWQiOiJodHRwczovL2FjY291bnRzLmZpcmVhbnQudm4vcmVzb3VyY2VzIiwiZXhwIjoxOTQ3MjQ3NzkxLCJuYmYiOjE2NDcyNDc3OTEsImNsaWVudF9pZCI6ImZpcmVhbnQudHJhZGVzdGF0aW9uIiwic2NvcGUiOlsib3BlbmlkIiwicHJvZmlsZSIsInJvbGVzIiwiZW1haWwiLCJhY2NvdW50cy1yZWFkIiwiYWNjb3VudHMtd3JpdGUiLCJvcmRlcnMtcmVhZCIsIm9yZGVycy13cml0ZSIsImNvbXBhbmllcy1yZWFkIiwiaW5kaXZpZHVhbHMtcmVhZCIsImZpbmFuY2UtcmVhZCIsInBvc3RzLXdyaXRlIiwicG9zdHMtcmVhZCIsInN5bWJvbHMtcmVhZCIsInVzZXItZGF0YS1yZWFkIiwidXNlci1kYXRhLXdyaXRlIiwidXNlcnMtcmVhZCIsInNlYXJjaCIsImFjYWRlbXktcmVhZCIsImFjYWRlbXktd3JpdGUiLCJibG9nLXJlYWQiLCJpbnZlc3RvcGVkaWEtcmVhZCJdLCJzdWIiOiIxZDY5YmE3NC0xNTA1LTRkNTktOTA0Mi00YWNmYjRiODA3YzQiLCJhdXRoX3RpbWUiOjE2NDcyNDc3OTEsImlkcCI6Ikdvb2dsZSIsIm5hbWUiOiJ0cmluaHZhbmh1bmdAZ21haWwuY29tIiwic2VjdXJpdHlfc3RhbXAiOiI5NTMyOGNlZi1jZmY1LTQ3Y2YtYTRkNy1kZGFjYWJmZjRhNzkiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJ0cmluaHZhbmh1bmdAZ21haWwuY29tIiwidXNlcm5hbWUiOiJ0cmluaHZhbmh1bmdAZ21haWwuY29tIiwiZnVsbF9uYW1lIjoiVHJpbmggVmFuIEh1bmciLCJlbWFpbCI6InRyaW5odmFuaHVuZ0BnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6InRydWUiLCJqdGkiOiJhMTY2MDQwOGNhMGFkYWQxOTcwZDVhNWZhMmFjNjM1NSIsImFtciI6WyJleHRlcm5hbCJdfQ.cpc3almBHrGu-c-sQ72hq6rdwOiWB1dIy1LfZ6cgjyH4YaBWiQkPt4l7M_nTlJnVOdFt9lM2OuSmCcTJMcAKLd4UmdBypeZUpTZp_bUv1Sd3xV8LHF7FSj2Awgw0HIaic08h1LaRg0pPzzf-IRJFT7YA8Leuceid6rD4BCQ3yNvz8r58u2jlCXuPGI-xA8W4Y3151hpNWCtemyizhzi7EKri_4WWpXrXPAeTAnZSdoSq87shTxm9Kyz_QJUBQN6PIEINl9sIQaKL-I_jR9LogYB_aM3hs81Ga6h-n-vbnFK8JR1JEJQmU-rxyX7XvuL-UjQVag3LxQeJwH7Nnajkkg",
        "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
        "sec-ch-ua-mobile": "?0",
        "sec-fetch-dest": "empty",
        "sec-fetch-mode": "cors",
        "sec-fetch-site": "same-site"
      },
      "referrerPolicy": "no-referrer",
      "body": null,
      "method": "GET",
      "mode": "cors",
      agent,
    }).then(res => res.text()).then(data => {
      // console.log(symbol, type, period, limit,data)
      if (data.includes("message")) return { success: false }
      let js = JSON.parse(data);
      if (js != null) js["success"] = true; else {
        js = { success: true }
      }
      return js;
    });
  }
  let limit = 50;
  let limitY = 30;
  let all = [f(symbol, "IS", "Q", limit), f(symbol, "IS", "Y", limitY),
  f(symbol, "BS", "Q", limit), f(symbol, "BS", "Y", limitY)]
  let a = await Promise.all(all);
  let success = true;
  for (let e of a) {
    if (!e.success) { success = false; break; }
  }
  let log = true;
  while (!success) {
    await Exchange.wait(100);
    limit--;
    limitY--;
    if (limit <= 0) limit = 0;
    if (limitY <= 0) limitY = 0;

    a.forEach(
      async (e, i) => {
        if (e.success) return;
        if (i == 0) { a[i] = await f(symbol, "IS", "Q", limit) }
        if (i == 1) { a[i] = await f(symbol, "IS", "Y", limitY) }
        if (i == 2) { a[i] = await f(symbol, "BS", "Q", limit) }
        if (i == 3) { a[i] = await f(symbol, "BS", "Y", limitY) }
      })
    // all = [f(symbol, "IS", "Q", limit), f(symbol, "IS", "Y", limitY),
    // f(symbol, "BS", "Q", limit), f(symbol, "BS", "Y", limitY)]
    // a = await Promise.all(all);
    success = true;
    for (let e of a) {
      if (!e.success) {
        if (log) {
          console.log(symbol, e)
          log = false;
        }
        success = false; break;
      }
    }
  }

  return { Q1: a[0], Y1: a[1], Q2: a[2], Y2: a[3], symbol: symbol };
}


Exchange.wait = function (ms) {
  return new Promise(resolve => {
    setTimeout(() => {
      resolve(0);
    }, ms);
  });
}


Exchange.VietStock = function () {

}
Exchange.VietStock.GetStockDealDetail = async function (code) {
  let vietFetch = async (code) => {
    return await fetch("https://finance.vietstock.vn/data/getstockdealdetail", {
      "headers": {
        "accept": "*/*",
        "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
        "content-type": "application/x-www-form-urlencoded; charset=UTF-8",
        "sec-ch-ua": "\"Google Chrome\";v=\"111\", \"Not(A:Brand\";v=\"8\", \"Chromium\";v=\"111\"",
        "sec-ch-ua-mobile": "?0",
        "sec-ch-ua-platform": "\"Windows\"",
        "sec-fetch-dest": "empty",
        "sec-fetch-mode": "cors",
        "sec-fetch-site": "same-origin",
        "x-requested-with": "XMLHttpRequest",
        "cookie": "dable_uid=46723758.1644994739059; __gpi=UID=00000bd97c7cdd2f:T=1678806513:RT=1678806513:S=ALNI_MadDA1XpVCXeuv0P1jWAh4zYS0_8w; language=vi-VN; ASP.NET_SessionId=ogswqimyivnxichlp13xi34c; __RequestVerificationToken=Igoh9CdTNDN_t4J8S1YFQhkDeQfYKuWmPckzDmUCmh5Du6wu_HGPQOml50xCsaaVnb7fKjxbUdiGOQ061Owvs3AZyBdJbyM2OIEAI9gIGVI1; __gads=ID=721c8eaa2e8f22d3-22f8c7cda5d000cd:T=1645157750:S=ALNI_MZh5NgENMPsCTg6pJbv8zxT4E9E0g; panoramaId_expiry=1679411315932; _cc_id=a013cc43b44e1570bea28d91e839eaa3; panoramaId=8722d4a89952df2a29480af8ec3916d539382765cf514dd8159e219acf1c5666; vts_usr_lg=32F94DB391D74621542297042A904D5CAD0E0D7F82652193914A79DEB0ADE90261EC0D3F2F946C9E3EA7C178E9F9F44A4665799A13285E75ABF9CBD0AF775B2F218E50C808EF7A8607967CBC1E83B163D195D3165EF42335AFE167B089F117343D87EDC984906A030675896CE79C30A32C71903D6268199A2CAE33AB989ED06B; finance_viewedstock=HPG,; Theme=Light; _pbjs_userid_consent_data=3524755945110770; _gid=GA1.2.2091741562.1678806641; cto_bidid=ErD4ol9OJTJCSDZtclFHSEF2VHBnWG1VU3klMkZPNyUyQjF3NTFkNjFkTDRNZEhRMlY2dm1HYnUzRGtWSiUyQjlmRmJmVEdObmFUd0lmUFJaS2hMJTJGaGJwMlA4SUVQQ3BkemlNRDFMdXgzc3lqYWxEUnFVYnpIbmMlM0Q; cto_bundle=JNwMhl9NZjBxRmpsak5QTWxDSyUyRndvYW0zUzdNNTRBNVFhckJqc0JtQkdlRGV2WEVHTXlSdyUyQnJqeXFtcmxhcCUyRmtkU1B5dTI3aGROOWMzZ2c3bHVUNEFDZEVPemoxMVJySnRYOGVOSzlibjFkTDVUN1U5OWRjZk1QZTJoajZydG5peGZYbW9NOWJmRSUyRkt6WXZGcVF1czNtcWJmZyUzRCUzRA; _ga=GA1.1.332676730.1645157750; _ga_EXMM0DKVEX=GS1.1.1678806513.1.1.1678806756.0.0.0",
        "Referer": "https://finance.vietstock.vn/HPG/thong-ke-giao-dich.htm",
        "Referrer-Policy": "strict-origin-when-cross-origin"
      },
      "body": "code=" + code + "&seq=0&__RequestVerificationToken=HP_jzP_8uVvcAdSiLii8tf2-Y9IdI9fGcmiiQL9n2iYcU8oHmezNkt4rA5-hHn87tINYh1LifAq_JMlY8IavLe53_RddBcu7BqI7M6vh4qWMLyfRYRSWS5Xu00Q729IZ0",
      "method": "POST",
      agent
    });
  }
  let a = await vietFetch(code);

  let data = await a.text();
  // console.log(data)
  while (!data.startsWith("[")) {
    await Exchange.wait(200);
    a = await vietFetch(code);
    data = await a.text();
  }
  data = JSON.parse(data);
  // console.table(data);
  return { Code: code, data: data };
}

Exchange.TCBS = function () {

}


Exchange.TCBS.intraday = async function (code) {
  let a = await fetch("https://apipubaws.tcbs.com.vn/stock-insight/v1/intraday/" + code + "/his/paging?page=0&size=2000000&headIndex=-1", {
    "headers": {
      "accept": "application/json",
      "accept-language": "vi",
      "authorization": "Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJhdXRoZW5fc2VydmljZSIsImV4cCI6MTY3NTk2NDQzNiwianRpIjoiIiwiaWF0IjoxNjc1OTM1NjM2LCJzdWIiOiIxMDAwMDM2Nzk2NCIsImN1c3RvZHlJRCI6IjEwNUNENjQ5ODgiLCJlbWFpbCI6IlRSSU5IVkFOSFVOR0BHTUFJTC5DT00iLCJyb2xlcyI6WyJjdXN0b21lciJdLCJzdGVwdXBfZXhwIjowLCJzb3RwX3NpZ24iOiIiLCJjbGllbnRfa2V5IjoiMTAwMDAzNjc5NjQuQWFrSzlTSWNPVnFWR1lwYkVFZXMiLCJzZXNzaW9uSUQiOiIxYzRkNTkwNS1jOWFiLTQ2NTItOTUwYi03NzM0NTM3MDkzNjciLCJhY2NvdW50X3N0YXR1cyI6IjEiLCJvdHAiOiIiLCJvdHBUeXBlIjoiIiwib3RwU291cmNlIjoiVENJTlZFU1QiLCJvdHBTZXNzaW9uSWQiOiIifQ.9OhqnK7Msi_JC7VMT6AXLcihhZjdE7YZeRrZdNiw6__JgxNe_Q7f2UYqgIMd-blN8bo6FUOVJSMA9V8vRtQrtAc8FdBXYhz6p8_-bAlA78qZmwfn7AUHdGbZW5_bO6NDrk9Y_hhakROlehcqVHuDbZwNuJHQgoH-qsF0Gnqamt0povTNoCx-Lq8-_CSSxFHRriAURWk_l2SLFciPIBLOnmnrT8RNwg4lPMX3NY7bLKokUJinQP32iJeegMhGnuVfYn7nlWGhMFhQGfFJIP1aE3z_m-8KpZwJAAN6VlWAKSpN_v1aaLMqQn6ol6KkZh2KEyEz_hPwOPFAyawBMenyXw",
      "content-type": "application/json",
      "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
      "sec-ch-ua-mobile": "?0"
    },
    "referrer": "https://tcinvest.tcbs.com.vn/",
    "referrerPolicy": "strict-origin-when-cross-origin",
    "body": null,
    "method": "GET",
    "mode": "cors",
    agent
  });

  let data = await a.json();
  // console.table(data.data)
  return { Code: code, data: data.data };
}



Exchange.VCI = function () {

}


Exchange.VCI.getAll = async function (code) {
  let f = async (code) => {
    return await fetch("https://mt.vcsc.com.vn/api/market-watch/LEData/getAll", {
      "headers": {
        "accept": "application/json, text/plain, */*",
        "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
        "content-type": "application/json",
        "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
        "sec-ch-ua-mobile": "?0",
        "sec-fetch-dest": "empty",
        "sec-fetch-mode": "cors",
        "sec-fetch-site": "same-origin",
        "cookie": "_gcl_au=1.1.1709771188.1675938152; _gid=GA1.3.1706305419.1675938152; _fbp=fb.2.1675938153544.2137347642; lang=vi; _gat_UA-199803197-1=1; _ga=GA1.1.1389260542.1675938152; _ga_EWEC6D4464=GS1.1.1675938152.1.1.1675938310.57.0.0"
      },
      "referrer": "https://mt.vcsc.com.vn/board",
      "referrerPolicy": "strict-origin-when-cross-origin",
      "body": "{\"symbol\":\"" + code + "\",\"limit\":2000000,\"truncTime\":null}",
      "method": "POST",
      "mode": "cors",
      agent
    });
  }
  let a = await f(code);
  let data = await a.text();
  while (!data.startsWith("[")) {
    logger.warn(code, data);
    await Exchange.wait(200);
    a = await f(code);
    data = await a.text();
  }
  data = JSON.parse(data);
  // let data = await a.json();
  // console.table(data.data)
  return { Code: code, data: data };
}

Exchange.SSI = function () {

}

Exchange.SSI.graphql = async function (code) {
  let stockNo = map[code];
  if (stockNo == undefined) { }

  let fetchGQL = (stockNo) => {
    return fetch("https://wgateway-iboard.ssi.com.vn/graphql", {
      "headers": {
        "accept": "*/*",
        "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
        "content-type": "application/json",
        "g-captcha": "",
        "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
        "sec-ch-ua-mobile": "?0",
        "sec-fetch-dest": "empty",
        "sec-fetch-mode": "cors",
        "sec-fetch-site": "same-site"
      },
      "referrer": "https://iboard.ssi.com.vn/",
      "referrerPolicy": "strict-origin-when-cross-origin",
      "body": "{\"operationName\":\"leTables\",\"variables\":{\"stockNo\":\"" + stockNo + "\"},\"query\":\"query leTables($stockNo: String) {\\n  leTables(stockNo: $stockNo) {\\n    stockNo\\n    price\\n    vol\\n    accumulatedVol\\n    time\\n    ref\\n    side\\n    priceChange\\n    priceChangePercent\\n    changeType\\n    __typename\\n  }\\n  stockRealtime(stockNo: $stockNo) {\\n    stockNo\\n    ceiling\\n    floor\\n    refPrice\\n    stockSymbol\\n    __typename\\n  }\\n}\\n\"}",
      "method": "POST",
      "mode": "cors",
      agent
    });
  }
  let a = await fetchGQL(stockNo);
  let data = await a.text();
  data = data.trim();

  while (!(data.startsWith("{") && data.endsWith("}"))) {
    if (logger.isDebugEnabled) {
      logger.debug(data)
    }
    await Exchange.wait(200);

    a = await fetchGQL(stockNo);
    data = await a.text();
    data = data.trim();
  }
  // Exchange.wait()
  data = JSON.parse(data);
  // console.table(data.data.leTables)  
  return { Code: code, data: data.data.leTables, stockRealtime: data.data.stockRealtime };
}

let map = {};
Exchange.SSI.getlistallsymbol = async function () {
  let ex = ['hose', 'hnx', 'upcom']
  let ret = [];

  let promise = new Promise((resolve, reject) => {
    let c = 0;
    ex.forEach(async e => {
      let a = await fetch("https://wgateway-iboard.ssi.com.vn/graphql", {
        "headers": {
          "accept": "*/*",
          "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
          "content-type": "application/json",
          "g-captcha": "",
          "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
          "sec-ch-ua-mobile": "?0",
          "sec-fetch-dest": "empty",
          "sec-fetch-mode": "cors",
          "sec-fetch-site": "same-site"
        },
        "referrer": "https://iboard.ssi.com.vn/",
        "referrerPolicy": "strict-origin-when-cross-origin",
        "body": "{\"operationName\":\"stockRealtimes\",\"variables\":{\"exchange\":\"" + e + "\"},\"query\":\"query stockRealtimes($exchange: String) {\\n  stockRealtimes(exchange: $exchange) {\\n    stockNo\\n    ceiling\\n    floor\\n    refPrice\\n    stockSymbol\\n    stockType\\n    exchange\\n    prevMatchedPrice\\n    lastMatchedPrice\\n    matchedPrice\\n    matchedVolume\\n    priceChange\\n    priceChangePercent\\n    highest\\n    avgPrice\\n    lowest\\n    nmTotalTradedQty\\n    best1Bid\\n    best1BidVol\\n    best2Bid\\n    best2BidVol\\n    best3Bid\\n    best3BidVol\\n    best4Bid\\n    best4BidVol\\n    best5Bid\\n    best5BidVol\\n    best6Bid\\n    best6BidVol\\n    best7Bid\\n    best7BidVol\\n    best8Bid\\n    best8BidVol\\n    best9Bid\\n    best9BidVol\\n    best10Bid\\n    best10BidVol\\n    best1Offer\\n    best1OfferVol\\n    best2Offer\\n    best2OfferVol\\n    best3Offer\\n    best3OfferVol\\n    best4Offer\\n    best4OfferVol\\n    best5Offer\\n    best5OfferVol\\n    best6Offer\\n    best6OfferVol\\n    best7Offer\\n    best7OfferVol\\n    best8Offer\\n    best8OfferVol\\n    best9Offer\\n    best9OfferVol\\n    best10Offer\\n    best10OfferVol\\n    buyForeignQtty\\n    buyForeignValue\\n    sellForeignQtty\\n    sellForeignValue\\n    caStatus\\n    tradingStatus\\n    remainForeignQtty\\n    currentBidQty\\n    currentOfferQty\\n    session\\n    __typename\\n  }\\n}\\n\"}",
        "method": "POST",
        "mode": "cors",
        agent
      });
      let data = await a.json();
      ret.push(...data.data.stockRealtimes);
      c++;
      if (c == 3) {
        resolve(ret)
      }
    });
  })

  await promise;
  // avgPrice: 4530.86
  // best1Bid: 4500
  // best1BidVol: 20900
  // best1Offer: 4600
  // best1OfferVol: 12700
  // best2Bid: 4400
  // best2BidVol: 136500
  // best2Offer: 4700
  // best2OfferVol: 70800
  // best3Bid: 4300
  // best3BidVol: 171400
  // best3Offer: 4800
  // best3OfferVol: 46900
  // best4Bid: 0
  // best4BidVol: 0
  // best4Offer: 4900
  // best4OfferVol: 84800
  // best5Bid: 0
  // best5BidVol: 0
  // best5Offer: 5000
  // best5OfferVol: 71500
  // best6Bid: 0
  // best6BidVol: 0
  // best6Offer: 5100
  // best6OfferVol: 28400
  // best7Bid: 0
  // best7BidVol: 0
  // best7Offer: 0
  // best7OfferVol: 0
  // best8Bid: 0
  // best8BidVol: 0
  // best8Offer: 0
  // best8OfferVol: 0
  // best9Bid: 0
  // best9BidVol: 0
  // best9Offer: 0
  // best9OfferVol: 0
  // best10Bid: 0
  // best10BidVol: 0
  // best10Offer: 0
  // best10OfferVol: 0
  // buyForeignQtty: 3100
  // buyForeignValue: 14260000
  // caStatus: ""
  // ceiling: 5100
  // currentBidQty: 328800
  // currentOfferQty: 315100
  // exchange: "hnx"
  // floor: 4300
  // highest: 4700
  // lastMatchedPrice: 4500
  // lowest: 4500
  // matchedPrice: 4500
  // matchedVolume: 500
  // nmTotalTradedQty: 314600
  // prevMatchedPrice: 0
  // priceChange: "-200.00"
  // priceChangePercent: "-4.3"
  // refPrice: 4700
  // remainForeignQtty: 33775916
  // sellForeignQtty: null
  // sellForeignValue: null
  // session: "C"
  // stockNo: "hnx:77359"
  // stockSymbol: "AAV"
  // stockType: "s"
  // tradingStatus: null
  ret.forEach(e => {
    map[e.stockSymbol] = e.stockNo;
  });

  console.log(map.size)
  return ret;
}

Exchange.SSI.vn30 = async () => {
  let a = await fetch("https://wgateway-iboard.ssi.com.vn/graphql", {
    "headers": {
      "accept": "*/*",
      "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
      "content-type": "application/json",
      "g-captcha": "",
      "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
      "sec-ch-ua-mobile": "?0",
      "sec-fetch-dest": "empty",
      "sec-fetch-mode": "cors",
      "sec-fetch-site": "same-site"
    },
    "referrer": "https://iboard.ssi.com.vn/",
    "referrerPolicy": "strict-origin-when-cross-origin",
    "body": "{\"operationName\":\"stockRealtimesByGroup\",\"variables\":{\"group\":\"VN30\"},\"query\":\"query stockRealtimesByGroup($group: String) {\\n  stockRealtimesByGroup(group: $group) {\\n    stockNo\\n    ceiling\\n    floor\\n    refPrice\\n    stockSymbol\\n    stockType\\n    exchange\\n    lastMatchedPrice\\n    matchedPrice\\n    matchedVolume\\n    priceChange\\n    priceChangePercent\\n    highest\\n    avgPrice\\n    lowest\\n    nmTotalTradedQty\\n    best1Bid\\n    best1BidVol\\n    best2Bid\\n    best2BidVol\\n    best3Bid\\n    best3BidVol\\n    best4Bid\\n    best4BidVol\\n    best5Bid\\n    best5BidVol\\n    best6Bid\\n    best6BidVol\\n    best7Bid\\n    best7BidVol\\n    best8Bid\\n    best8BidVol\\n    best9Bid\\n    best9BidVol\\n    best10Bid\\n    best10BidVol\\n    best1Offer\\n    best1OfferVol\\n    best2Offer\\n    best2OfferVol\\n    best3Offer\\n    best3OfferVol\\n    best4Offer\\n    best4OfferVol\\n    best5Offer\\n    best5OfferVol\\n    best6Offer\\n    best6OfferVol\\n    best7Offer\\n    best7OfferVol\\n    best8Offer\\n    best8OfferVol\\n    best9Offer\\n    best9OfferVol\\n    best10Offer\\n    best10OfferVol\\n    buyForeignQtty\\n    buyForeignValue\\n    sellForeignQtty\\n    sellForeignValue\\n    caStatus\\n    tradingStatus\\n    remainForeignQtty\\n    currentBidQty\\n    currentOfferQty\\n    session\\n    tradingUnit\\n    __typename\\n  }\\n}\\n\"}",
    "method": "POST",
    "mode": "cors"
  });

  return await a.json();
}


Exchange.SSI.stockRealtimes = async (exchange) => {
  let a = await fetch("https://wgateway-iboard.ssi.com.vn/graphql", {
    "headers": {
      "accept": "*/*",
      "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
      "content-type": "application/json",
      "g-captcha": "",
      "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
      "sec-ch-ua-mobile": "?0",
      "sec-fetch-dest": "empty",
      "sec-fetch-mode": "cors",
      "sec-fetch-site": "same-site"
    },
    "referrer": "https://iboard.ssi.com.vn/",
    "referrerPolicy": "strict-origin-when-cross-origin",
    "body": "{\"operationName\":\"stockRealtimes\",\"variables\":{\"exchange\":\"" + exchange + "\"},\"query\":\"query stockRealtimes($exchange: String) {\\n  stockRealtimes(exchange: $exchange) {\\n    stockNo\\n    ceiling\\n    floor\\n    refPrice\\n    stockSymbol\\n    stockType\\n    exchange\\n    prevMatchedPrice\\n    lastMatchedPrice\\n    matchedPrice\\n    matchedVolume\\n    priceChange\\n    priceChangePercent\\n    highest\\n    avgPrice\\n    lowest\\n    nmTotalTradedQty\\n    best1Bid\\n    best1BidVol\\n    best2Bid\\n    best2BidVol\\n    best3Bid\\n    best3BidVol\\n    best4Bid\\n    best4BidVol\\n    best5Bid\\n    best5BidVol\\n    best6Bid\\n    best6BidVol\\n    best7Bid\\n    best7BidVol\\n    best8Bid\\n    best8BidVol\\n    best9Bid\\n    best9BidVol\\n    best10Bid\\n    best10BidVol\\n    best1Offer\\n    best1OfferVol\\n    best2Offer\\n    best2OfferVol\\n    best3Offer\\n    best3OfferVol\\n    best4Offer\\n    best4OfferVol\\n    best5Offer\\n    best5OfferVol\\n    best6Offer\\n    best6OfferVol\\n    best7Offer\\n    best7OfferVol\\n    best8Offer\\n    best8OfferVol\\n    best9Offer\\n    best9OfferVol\\n    best10Offer\\n    best10OfferVol\\n    buyForeignQtty\\n    buyForeignValue\\n    sellForeignQtty\\n    sellForeignValue\\n    caStatus\\n    tradingStatus\\n    remainForeignQtty\\n    currentBidQty\\n    currentOfferQty\\n    session\\n    __typename\\n  }\\n}\\n\"}",
    "method": "POST",
    "mode": "cors"
  });

  return await a.json();
}

Exchange.VCBS = function () { }
Exchange.VCBS.priceBoard = async function (code) {
  let a = await fetch("https://priceboard.vcbs.com.vn/PriceBoard/Acc/amw", {
    "headers": {
      "accept": "application/json, text/javascript, */*; q=0.01",
      "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
      "content-type": "application/json",
      "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
      "sec-ch-ua-mobile": "?0",
      "sec-fetch-dest": "empty",
      "sec-fetch-mode": "cors",
      "sec-fetch-site": "same-origin",
      "x-requested-with": "XMLHttpRequest",
      "cookie": "_ga=GA1.3.1462273620.1676000765; _gid=GA1.3.531209726.1676000765; ASPSESSIONIDQGTATBRQ=DLMJOOMCMMCHNKALIEEGHGFB; ASP.NET_SessionId=egc5dlcqa0cqvj5ckgnfblkc; delChartCookie=2; viewIdselectTab=1; critIdselectTab=-11; groupIdTab=; TabIdselectTab=4; LISTSETTINGMKT=%7C%7CCookie%7C%7CHOSE%7C%7CCookie%7C%7C30%7C%7CCookie%7C%7CHNX%7C%7CCookie%7C%7CHNX30%7C%7CCookie%7C%7CUPCOM%7C%7CCookie%7C%7CHNXMan%7C%7CCookie%7C%7CHNXFin%7C%7CCookie%7C%7CSML%7C%7CCookie%7C%7CMID%7C%7CCookie%7C%7CALL%7C%7CCookie%7C%7CXALL%7C%7CCookie%7C%7C100%7C%7CCookie%7C%7CHNXCON%7C%7CCookie%7C%7CETF%7C%7CCookie%7C%7CHNXMSCap%7C%7CCookie%7C%7CHNX30TRI%7C%7CCookie%7C%7CHNXLCap%7C%7CCookie%7C%7CX50%7C%7CCookie%7C%7CSI; checkAllMkt=true; HOSE=true; 30=true; HNX=true; HNX30=true; UPCOM=true; HNXFin=true; SML=true; MID=true; ALL=true; XALL=true; 100=true; HNXMan=true; HNXCON=true; ETF=true; HNXMSCap=true; HNX30TRI=true; HNXLCap=true; X50=true; SI=true; s_8_s=false"
    },
    "referrer": "https://priceboard.vcbs.com.vn/Priceboard",
    "referrerPolicy": "strict-origin-when-cross-origin",
    "body": "{\"selectedStocks\":\"" + code + "\",\"criteriaId\":1,\"marketId\":0,\"lastSeq\":0,\"isReqTL\":true,\"isReqMK\":false,\"tlSymbol\":\"" + code + "\",\"pthMktId\":\"\",\"isIncrValue\":true,\"isOddLot\":false}",
    "method": "POST",
    "mode": "cors",
    agent
  });

  let data = await a.json();
  let his = data.tl.f.map(e => {
    let o = {};
    o.symbol = e.s;
    o.time = e.f.i[0];
    o.price = e.f.i[1];
    o.change = e.f.i[2];
    o.vol = e.f.i[3];
    o.total = e.f.i[4];
    o.side = e.f.i[5];
    return o;
  })
  his.reverse();
  // console.table(data.data.leTables)
  return { Code: code, data: his, };
}

Exchange.MBS = function () { }
Exchange.MBS.pbRltCharts = async function (code, resolution) {
  // console.log("resolution",resolution)
  let start = 1421028900;
  let end = Math.floor(Date.now() / 1000);
  let delta = 12 * 30 * 24 * 60 * 60;
  let end2 = start + delta;
  let out = { t: [], v: [], o: [], c: [], h: [], l: [] };
  let resol = ["1", "5", "60", "D"]
  if (!resol.includes(resolution)) {
    resolution = "5";
  }
  // console.log("resolution",resolution)
  let uq = {};
  while (true) {
    let a = await fetch("https://chartdata1.mbs.com.vn/pbRltCharts/chart/v2/history?symbol=" + code + "&resolution=" + resolution + "&from=" + start + "&to=" + end2, {
      "headers": {
        "accept": "*/*",
        "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
        "content-type": "text/plain",
        "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
        "sec-ch-ua-mobile": "?0",
        "sec-fetch-dest": "empty",
        "sec-fetch-mode": "cors",
        "sec-fetch-site": "same-site"
      },
      "referrer": "https://sweb.mbs.com.vn/",
      "referrerPolicy": "strict-origin-when-cross-origin",
      "body": null,
      "method": "GET",
      "mode": "cors",
      agent
    });
    let z = await a.json();
    if (z.t.length == 0) {
      if (end - start <= 0) {
        break;
      }
      start = end2;
      end2 = start + delta;
      await Exchange.wait(100);
    } else {
      // out.t.push(...z.t);
      // out.v.push(...z.v);
      // out.o.push(...z.o);
      // out.c.push(...z.c);
      // out.h.push(...z.h);
      // out.l.push(...z.l);
      z.t.forEach((t, i) => {
        if (uq[t] == undefined) {
          uq[t] = { t: z.t[i], v: z.v[i], o: z.o[i], c: z.c[i], h: z.h[i], l: z.l[i] };
          out.t.push(z.t[i]);
          out.v.push(z.v[i]);
          out.o.push(z.o[i]);
          out.c.push(z.c[i]);
          out.h.push(z.h[i]);
          out.l.push(z.l[i]);
        }
      });
      if (start == z.t.at(-1)) start = end2;
      else start = z.t.at(-1);
      end2 = start + delta;
    }
  }

  out = out.t.map((e, i) => {
    return { symbol: code, time: out.t[i], close: out.c[i], open: out.o[i], high: out.h[i], low: out.l[i], vol: out.v[i] }
  })
  return { Code: code, data: out, };
}

Exchange.MBS.pbRltCharts2 = async function (code, resolution, from) {
  // console.log("resolution",resolution)
  let start = from;
  if (start == undefined) start = 1421028900;

  // start = 1421028900;
  let end = Math.floor(Date.now() / 1000);
  let end2 = start + 6 * 30 * 24 * 60 * 60;
  let out = { t: [], v: [], o: [], c: [], h: [], l: [] };
  let resol = ["1", "5", "60", "D"]
  if (!resol.includes(resolution)) {
    resolution = "5";
  }
  // console.log("resolution", resolution, start, end2)
  let c = 0;
  let uq = {};
  while (true) {
    let a = await fetch("https://chartdata1.mbs.com.vn/pbRltCharts/chart/v2/history?symbol=" + code + "&resolution=" + resolution + "&from=" + start + "&to=" + end2, {
      "headers": {
        "accept": "*/*",
        "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
        "content-type": "text/plain",
        "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
        "sec-ch-ua-mobile": "?0",
        "sec-fetch-dest": "empty",
        "sec-fetch-mode": "cors",
        "sec-fetch-site": "same-site"
      },
      "referrer": "https://sweb.mbs.com.vn/",
      "referrerPolicy": "strict-origin-when-cross-origin",
      "body": null,
      "method": "GET",
      "mode": "cors",
      agent
    });
    let z = await a.json();
    if (z.t.length == 0) {
      if (end - start <= 0) {
        break;
      }
      start = end2;
      end2 = start + 6 * 30 * 24 * 60 * 60;
    }
    else {
      // out.t.push(...z.t);
      // out.v.push(...z.v);
      // out.o.push(...z.o);
      // out.c.push(...z.c);
      // out.h.push(...z.h);
      // out.l.push(...z.l);
      z.t.forEach((t, i) => {
        if (uq[t] == undefined) {
          uq[t] = { t: z.t[i], v: z.v[i], o: z.o[i], c: z.c[i], h: z.h[i], l: z.l[i] };
          out.t.push(z.t[i]);
          out.v.push(z.v[i]);
          out.o.push(z.o[i]);
          out.c.push(z.c[i]);
          out.h.push(z.h[i]);
          out.l.push(z.l[i]);
        } else {
          c++;
          // console.log("Old ", uq[t], c);
          // console.log("New ", { t: z.t[i], v: z.v[i], o: z.o[i], c: z.c[i], h: z.h[i], l: z.l[i] }, c);
        }
      });
      if (start == z.t.at(-1)) start = end2;
      else start = z.t.at(-1);
      end2 = start + 6 * 30 * 24 * 60 * 60;
    }

  }
  return { Code: code, data: out, };
}