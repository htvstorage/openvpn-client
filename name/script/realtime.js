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
  let ssiDataFile = "./ssi_basic.json"
  let ssijson = fs.readFileSync(ssiDataFile, 'utf-8');
  let data = JSON.parse(ssijson)
  Object.keys(data).forEach(k => {
    let js = JSON.parse(data[k])
    data[k] = js.data
  })

  let hoseData = Object.values(data).filter(e => e.exchange == "hose").map(e => { return { "stockSymbol": e.stockSymbol, "listedShare": e.listedShare, "priorClosePrice": e.priorClosePrice, "lastMatchedPrice": e.lastMatchedPrice } });
  console.table(hoseData)
  console.table(data["YBM"])
  let model = {}
  hoseData.forEach(e => {
    model[e.stockSymbol] = e
  })

  let vhf = (model)=>{
    let vh = Object.values(model).reduce((a, b) => {
      let vh = 0; let price = 0;
      if (b.lastMatchedPrice == undefined) { price = b.priorClosePrice } else {
        price = b.lastMatchedPrice
      }
      vh = b.listedShare * price;
      return a + vh;
    }, 0)
    return vh;
  }
  
  let ratio = vhf(model) / 1105.90;
  console.log(vhf(model) / 1105.90)
  // model["VIC"].lastMatchedPrice=70000;
  // model["VCB"].lastMatchedPrice=100000;
  // model["VHM"].lastMatchedPrice=80000;
  // model["BID"].lastMatchedPrice=50000;
  // model["GAS"].lastMatchedPrice=90000;
  // model["CTG"].lastMatchedPrice=35000;
  // model["VPB"].lastMatchedPrice=25000;
  // model["HPG"].lastMatchedPrice=29000;
  // model["TCB"].lastMatchedPrice=35000;
  // model["FPT"].lastMatchedPrice=100000;
  // model["MSN"].lastMatchedPrice=100000;
  // console.log(vhf(model) /ratio)

  let databuf=fs.readFileSync("websocket/data20231024.txt","utf-8")
  let dataex=databuf.split("\n");
  dataex = dataex.reverse();
  dataex.forEach(e=>{
    // console.log(e)
    if(e.startsWith("L#")){
      let tk=e.split("|");
      let s = tk[0].slice(2)
      if(model[s]){
        model[s].lastMatchedPrice = +tk[1]
        console.log(s,tk[1], vhf(model) /ratio)
      }  
    }
  })
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
