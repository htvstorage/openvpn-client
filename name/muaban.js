import fetch from "node-fetch";
import fs from "fs";
import log4js from "log4js";
import { Parser } from "json2csv"
import { Exchange } from "./Exchange.js";
import draftlog from 'draftlog'
import Table from "tty-table";
import CliTable3 from "cli-table3";
import chalk from "chalk";
import path from "path";
var logger = log4js.getLogger();
import { Console } from 'node:console'
import { Transform } from 'node:stream'

const ts = new Transform({ transform(chunk, enc, cb) { cb(null, chunk) } })
const log = new Console({ stdout: ts })

function getTable(data) {
  log.table(data)
  return (ts.read() || '').toString()
}


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
            let a = {
              sd: 0,
              bu: 0,
              uk: 0
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
                  if (symbol == 'BID') {
                    console.log(e, first, last)
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

          table.slice(Math.max(table.length - 15, 0), table.length).forEach((e, i) => {
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



async function processData() {
  let dir = "./trans/";
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir);
  }
  // let __dirname = fs.realpathSync('.');

  let getAllFiles = (p, o) => {
    let files = fs.readdirSync(p);
    o = o || [];
    files.forEach((f) => {
      if (fs.statSync(p + "/" + f).isDirectory()) {
        getAllFiles(p + "/" + f, o);
      } else {
        o.push(path.join(p, "/", f));
      }
    })


  }
  // let files = fs.readdirSync(dir);
  let files = [];
  getAllFiles(dir, files);
  // console.log(files.at(-1))

  // files.forEach();


  processOne('./trans/20230202/HPG_trans.txt')


}

async function processOne(file) {

  let data = fs.readFile(file, readHandler)
  let strdate = file.substr(file.indexOf("trans/") + "trans/".length, 8)
  strdate = strdate.slice(0, 4) + "-" + strdate.slice(4, 6) + "-" + strdate.slice(6);
  function readHandler(err, buffer) {
    let data = buffer.toString("utf8")
      .split('\n')
      .map(e => e.trim())
      .map(e => e.split(',').map(e => e.trim()));
    let head = data[0];
    data = data.slice(1);
    data = data.map(e => {
      let x = {};
      for (let i = 0; i < head.length; i++) {
        if (e.length < head.length) {
          continue;
        }
        x[head[i].replaceAll("\"", "")] = e[i].replaceAll("\"", "");
        if (x.time != undefined) {
          x.datetime = (new Date(strdate + "T" + x.time)).getTime();
        }
      }
      return x;
    })
    data = data.reverse();
    data = data.slice(1);
    let newData = {};
    let interval = 1 * 60 * 1000;

    data.sort((a, b) => {
      let c = a.datetime - b.datetime;
      return c < 0 ? -1 : c > 0 ? 1 : 0
    })
    data.forEach((v, i) => {
      let k = Math.floor(v.datetime / interval) * interval;
      if (newData[k] == undefined) {
        newData[k] = {};
      }
      let e = newData[k];
      let p = +v.price;
      console.log(v)
      e.c = p;
      if (e.h == undefined) e.h = p
      if (e.l == undefined) e.l = p
      if (e.h < p) e.h = p;
      if (e.l > p) e.l = p;
      if (e.o == undefined) e.o = p;

      switch (v.side) {
        case 'bu':
          e.bu = (e.bu == undefined) ? +v.match_qtty : e.bu + +v.match_qtty;
          break;
        case 'sd':
          e.sd = (e.sd == undefined) ? +v.match_qtty : e.sd + +v.match_qtty;
          break;
        default:
          e.uk = (e.uk == undefined) ? +v.match_qtty : e.uk + +v.match_qtty;
      }
      e.total_vol = +v.total_vol;
      e.sum_vol = (e.sum_vol == undefined) ? +v.match_qtty : e.sum_vol + +v.match_qtty

    });


    let avg = Object.values(newData).reduce((a, b) => {
      return {
        uk: (a.uk == undefined ? 0 : a.uk) + (b.uk == undefined ? 0 : b.uk),
        bu: (a.bu == undefined ? 0 : a.bu) + (b.bu == undefined ? 0 : b.bu),
        sd: (a.sd == undefined ? 0 : a.sd) + (b.sd == undefined ? 0 : b.sd)
      }
    }, { uk: 0, bu: 0, sd: 0 })

    let length = Object.values(newData).length;
    console.log(avg)
    let x = Object.keys(newData).map(k => {
      let e = newData[k]; e.datetime = +k; e.date = (new Date(+k)).toISOString();
      let uk = (e.uk == undefined ? 0 : e.uk);
      let bu = (e.bu == undefined ? 0 : e.bu);
      let sd = (e.sd == undefined ? 0 : e.sd);
      let t = uk + bu + sd;
      e.pbu = Math.round(bu / t * 1000) / 10
      e.psd = Math.round(sd / t * 1000) / 10
      e.puk = Math.round(uk / t * 1000) / 10
      e.bs = Math.round(bu / sd * 10) / 10
      e.sb = Math.round(sd / bu * 10) / 10
      e.abu = Math.round(avg.bu / length * 10) / 10;
      e.asd = Math.round(avg.sd / length * 10) / 10;
      e.auk = Math.round(avg.uk / length * 10) / 10;
      if (e.uk != undefined) e.ruk = Math.round(e.uk / e.auk * 10) / 10;
      if (e.sd != undefined) e.rsd = Math.round(e.sd / e.asd * 10) / 10;
      if (e.bu != undefined) e.rbu = Math.round(e.bu / e.abu * 10) / 10;
      return e
    })

    x.sort((a, b) => {
      let c = a.datetime - b.datetime;
      return c < 0 ? -1 : c > 0 ? 1 : 0
    })
    let strtable = getTable(x);
    let as =strtable.split("\n");    
    let header =  as[2] + "\n" + as[1] + "\n" + as[2];
    let str = "";
    as.forEach((l,i)=>{
      str += l+"\n";
      if(i > 3 && (i-3) % 20 == 0){
        str += header+"\n";
      }
    })

    // console.log(str)
    console.log(as[1].charCodeAt(0),as[1][0])
    logger.log(str);
    console.table(x)
    if (logger.isDebugEnabled)
      logger.debug(data[0], data.at(-1));

  }


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