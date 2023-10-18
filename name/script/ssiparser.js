import fetch from "node-fetch";
import fs from "fs";
import log4js from "log4js";
import { Parser } from "json2csv"
import path from "path";
import http from "node:http";
import https from "node:https";
import { Exchange } from "./Exchange.js";
var logger = log4js.getLogger();
const httpAgent = new http.Agent({ keepAlive: true });
const httpsAgent = new https.Agent({ keepAlive: true });
const agent = (_parsedURL) => _parsedURL.protocol == 'http:' ? httpAgent : httpsAgent;

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

// main
let stockdata = {};
let checkSymbol = {};
let formater = new Intl.NumberFormat('en-IN', { maximumSignificantDigits: 3 });



(async () => {
  let ssiSymbol = await Exchange.SSI.getlistallsymbol3();
  let ssiCop = ssiSymbol.filter(e => { return e.stockSymbol.length == 3 }).map(e => { return { stock_code: e.stockSymbol } });
  console.table(ssiSymbol.length)
  console.table(ssiCop.length)
  var args = process.argv.slice(2);
  
  let ssiDataFile = args[0]
  let ssijson=fs.readFileSync(ssiDataFile,'utf-8');
  let data = JSON.parse(ssijson)


  let csv = new Parser({ fields: ['Stockcode', 'Package', 'TradingDate', 'Price', 'Vol', 'TotalVol', 'TotalVal', 'Change', 'IsBuy', 'PerChange'] });
  let dir = "/workspace/newstorage/";

  let dir2 = "./trans";

  dir += "./ssitrans/" + getNow() + "/";
  csv = new Parser({ fields: ["stockNo", "price", "vol", "accumulatedVol", "time", "ref", "side", "priceChange", "priceChangePercent", "changeType", "__typename"] });
  dir2 = "./trans/" + getNow() + "/";
  [dir,dir2].forEach(d=>{
    if (!fs.existsSync(d)) {
      fs.mkdirSync(d, { recursive: true });
    } else {
      let files = fs.readdirSync(d);
      for (const file of files) {
        fs.unlinkSync(path.join(d, file));
      }
    }

  })


  let keys =  Object.keys(data);

  for(let k of keys){
    let sdata
    try {
      sdata= JSON.parse(data[k]);
    } catch (error) {
      console.log(error,"=========",k)
      continue;
    }
 
    // console.table(sdata)
    let ret = {Code:k,data:sdata.data.leTables,stockRealtime:sdata.data.stockRealtime}
    // console.table(ret)
    let data2 = csv.parse(ret.data);

    let newData = ret.data.map(e => {
      let ne = { price: e.price, change: e.priceChange, match_qtty: e.vol, side: e.side, time: e.time, total_vol: e.accumulatedVol };
      // console.log(ne)
      return ne;
    })
    fs.appendFileSync(dir + ret.Code + '_trans.txt', data2 + "\n", function (err) {
      if (err) throw err;
    });
    fs.appendFileSync(dir + ret.Code + '_stockRealtime.json', JSON.stringify(ret.stockRealtime) + "\n", function (err) {
      if (err) throw err;
    });
  
    let csv2 = new Parser({ fields: ['price', 'change', 'match_qtty', 'side', 'time', 'total_vol'] });
    let newData2 = csv2.parse(newData);
    fs.appendFileSync(dir2 + ret.Code + '_trans.txt', newData2 + "\n", function (err) {
      if (err) throw err;
    });
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
