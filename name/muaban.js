import fetch from "node-fetch";
import fs from "fs";
import log4js from "log4js";
import { Parser } from "json2csv"
import { Exchange } from "./Exchange.js";
import draftlog from 'draftlog'
import Table from "tty-table";
import CliTable3 from "cli-table3";
import chalk from "chalk";
var logger = log4js.getLogger();


log4js.configure({
  appenders: {
    everything: {
      type: "file", filename: "muaban.log", layout: {
        type: "pattern",
        pattern: "%m%n",
      },
    },
    console: {
      type: "console", layout: {
        type: "pattern",
        pattern: "%m%n",
      },
    },
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

  let bs = {};
  
 {
  
 }
  let asyncBatch = async () => {    
    while (true) {
      let t = [2, 5, 10, 30, 60, 2 * 60, 3 * 60, 8 * 60]
      let from = t.map(e => {
        return Date.now() + 7 * 60 * 60 * 1000 - e * 60 * 1000
      })

      function date2str(date) {
        let t = date.getFullYear() + "-"
          + (date.getMonth() + 1 < 10 ? ("0" + (date.getMonth() + 1)) : date.getMonth() + 1) + "-"
          + (date.getDate() < 10 ? "0" + date.getDate() : date.getDate())
        return t;
      }
      let strdate = date2str(new Date());
      try {

        let stat = {
          req: 0,
          res: 0
        }
        let table = [];
        let promise = new Promise(async (resolve) => {
          let ret = {};
          for (let symbol of listSymbol) {
            stat.req++;
            if (stat.req - stat.res >= 200) {
              await wait(100);
            }
           let a= {
              sd:0,
              bu:0,
              uk:0
            }
            let z = Exchange.transaction(symbol, 2000000);
            z.then(data => {
              if (symbol == 'HPG') {
                // console.log(data)
              }
              stat.res++;
              ret[symbol] = data;
              if (data.data != undefined) {
                // {
                //   price: 10.75,
                //   change: 0.25,
                //   match_qtty: 5000,
                //   total_vol: 21338100,
                //   time: '14:29:14',
                //   side: 'sd'
                // }
                let f = [];
                from.forEach((v, i) => { f[i] = 0; })
                let first = [];
                let last = [];
                for (let p of data.data) {
                  let time = new Date(strdate + "T" + p.time);
                  from.forEach((v, i) => {
                    if (time >= v) {
                      if (f[i] == 0) {
                        first[i] = p;
                        f[i]++;
                      }
                      last[i] = p;
                    }
                  });
                }

                if (first.length > 0 && last.length > 0) {
                  let delta = first.map((v, i) => {
                    return ((v.change - last[i].change) * 100 / (v.price - v.change)).toFixed(2);
                  });
                  let change = first.map((v, i) => {
                    return ((v.change - last[i].change)).toFixed(2);
                  });

                  let e = {
                    symbol: symbol,
                    change: change,
                    'change%': (first.at(-1).change * 100 / (first.at(-1).price - first.at(-1).change)).toFixed(2),
                    price: first.at(-1).price,
                    vol: first.at(-1).total_vol,
                    deltaLast: delta.at(-1),
                    delta: delta,
                  };

                  t.forEach((v, i) => {
                    if (i >= 3) {
                      return;
                    }
                    e['delta' + t.at(i)] = delta.at(i) == undefined ? "" : delta.at(i);
                  });
                  if(symbol == 'BID'){
                    console.log(e,first,last)
                  }
                  table.push(e)
                }
              }

              if (stat.req == stat.res) {
                // console.log("Resolve", stat,table)
                resolve(table);
              }
            })
          }
        });


        promise.then(table => {
          // console.log("table", table[0])
          if (table == undefined || table.length == 0) {
            return;
          }
          var clitable = new CliTable3({ head: ['(Change1)', ...Object.keys(table[0])] })

          table = table.filter((e) => {
            return e.vol >= 150000;
          })
          table.sort((a, b) => {
            let x = a.delta.at(-1) - b.delta.at(-1);
            return x > 0 ? -1 : x < 0 ? 1 : 0;
          })
          let coloring = (e) => {
            let o = []
            let rt = e['%']
            let f = chalk.yellow;
            if (e.l == e.c) {
              f = chalk.magenta;
            } else if (e.l > e.r && e.l < e.c) {
              f = chalk.green;
            } else if (e.l == e.f) {
              f = chalk.blue;
            } else if (e.l < e.r && e.l > e.f) {
              f = chalk.red;
            }
            Object.keys(e).forEach((k, i) => {
              switch (k) {
                case '%':
                case 'tps':
                  o.push(f(e[k].toFixed(2)))
                  break;
                case 'time':
                  o.push(f(format(k, e[k])))
                  break;
                default:
                  o.push(f(e[k]));
              }
            });
            return o;
          }

          // console.log("table", table[0])
          table.slice(0, 15).forEach((e, i) => {
            clitable.push([i, ...coloring(e)]);
          })
          logger.info(clitable.toString())
          // let tb1 = clitable.toString();
          clitable = new CliTable3({ head: ['(Change2)', ...Object.keys(table[0])] })

          table.slice(Math.max(table.length - 15,0), table.length).forEach((e, i) => {
            clitable.push([i, ...coloring(e)]);
          })
          logger.info(clitable.toString())
          // let tb2 = clitable.toString();

          // let a1 = tb1.split("\n");
          // let a2 = tb2.split("\n");
          // let z = a1.map((v, i) => {
          //   return v + "   " + a2[i] + "\n"
          // })
          // let c = z.reduce((a, b) => a + b, "");
          // console.log(c)

        });

      } catch (err) {
        logger.error(err)
      } finally {
        await wait(20000);
      }
    }
  }

  // asyncBatch();
  processData();

})();



async function processData(){
  let dir = "./trans/";
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir);
  }
  let files = fs.readdirSync(dir);
  console.log(files)
}


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