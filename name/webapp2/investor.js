const { parentPort } = require("worker_threads");
const fetch = require("node-fetch-retry");
const fs = require("fs");
const log4js = require("log4js");
const { Parser } = require("json2csv")
const http = require("node:http");
const https = require("node:https");
// const { Exchange } = require("./Exchange.js");
const { map, map10, map20, largeCap, midCap, smallCap, mapCap } = require('./symbols.js')
var logger = log4js.getLogger();
const httpAgent = new http.Agent({ keepAlive: true });
const httpsAgent = new https.Agent({ keepAlive: true });
const agent = (_parsedURL) => _parsedURL.protocol == 'http:' ? httpAgent : httpsAgent;
const xlsx = require("xlsx")

log4js.configure({
  appenders: {
    everything: { type: "file", filename: "diem.log" },
    console: { type: "console" },
  },
  categories: {
    default: { appenders: ["console", "everything"], level: "debug" },
    app: { appenders: ["console"], level: "info" }
  },
});


let investor = async function (code) {

  let invest = (code) => {
    return fetch("https://api-finance-t19.24hmoney.vn/v1/ios/stock/statistic-investor-history?device_id=web1689045n2a2p5iurbndpn3ipbak5dblcxkkkep6795881&device_name=INVALID&device_model=Windows+10&network_carrier=INVALID&connection_type=INVALID&os=Chrome&os_version=115.0.0.0&access_token=INVALID&push_token=INVALID&locale=vi&browser_id=web1689045n2a2p5iurbndpn3ipbak5dblcxkkkep6795881&symbol=" + code, {
      "headers": {
        "accept": "application/json, text/plain, */*",
        "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
        "sec-ch-ua": "\"Not/A)Brand\";v=\"99\", \"Google Chrome\";v=\"115\", \"Chromium\";v=\"115\"",
        "sec-ch-ua-mobile": "?0",
        "sec-ch-ua-platform": "\"Windows\"",
        "sec-fetch-dest": "empty",
        "sec-fetch-mode": "cors",
        "sec-fetch-site": "same-site",
        "Referer": "https://24hmoney.vn/",
        "Referrer-Policy": "strict-origin-when-cross-origin"
      },
      "body": null,
      "method": "GET", agent
    });
  }

  let a = await invest(code);
  let data = await a.text();
  while (!data.startsWith("{")) {
    await Exchange.wait(200);
    a = await invest(code);
    console.log(code, "nok")
    data = await a.text();
  }
  data = JSON.parse(data);
  // console.table(data);
  if (!data.Code) data.Code = code;
  return data;
}

// main
// let stockdata = {};
let checkSymbol = {};
let formater = new Intl.NumberFormat('en-IN', { maximumSignificantDigits: 3 });

function writeArrayJson2Xlsx(filename, ...args) {
  let workbook = xlsx.utils.book_new();
  args.forEach(s => {
    let worksheet = xlsx.utils.json_to_sheet(s);
    xlsx.utils.book_append_sheet(workbook, worksheet);
  })
  xlsx.writeFile(workbook, filename);
}

function writeArrayJson2XlsxNew(filename, ...args) {
  let workbook = xlsx.utils.book_new();
  args.forEach(s => {
    let worksheet = xlsx.utils.json_to_sheet(s.data);
    if (s.name)
      xlsx.utils.book_append_sheet(workbook, worksheet, s.name);
    else
      xlsx.utils.book_append_sheet(workbook, worksheet);
  })
  xlsx.writeFile(workbook, filename);
}


