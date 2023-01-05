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
  let listSymbol = await Exchange.getlistallsymbol();
  listSymbol = listSymbol.filter((s) => {
    return s.length <= 3;
  })
  console.log(listSymbol.length)
  let top = []
  let topG1 = []
  let delta = {};
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
          top.push({ symbol: key, p: +a[0], v: +a[1] * 10, total: s.lot * 10, c: s.c, f: s.f, r: s.r, '%': ((s.lastPrice - s.r) * 100 / s.r).toFixed(2) });
        }
        topG1.push({ symbol: key, p: +a[0], v: +a[1] * 10, total: s.lot * 10, c: s.c, f: s.f, r: s.r, '%': ((s.lastPrice - s.r) * 100 / s.r).toFixed(2) });
        let e = delta[key];
        if (e == undefined || e == null)
          delta[key] = { symbol: key, p: +a[0], v: +a[1] * 10, total: s.lot * 10, delta: 0, tps: 0, time: Date.now(), c: s.c, f: s.f, r: s.r, '%': ((s.lastPrice - s.r) * 100 / s.r).toFixed(2) }
        else {
          let now = Date.now();
          let x = now - e.time;
          if (x >= 60 * 1000)
            delta[key] = {
              symbol: key, p: +a[0], v: +a[1] * 10, total: s.lot * 10, lot: s.lot * 10, delta: (s.lot * 10 - e.total),
              tps: (s.lot * 10 - e.total) * 1000 / (Date.now() - e.time),
              time: now
              , c: s.c, f: s.f, r: s.r, '%': ((s.lastPrice - s.r) * 100 / s.r).toFixed(2)
            }
          else {
            delta[key] = {
              symbol: key, p: +a[0], v: +a[1] * 10, total: e.total, lot: s.lot * 10, delta: (s.lot * 10 - e.total),
              tps: (s.lot * 10 - e.total) * 1000 / (Date.now() - e.time),
              time: e.time
              , c: s.c, f: s.f, r: s.r, '%': ((s.lastPrice - s.r) * 100 / s.r).toFixed(2)
            }
          }
        }
      }

      console.log("================================================")
      console.log("===================Du Dinh======================")
      top.sort((a, b) => {
        return a.v > b.v ? -1 : a.v < b.v ? 1 : 0
      })
      let c = 0;
      let idx = 0;
      while (true) {
        if (top[idx] == undefined)
          break;
        if (top[idx].total > 0) {
          c++;
          console.log(JSON.stringify(top[idx]))
        }
        idx++;
        if (c > 10) {
          break;
        }
      }

      topG1.sort((a, b) => {
        return a.v > b.v ? -1 : a.v < b.v ? 1 : 0
      })

      console.log("================================================")
      c = 0;
      idx = 0;
      while (true) {
        if (topG1[idx] == undefined)
          break;
        if (topG1[idx].total > 0) {
          c++;
          console.log(JSON.stringify(topG1[idx]))
        }
        idx++;
        if (c > 10) {
          break;
        }
      }
      let x = []
      for (let key of Object.keys(delta)) {
        x.push(delta[key]);
      }

      x.sort((a, b) => {
        return a.tps > b.tps ? -1 : a.tps < b.tps ? 1 : 0
      })
      console.log("================================================")
      console.log("======================TPS=======================")
      for (let i = 0; i < 10; i++) {
        console.log(JSON.stringify(x[i]))
      }
      console.log("======================VOL=======================")
      x.sort((a, b) => {
        return a.lot > b.lot ? -1 : a.lot < b.lot ? 1 : 0
      })  
      for (let i = 0; i < 10; i++) {
        console.log(JSON.stringify(x[i]))
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

