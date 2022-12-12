import fetch from "node-fetch";
import fs from "fs";
import log4js from "log4js";
import { Parser } from "json2csv"
var logger = log4js.getLogger();
import { SMA, EMA } from 'technicalindicators';
import IchimokuCloud from 'technicalindicators'
import path from "path";

log4js.configure({
  appenders: {
    everything: { type: "file", filename: "diem.log" },
    console: { type: "console" },
  },
  categories: {
    default: { appenders: ["everything", "console"], level: "INFO" },
  },
});

(async () => {
  let cop = [];

  let counter = 0;
  let csv = new Parser({ fields: ['price', 'change', 'match_qtty', 'side', 'time', 'total_vol'] });
  cop = await getlistallstock();


  let dir = "./his/";
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir);
  }
  let files = fs.readdirSync(dir);
  for (const file of files) {
    loadData(path.join(dir, file).toString());
  }

  gap.sort((a, b) => {
    if (a.ratio < b.ratio) return -1;
    if (a.ratio > b.ratio) return 1;
    return 0;
  });


  // console.log(gap);

  for (let e of gap) {
    logger.info(e);
  }

  // for (let x of cop) {
  //   x['Code'] = x.stock_code;
  //   if (x.Code.length < 4) {
  //     fs.appendFile('code.txt', x.Code + "\n", function (err) {
  //       if (err) throw err;
  //     });

  //     console.log(x.Code)

  //     let z = getTrans(x.Code);
  //     z.then((ret) => {
  //       counter++;
  //       console.log(ret.data.length, ret.status, ret.execute_time_ms, counter, ret.Code);
  //       let data2 = csv.parse(ret.data);
  //       fs.appendFile("./trans/" + ret.Code + '_trans.txt', data2 + "\n", function (err) {
  //         if (err) throw err;
  //       });
  //     })
  //   }
  // }
})();

