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
    everything: { type: "file", filename: "beta.log" },
    console: { type: "console" },
  },
  categories: {
    default: { appenders: ["everything", "console"], level: "INFO" },
  },
});


(async () => {

  let company = [];
  let counter = 0;
  let a = await Exchange.stocks();
  let x = await a.json();

  let listed = x.data.filter(e => { if (e.status == "listed") { return true } else return false; })

  let req = 0;
  let res = 0;
  for (let e of listed) {
    if (e.code.length >= 4) {
      continue;
    }
    try {
      let r =  Exchange.ratios(e.code);
      req++;
      r.then(res => res.json()).then(data => {
        try {
          logger.info(data.data[0]['value'], e.code)
        } catch (error) {
          logger.error(data, e.code)
        }        
        res++;
      })
      
      while (req - res >= 10) {
        await wait(100);
      }
      // let x = await r.json();
      // logger.info(x.data[0]['value'], e.code)
    } catch (err) {
      console.log(err)
    }
  }
})();


function wait(ms) {
  return new Promise(resolve => {
    setTimeout(() => {
      resolve(0);
    }, ms);
  });
}