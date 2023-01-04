import fetch from "node-fetch";
import fs from "fs";
import log4js from "log4js";
import { Parser } from "json2csv"
import { Exchange } from "./Exchange.js";
var logger = log4js.getLogger();

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
  let cop = [];

  let requested = 0;
  let responsed = 0;
  let csv = new Parser({ fields: ['price', 'change', 'match_qtty', 'side', 'time', 'total_vol'] });
  cop = await Exchange.getlistallstock();

  let listSymbol = await Exchange.getlistallsymbol();
  listSymbol = listSymbol.filter((s) => {
    return s.length <= 3;
  })




  console.log(listSymbol.length)
  let top = []
  let topG1 = []
  while (true) {
    top.length = 0;
    topG1.length = 0;
    let z = Exchange.getliststockdata(listSymbol, stockdata);
    z.then(data => {
      console.log(data['HPG'])

      for (let key of Object.keys(data)) {
        let s = data[key];
        let g1 = s.g1;
        let a = g1.split("|");

        if (s.c == +a[0]) {
          // console.log(a,s)
          top.push({ symbol: key, p: +a[0], v: +a[1] * 10, total: s.lot * 10 });
        }
        topG1.push({ symbol: key, p: +a[0], v: +a[1] * 10, total: s.lot * 10 });
      }

      console.log("================================================")
      console.log("===================Du Dinh======================")
      top.sort((a, b) => {
        return a.v > b.v ? -1 : a.v < b.v ? 1 : 0
      })

      for (let i = 0; i < 10; i++) {
        console.log(top[i])
      }
      topG1.sort((a, b) => {
        return a.v > b.v ? -1 : a.v < b.v ? 1 : 0
      })
      console.log("================================================")
      for (let i = 0; i < 10; i++) {
        console.log(topG1[i])
      }
    })
    try {


    } catch (error) {
      logger.error(error);
    } finally {
      await wait(10000);
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

