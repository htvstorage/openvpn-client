import fetch from "node-fetch";
import fs from "fs";
import log4js from "log4js";
import http from "node:http";
import https from "node:https";
import { resolve } from "path";

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
  let x = await a.json();
  x["Code"] = symbol;
  return x;
}


Exchange.transaction = async function (symbol,per_page) {
  let a = await fetch("https://api-finance-t19.24hmoney.vn/v1/web/stock/transaction-list-ssi?device_id=web&device_name=INVALID&device_model=Windows+10&network_carrier=INVALID&connection_type=INVALID&os=Chrome&os_version=92.0.4515.131&app_version=INVALID&access_token=INVALID&push_token=INVALID&locale=vi&browser_id=web16693664wxvsjkxelc6e8oe325025&symbol="
    + symbol
    + "&page=1&per_page="+per_page, {
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
  let x = await a.json();
  x["Code"] = symbol;
  return x;
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
  let fet = await fetch("https://bgapidatafeed.vps.com.vn/getlistallstock", {
    "headers": {
      "accept": "application/json, text/plain, */*",
      "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
      "if-none-match": "W/\"5ac92-c+NqjXQ6D2JFKgaxgUoTpIzr5z8\"",
      "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
      "sec-ch-ua-mobile": "?0",
      "sec-fetch-dest": "empty",
      "sec-fetch-mode": "cors",
      "sec-fetch-site": "same-site"
    },
    "referrer": "https://banggia.vps.com.vn/",
    "referrerPolicy": "strict-origin-when-cross-origin",
    "body": null,
    "method": "GET",
    "mode": "cors"
  });
  let xx = await fet.json();
  console.log(xx.length)
  cop = [...cop, ...xx];
  return cop;
}


Exchange.getlistallsymbol = async function () {
  let exchange = ['hose','hnx','upcom']
  let ret = [];
  let c = 0;


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
        let a=data.slice(1,-1).split(",").map(e=>e.replaceAll("\"", ""));        
        ret = [...ret, ...a];
        if (c == exchange.length) {
          resolve(ret);
          // console.log(ret.length)
        }
      })
    }
  }
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
        a.then(res => res.json()).then(data => {
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