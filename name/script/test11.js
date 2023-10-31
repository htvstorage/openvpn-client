["vol","val"].forEach(e=>{console.log(e)})

import fs from "fs"
import { SMA, EMA, RSI, StochasticRSI, MACD, MFI, BollingerBands } from 'technicalindicators';

let list =fs.readdirSync("./his")
let vni=list.filter(e=>e.includes("VNINDEX"))[0]
console.log(vni)

let vniData=fs.readFileSync("./his/"+vni,"utf-8")
let vniDataArray=vniData.split("\n").filter(e=>e.length>0).map(e=>e.split(","))
console.table(vniDataArray[0])
let priceclose= vniDataArray.map(e=>e[10])
console.table(priceclose.slice(0,10))
// var inputRSI = {
//     values: prices,
//     period: 14
//   };


//   var rsi = RSI.calculate(inputRSI);
//   avg.rsi = rsi.at(checkDate)