(async () => {
  let ssiSymbol = Object.keys(map)
  let ssiCop = ssiSymbol.map(e => { return { stock_code: e } });
  console.table(ssiSymbol.length)
  console.table(ssiCop.length)




  let cop = ssiCop

  let csv = new Parser({ fields: ["code", "trading_date", "close_value", "foreign_buy_matched", "foreign_sell_matched", "foreign_buy", "foreign_sell", "proprietary_buy_matched", "proprietary_sell_matched", "proprietary_buy", "proprietary_sell", "local_individual_buy_matched", "local_individual_sell_matched", "local_individual_buy", "local_individual_sell", "local_institutional_buy_matched", "local_institutional_sell_matched", "local_institutional_buy", "local_institutional_sell", "foreign_individual_buy_matched", "foreign_individual_sell_matched", "foreign_individual_buy", "foreign_individual_sell", "foreign_institutional_buy_matched", "foreign_institutional_sell_matched", "foreign_institutional_buy", "foreign_institutional_sell"] });
  let watchlist = ['HPG']

  let total_check = 0;


  try {

    let t1 = Date.now();
    let dir = "./investor";

    let fun = investor;


    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, { recursive: true });
    }
    let investorData = []
    if (!fs.existsSync(dir + "/investorData" + getNow() + ".json")) {
      let maxSize = 100;
      let stat = { req: 0, res: 0, record: 0 }
      total_check = cop.length;
      cop = cop.filter(e => e.stock_code.length < 4)
      // cop = [ {stock_code:"HPG"}]
      cop.push({ stock_code: "10" }) //vnindex
      cop.push({ stock_code: "11" }) //vn30-index
      console.log("Fetching", cop.length)
      for (let x of cop) {
        logger.trace(x.Code);
        while (stat.req - stat.res >= maxSize) {
          await wait(200);
        }
        stat.req++;
        let z = fun(x.stock_code);
        z.then((ret) => {

          if (logger.isTraceEnabled)
            logger.trace(ret.data.length);

          // if (localRes == total_check) {
          //   logger.info("Done " + getNow() + " " + (Date.now() - t1) / 1000 + " ms");
          // }
          if (ret.data.length == 0) {
            stat.res++;
            if (stat.res % 10 == 0) {
              console.log(stat)
            }
            return;
          }

          stat.record += ret.data.length;

          if (watchlist.includes(ret.Code)) {
            // logger.info("\n",ret.Code,"\n",data2.substr(0,data2.indexOf("\n",200)));
          }

          investorData.push(...ret.data)
          stat.res++;
          if (stat.res % 10 == 0) {
            console.log(stat)
          }

        })

      }

      while (stat.res < stat.req) {
        await wait(2000);
      }
      console.log(stat)

      fs.writeFileSync(dir + "/investorData" + getNow() + ".json", JSON.stringify(investorData))
    } else {
      let buff = fs.readFileSync(dir + "/investorData" + getNow() + ".json", "utf-8")
      investorData = JSON.parse(buff)
    }

    if (parentPort) {
      parentPort.postMessage(investorData)
    }
    let data2 = csv.parse(investorData);

    investorData = investorData.map(e => {

      let total_buy = 0;
      let total_sell = 0;
      let total_sell_matched = 0;
      let total_buy_matched = 0;
      Object.keys(e).forEach(k => {
        if (k.includes('matched')) {
          if (k.includes('buy')) { total_buy_matched += e[k] } else { total_sell_matched += e[k] }
        } else {
          if (k.includes('buy') || k.includes('sell'))
            if (k.includes('buy')) { total_buy += e[k] } else { total_sell += e[k] }
        }

      })
      let local_individual_buy
      let ne = {
        date: new Date(e.trading_date * 1000 + 7 * 60 * 60 * 1000),
        code: e.code,
        total_buy: total_buy,
        total_sell: total_sell,
        total_buy_matched: total_buy_matched,
        total_sell_matched: total_sell_matched,
        total_sell_remain: (total_sell - total_sell_matched),
        total_buy_remain: (total_buy - total_buy_matched),
        ratio_local_individual_buy: (e.local_individual_buy / total_buy * 100),
        ratio_local_individual_sell: (e.local_individual_sell / total_sell * 100),
        ratio_local_individual_buy_matched: (e.local_individual_buy_matched / total_buy_matched * 100),
        ratio_local_individual_sell_matched: (e.local_individual_sell_matched / total_sell_matched * 100),
        ...e
      }
      return ne;
    })
    let investorDataDays = {}
    investorData.forEach(e => {
      if (!investorDataDays[e.code]) investorDataDays[e.code] = []
      investorDataDays[e.code].push(e)
    })

    let s = Object.keys(investorDataDays);
    s.forEach(e => {
      investorDataDays[e].sort((a, b) => { return b.trading_date - a.trading_date })
    })

    // console.table(investorDataDays['HPG'])

    let days = [1, 3, 5, 7, 30, 100]
    let investorDataDaySlide = {}
    s.forEach(e => {
      days.forEach(d => {
        if (!investorDataDaySlide[e]) investorDataDaySlide[e] = {}
        investorDataDaySlide[e][d] = investorDataDays[e].slice(0, d)
      })
    })

    let t = {
      total_buy_matched: 0,
      total_sell_matched: 0,
      foreign_buy_matched: 0,
      foreign_sell_matched: 0,
      proprietary_buy_matched: 0,
      proprietary_sell_matched: 0,
      local_individual_buy_matched: 0,
      local_individual_sell_matched: 0,
      local_institutional_buy_matched: 0,
      local_institutional_sell_matched: 0,
      foreign_individual_buy_matched: 0,
      foreign_individual_sell_matched: 0,
      foreign_institutional_buy_matched: 0,
      foreign_institutional_sell_matched: 0,
    }
    let tt2 = {
      total: 0,
      foreign: 0,
      proprietary: 0,
      local_individual: 0,
      local_institutional: 0,
      foreign_individual: 0,
      foreign_institutional: 0,
    }

    let sum = {}
    s.forEach(e => {
      if (!sum[e]) sum[e] = {}
      days.forEach(d => {
        sum[e][d] = investorDataDaySlide[e][d].reduce((a, b) => {
          let ret = {}
          Object.keys(t).forEach(p => {
            ret[p] = a[p] + b[p]
          })
          return ret;
        }, { ...t })
        let delta = {}
        Object.keys(tt2).forEach(p => {
          delta[p + "_delta"] = sum[e][d][p + "_buy_matched"] - sum[e][d][p + "_sell_matched"]
        })
        sum[e][d] = { ...delta, ...sum[e][d] }
      })

    })

    console.table(sum['SSI'][1])
    let sheet = {}
    days.forEach(d => {
      if (!sheet[d]) sheet[d] = []
      s.forEach(e => {
        sheet[d].push({ code: e, trading_date: investorDataDaySlide[e][d][0].trading_date, date: investorDataDaySlide[e][d][0].date, ...sum[e][d] })
      })
    })

    fs.appendFileSync(dir + "/" + getNow() + "_investor.csv", data2 + "\n");
    writeArrayJson2XlsxNew(dir + "/" + getNow() + "_investor.xlsx", { data: investorData }, ...Object.keys(sheet).map(e => { return { data: sheet[e], name: e } }));

  } catch (error) {
    logger.error(error);
  } finally {
    await wait(1000);
  }
})();


function getNow() {
  let fd = new Date();
  return fd.getFullYear()
    + "" + (fd.getMonth() + 1 < 10 ? "0" + (fd.getMonth() + 1) : fd.getMonth() + 1)
    + "" + (fd.getDate() < 10 ? "0" + fd.getDate() : fd.getDate());
}

function wait(ms) {
  return new Promise(resolve => {
    setTimeout(() => {
      resolve(0);
    }, ms);
  });
}

