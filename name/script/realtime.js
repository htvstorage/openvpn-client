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
import stats from "stats-analysis";
import { Console } from "console";

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
  let vndjson = fs.readFileSync("vnd_ratio.json", 'utf-8');
  let vnddata = JSON.parse(vndjson)
  Object.keys(vnddata).forEach(k => {
    let js = JSON.parse(vnddata[k])
    let m = {}
    js.data.forEach(e => { m[e.ratioCode] = e.value })
    vnddata[k] = m
  })


  let ssiDataFile = "./ssi_basic.json"
  let ssijson = fs.readFileSync(ssiDataFile, 'utf-8');
  let data = JSON.parse(ssijson)
  Object.keys(data).forEach(k => {
    let js = JSON.parse(data[k])
    data[k] = js.data
  })

  let hoseData = Object.values(data).filter(e => e.exchange == "hose" && e.stockSymbol.length == 3).map(e => {
    let ff = vnddata[e.stockSymbol].FREEFLOAT*100;
    if (ff <= 1) { ff = 1 } else {
      ff = ff <= 15? Math.ceil(ff):Math.ceil(ff / 5) * 5
    }

    return {
      "stockSymbol": e.stockSymbol, "listedShare": e.listedShare,
      "sharesOutstanding": e.sharesOutstanding, "priorClosePrice": e.priorClosePrice,
      "freefloat": ff/100,
      "lastMatchedPrice": e.lastMatchedPrice,
      c:1
    }
  }
  );
  console.table(hoseData)
  // console.table(data["YBM"])
  let model = {}
  hoseData.forEach(e => {
    model[e.stockSymbol] = e
  })

  console.log("FFF", Math.ceil((15.2) / 5) * 5)

  // console.table(vnddata['HPG'])



  let vnindex = (model) => {
    let vh = Object.values(model).reduce((a, b) => {
      let vh = 0; let price = 0;
      if (b.lastMatchedPrice == undefined) { price = b.priorClosePrice } else {
        price = b.lastMatchedPrice
      }
      vh = b.sharesOutstanding * price * Math.abs(b.freefloat);
      return a + vh;
    }, 0)
    return vh;
  }

  let VH = vnindex(model);
  Object.values(model).forEach(e => {
    let vh = 0; let price = 0;
    if (e.lastMatchedPrice == undefined) { price = e.priorClosePrice } else {
      price = e.lastMatchedPrice
    }
    vh = e.sharesOutstanding * price * Math.abs(e.freefloat);
    e.vh = vh;
    e.ratio = vh / VH
  })

  let O = Object.values(model).filter(e => e.ratio >= 0.1)
  let J = Object.values(model).filter(e => e.ratio < 0.1)
  let zigma = J.reduce((a,b)=>{return a + b.vh},0)
  console.table(O)
  let OP  = O.reduce((a,b)=>{return a + b.ratio},0)

  let I = 100 - OP*100
  console.log(OP,I, zigma)

  O.forEach(e=>{
    e.c = 10*zigma/(I*e.vh)
  })
  console.table(O)

  let vnindex2 = (model) => {
    let vh = Object.values(model).reduce((a, b) => {
      let vh = 0; let price = 0;
      if (b.lastMatchedPrice == undefined) { price = b.priorClosePrice } else {
        price = b.lastMatchedPrice
      }
      vh = b.sharesOutstanding * price * Math.abs(b.freefloat)*b.c;
      return a + vh;
    }, 0)
    return vh;
  }

  let ratio = vnindex2(model) / 1055.45;
  // let VHM = 41.80*1000
  // let VIC = 41.60*1000
  // let VRE = 24.60*1000
  // let x= {VHM:VHM,VIC:VIC,VRE:VRE}
  // let chia = [2,3,4]
  // console.log("Neu ho nha VINGROUP")
  // chia.forEach(e=>{
  //   Object.keys(x).forEach(k=>{
  //     model[k].lastMatchedPrice = x[k]/e
  //   })
  //   console.log("Chia ",e, " index ", vnindex2(model)/ratio)
  // })
  // console.log(vnindex(model) / 1105.90)


  let databuf = fs.readFileSync("websocket/data20231026.txt", "utf-8")
  let dataex = databuf.split("\n");
  // dataex = dataex.reverse();
  let change = []
  let index = []
  let lastIndex = vnindex2(model) / ratio
  dataex.forEach(e => {
    // console.log(e)
    if (e.startsWith("L#")) {
      let tk = e.split("|");
      let s = tk[0].slice(2)
      if (model[s]) {
        if (model[s].lastMatchedPrice != +tk[1]) {
          model[s].lastMatchedPrice = +tk[1]
          let idx = vnindex2(model) / ratio
          let delta = lastIndex - idx;
   
          index.push(idx)
          change.push(Math.abs(delta))
          // if(Math.abs(delta)> 10*0.01531373350857321)
            // console.log(s,tk[1], Math.floor(delta*100)/100,Math.floor(lastIndex*100)/100, vnindex2(model) /ratio, e)
          lastIndex = idx;
          
        }
      }
    }
  })



  
  let mean = stats.mean(index)
  let std = stats.stdev(index)
  let meanC = stats.mean(change)
  let stdC = stats.stdev(change)
  stats.m
  console.log("mean", mean, "std", std)
  console.log("meanC", meanC, "stdC", stdC, "max", Math.max(...change), "min", Math.min(...change))
  console.log("meanC", meanC, "stdC", stdC, "max", Math.max(...index), "min", Math.min(...index))
  // avg["O" + me + e] = Math.floor((Math.abs(mean - m[me][i].at(-1 - checkDate)) - threshold * std) * 100) / 100;
  // avg["ORR" + me + e] = Math.floor((Math.abs(mean - m[me][i].at(-1 - checkDate)) / std) * 100) / 100;
  // avg["R" + me + e] = Math.floor((m[me][i].at(-1 - checkDate) / mean) * 100) / 100;

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
