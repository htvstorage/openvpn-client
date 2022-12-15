import fetch from "node-fetch";
import fs from "fs";
import log4js from "log4js";
import { Parser } from "json2csv"
import { SMA, EMA, RSI, StochasticRSI, MACD, MFI, BollingerBands } from 'technicalindicators';
import IchimokuCloud from 'technicalindicators'
import path from "path";
import { Symbol, Stock } from "./StockData.js";
import { Exchange } from "./Exchange.js";


var logger = log4js.getLogger();

log4js.configure({
  appenders: {
    everything: { type: "file", filename: "stock.log" },
    console: { type: "console" },
  },
  categories: {
    default: { appenders: ["everything", "console"], level: "INFO" },
  },
});


(async () => {

  let company = [];
  let counter = 0;
  company = await Exchange.getlistallstock();
  let symbols = new Set();

  company.forEach((e) => {
    if (e.stock_code.length <= 3) {
      symbols.add(e.stock_code + "_" + e.post_to + "_trans.txt");
    }
  })

  let dir = "./his/";
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir);
  }
  let files = fs.readdirSync(dir);
  
  for (const file of files) {
    if (symbols.has(file)) {      
      loadData(path.join(dir, file).toString());
    }
  }

  gap.sort((a, b) => {
    if (a.ratio < b.ratio) return -1;
    if (a.ratio > b.ratio) return 1;
    return 0;
  });


  for (let e of gap) {
    logger.info(e);
  }

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
  
  if (logger.isDebugEnabled)
    logger.debug(data);

  var prices = data.map(e => +e.priceClose / +e.adjRatio);
  var high = data.map(e => +e.priceHigh / +e.adjRatio);
  var low = data.map(e => +e.priceBasic / +e.adjRatio);
  var basic = data.map(e => +e.priceLow / +e.adjRatio);
  var vol = data.map(e => +e.dealVolume);
    
  var sym = new Symbol("symbol", high, low, prices, vol);

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
  let shortPeriods = [5, 8, 20, 50];
  let longPeriods = [5, 8, 20, 50];


  let smaRet = shortPeriods.map(e => { return SMA.calculate({ period: e, values: prices }); });
  let smaVolRet = shortPeriods.map(e => { return SMA.calculate({ period: e, values: vol }); });
  let emaRet = shortPeriods.map(e => { return EMA.calculate({ period: e, values: prices }); });


  if (smaVolRet[0][-1] > 100000) {
    if ((prices[-1] >= smaRet[0][- 1])) {
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
    
    if ((prices[- 1] >= smaRet[1][- 1]) && (smaRet[1][- 1] > smaRet[2][- 1])) {
      logger.info("Price over SMA9", symbol, "prices ", prices[- 1], " sma ", smaRet[1][- 1])
      // let delta =  prices[prices.length - 1] - smaRet[2][smaRet[2].length - 1];
      // gap.push({
      //   ratio: (delta / smaRet[2][smaRet[2].length - 1]), "symbol": symbol, "path": path,
      //   "price": prices[prices.length - 1],
      //   "ma25": smaRet[2][smaRet[2].length - 1],
      //   "vol": smaVolRet[0][smaVolRet[0].length - 1]
      // });      
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


    var inputRSI = {
      values: prices,
      period: 14
    };
    var rsi = RSI.calculate(inputRSI);

    // console.log(rsi[rsi.length-1]);
    var p1 = path.indexOf("/", 0) + 1;
    var p2 = path.indexOf("_", 0);
    var symbol = path.substr(p1, p2 - p1);
    console.log(symbol)
    if (rsi[rsi.length - 1] <= 40 && symbol.length == 3) {
      let delta = prices[prices.length - 1] - smaRet[2][smaRet[2].length - 1];
      gap.push({
        ratio: (delta / smaRet[2][smaRet[2].length - 1]), "symbol": symbol, "path": path,
        "price": prices[prices.length - 1],
        "ma25": smaRet[2][smaRet[2].length - 1],
        "vol": smaVolRet[0][smaVolRet[0].length - 1],
        "rsi ": rsi[rsi.length - 1]
      });
    }

  }
}

