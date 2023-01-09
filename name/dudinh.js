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
      let maxPrint = 15;
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
        if (c > maxPrint) {
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
        if (c > maxPrint) {
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
      for (let i = 0; i < maxPrint; i++) {
        console.log(i%2==0? colours.fg.blue:colours.fg.magenta,JSON.stringify(x[i]))
      }
      console.log("======================VOL=======================")
      x.sort((a, b) => {
        return a.lot > b.lot ? -1 : a.lot < b.lot ? 1 : 0
      })  
      for (let i = 0; i < maxPrint; i++) {
        console.log(i%2==0? colours.fg.blue:colours.fg.magenta,JSON.stringify(x[i]))
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


const colours = {
  reset: "\x1b[0m",
  bright: "\x1b[1m",
  dim: "\x1b[2m",
  underscore: "\x1b[4m",
  blink: "\x1b[5m",
  reverse: "\x1b[7m",
  hidden: "\x1b[8m",
  
  fg: {
      black: "\x1b[30m",
      red: "\x1b[31m",
      green: "\x1b[32m",
      yellow: "\x1b[33m",
      blue: "\x1b[34m",
      magenta: "\x1b[35m",
      cyan: "\x1b[36m",
      white: "\x1b[37m",
      gray: "\x1b[90m",
      crimson: "\x1b[38m" // Scarlet
  },
  bg: {
      black: "\x1b[40m",
      red: "\x1b[41m",
      green: "\x1b[42m",
      yellow: "\x1b[43m",
      blue: "\x1b[44m",
      magenta: "\x1b[45m",
      cyan: "\x1b[46m",
      white: "\x1b[47m",
      gray: "\x1b[100m",
      crimson: "\x1b[48m"
  }
};