async function loadData(path) {
  var data = fs.readFileSync(path)
    .toString()
    .split('\n')
    .map(e => e.trim())
    .map(e => e.split(',').map(e => e.trim()));
  let head = data[0];
  data = data.slice(1);
  data = data.map(e => {
    let x = {};
    for (let i = 0; i < head.length; i++) {
      x[head[i].replaceAll("\"", "")] = e[i];
    }
    return x;
  })
  data = data.reverse();
  data = data.slice(1);
  // console.log(data[0]);
  if (logger.isDebugEnabled)
    logger.debug(data);

  var prices = data.map(e => +e.priceClose / +e.adjRatio);
  var high = data.map(e => +e.priceHigh);
  var low = data.map(e => +e.priceLow);
  var vol = data.map(e => +e.dealVolume);
  // console.log(prices);

  checkMA(prices, vol, path.substr(4, 3), path);

  var ichimokuInput = {
    high: high,
    low: low,
    conversionPeriod: 9,
    basePeriod: 26,
    spanPeriod: 52,
    displacement: 26
  }

  var ichimoku = IchimokuCloud.ichimokucloud(ichimokuInput)
  if (logger.isDebugEnabled)
    logger.debug(ichimoku);

}
let gap = [];
async function checkMA(prices, vol, symbol, path) {
  let periods = [5, 8, 20, 50, 100, 200];

  let smaRet = periods.map(e => { return SMA.calculate({ period: e, values: prices }); });
  let smaVolRet = periods.map(e => { return SMA.calculate({ period: e, values: vol }); });
  let emaRet = periods.map(e => { return EMA.calculate({ period: e, values: prices }); });
  // console.log(prices.length);
  // console.log(smaRet[0].length);
  // console.log(emaRet.length);
  // console.log(prices[prices.length-1],smaRet[0][smaRet[0].length-1])

  if (smaVolRet[0][smaVolRet[0].length - 1] > 100000) {
    if ((prices[prices.length - 1] >= smaRet[0][smaRet[0].length - 1])) {
      // logger.info(path);
      // logger.info("Price over SMA5", symbol, "prices ", prices[prices.length - 1], " sma ", smaRet[0][smaRet[0].length - 1])

      // let delta =  prices[prices.length - 1] - smaRet[2][smaRet[2].length - 1];
      // gap.push({
      //   ratio: (delta / smaRet[2][smaRet[2].length - 1]), "symbol": symbol, "path": path,
      //   "price": prices[prices.length - 1],
      //   "ma25": smaRet[2][smaRet[2].length - 1],
      //   "vol": smaVolRet[0][smaVolRet[0].length - 1]
      // });
    } else {
      // logger.info("Price under SMA5", symbol, "prices ", prices[prices.length - 1], " sma ", smaRet[0][smaRet[0].length - 1])
    }

    if ((prices[prices.length - 1] >= smaRet[1][smaRet[1].length - 1]) && ( smaRet[1][smaRet[1].length - 1] > smaRet[2][smaRet[2].length - 1])) {
      logger.info("Price over SMA9", symbol, "prices ", prices[prices.length - 1], " sma ", smaRet[1][smaRet[1].length - 1])

      let delta =  prices[prices.length - 1] - smaRet[2][smaRet[2].length - 1];
      gap.push({
        ratio: (delta / smaRet[2][smaRet[2].length - 1]), "symbol": symbol, "path": path,
        "price": prices[prices.length - 1],
        "ma25": smaRet[2][smaRet[2].length - 1],
        "vol": smaVolRet[0][smaVolRet[0].length - 1]
      });      
    } else {
      // logger.info("Price under SMA9", symbol, "prices ", prices[prices.length - 1], " sma ", smaRet[1][smaRet[1].length - 1])
    }

    if ((prices[prices.length - 1] >= smaRet[2][smaRet[2].length - 1])) {
      // logger.info("Price over SMA20", symbol, "prices ", prices[prices.length - 1], " sma ", smaRet[2][smaRet[2].length - 1])
    } else {
      // logger.info("Price under SMA25", symbol, "prices ", prices[prices.length - 1], " sma ", smaRet[2][smaRet[2].length - 1], smaVolRet[0][smaVolRet[0].length - 1])

      let delta = smaRet[2][smaRet[2].length - 1] - prices[prices.length - 1];
      // gap.push({
      //   ratio: (delta / smaRet[2][smaRet[2].length - 1]), "symbol": symbol, "path": path,
      //   "price": prices[prices.length - 1],
      //   "ma25": smaRet[2][smaRet[2].length - 1],
      //   "vol": smaVolRet[0][smaVolRet[0].length - 1]
      // });


    }
    if ((prices[prices.length - 1] >= smaRet[3][smaRet[3].length - 1])) {
      // logger.info("Price over SMA50", symbol, "prices ", prices[prices.length - 1], " sma ", smaRet[3][smaRet[3].length - 1])
    } else {
      // logger.info("Price under SMA50", symbol, "prices ", prices[prices.length - 1], " sma ", smaRet[3][smaRet[3].length - 1], smaVolRet[0][smaVolRet[0].length - 1])
    }
  }
}


async function getTrans(symbol) {
  let a = await fetch("https://api-finance-t19.24hmoney.vn/v1/web/stock/transaction-list-ssi?device_id=web&device_name=INVALID&device_model=Windows+10&network_carrier=INVALID&connection_type=INVALID&os=Chrome&os_version=92.0.4515.131&app_version=INVALID&access_token=INVALID&push_token=INVALID&locale=vi&browser_id=web16693664wxvsjkxelc6e8oe325025&symbol=" + symbol + "&page=1&per_page=2000000", {
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

async function getlistallstock() {
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


async function getCoporate() {
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
    /**
     * 
        console.log(cop)    
        json2csv.json2csv(cop, (err, csv) => {
          if (err) {
            throw err
          }
          // print CSV string
        // console.log(csv)
          // write CSV to a file
          fs.writeFileSync('todos.csv', csv)
        })
    
        json2csv2({data: cop, fields: ['ID', 'CatID', 'Exchange','IndustryName', 'Code', 'Name','TotalShares', 'URL', 'Row','TotalRecord']}, function(err, csv) {
          if (err) console.log(err);
          fs.writeFile('cop.csv', csv, function(err) {
            if (err) throw err;
            console.log('cars file saved');
          });
        });
        let csv = new json2csv2.Parser({ data: cop, fields: ['ID', 'CatID', 'Exchange', 'IndustryName', 'Code', 'Name', 'TotalShares', 'URL', 'Row', 'TotalRecord'] });
    
        let data2 = csv.parse(cop)
        fs.writeFileSync('cop.csv', data2);
        result = data2.includes("\"");
    
        console.log("result ", result)
        console.log(data2);
     */
  });
  data = fs.readFileSync('cop.json');
  cop = JSON.parse(data);
  console.log(cop.length);
}