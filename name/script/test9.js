// import { Exchange } from "./Exchange.js";
// import {loadMbs } from "./filter200x.js"
// import moment from "moment"
import WebSocket from 'ws';
import fs from 'fs'
import moment from 'moment'
import xlsx from "xlsx"
(async ()=>{
    //     Exchange.SSI.getlistallsymbol()
    // Exchange.SSI.getlistallsymbol3()
    // loadMbs();

// let a=    moment(1697080500*1000 + 7*60*60*1000)
// console.log(a)
// console.log(new Date(1697080500*1000 + 7*60*60*1000))
// const duration = moment.duration(1697080500*1000 + 7*60*60*1000);
// const hours = duration.hours();
// const minutes = duration.minutes();
// const seconds = duration.seconds();

// console.log(`Số giờ: ${hours}, Số phút: ${minutes}, Số giây: ${seconds}`);
})();


// import regression from 'regression';

// // Dữ liệu x và y
// const x = [
//   300, 600, 900, 1200, 1500, 1800, 2100, 2400, 2700, 3000,
//   3300, 3600, 3900, 4200, 4500, 4800, 5100, 5400, 5700, 6000,
//   6300, 6600, 6900, 7200, 7500, 7800, 8100, 8400, 8700, 9000,
//   9000, 9300, 9600, 9900, 10200, 10500, 10800, 11100, 11400, 11700,
//   12000, 12300, 12600, 12900, 13200, 13500, 13800, 14100, 14400, 14700,
//   15000, 15300, 15300
// ];

// const y = [
//   5867500, 9230000, 216544750, 363979500, 510511000, 656559500, 803058750, 919756000, 1032575250, 1135936750,
//   1252126435, 1350821935, 1460414710, 1583881210, 1689323710, 1813519710, 1926450710, 2034963710, 2147754210, 2240658210,
//   2319213210, 2402455910, 2514998160, 2589155410, 2653521660, 2722299160, 2791463410, 2861327160, 2938512660, 2944885160,
//   3083067910, 3179340160, 3285564160, 3369788410, 3473290345, 3559513595, 3666177595, 4009984845, 4123758745, 4297947495,
//   4526643495, 4711878495, 4836812745, 4960062995, 5104633745, 5270466245, 5494384495, 5746595495, 5775977220, 5778549720,
//   5787324720, 6132891510, 6152750260
// ];

// // Sử dụng thư viện regression để tính hồi quy tuyến tính
// const result = regression.linear(x.map((val, index) => [val, y[index]]));

// // Lấy hệ số a và b từ kết quả hồi quy
// const a = result.equation[0];
// const b = result.equation[1];

// console.log(`Hệ số a: ${a}`);
// console.log(`Hệ số b: ${b}`);


// let stockNo="hose:1354"

// let a = await fetch("https://wgateway-iboard.ssi.com.vn/graphql", { 
//         "headers": {
//           "accept": "*/*",
//           "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
//           "content-type": "application/json",
//           "g-captcha": "",
//           "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
//           "sec-ch-ua-mobile": "?0",
//           "sec-fetch-dest": "empty",
//           "sec-fetch-mode": "cors",
//           "sec-fetch-site": "same-site"
//         },
//         "referrer": "https://iboard.ssi.com.vn/",
//         "referrerPolicy": "strict-origin-when-cross-origin",
//         "body": "{\"operationName\":\"leTables\",\"variables\":{\"stockNo\":\"" + stockNo + "\"},\"query\":\"query leTables($stockNo: String) {\\n  leTables(stockNo: $stockNo) {\\n    stockNo\\n    price\\n    vol\\n    accumulatedVol\\n    time\\n    ref\\n    side\\n    priceChange\\n    priceChangePercent\\n    changeType\\n    __typename\\n  }\\n  stockRealtime(stockNo: $stockNo) {\\n    stockNo\\n    ceiling\\n    floor\\n    refPrice\\n    stockSymbol\\n    __typename\\n  }\\n}\\n\"}",
//         "method": "POST",
//         "mode": "cors",        
//       });

// let z = await a.text()

// console.log(z)


let a= {...{us:0,vol:0,val:0},...{vol:1,val:1}}
console.log(a)

let buf= fs.readFileSync("priceModel.json","utf-8")
let data = JSON.parse(buf);
data = data.filter(e=>e!=null)
function writeArrayJson2XlsxNew(filename, ...args) {
    let workbook = xlsx.utils.book_new();
    args.forEach(s => {
      let worksheet = xlsx.utils.json_to_sheet(s.data);
      if (s.name)
        xlsx.utils.book_append_sheet(workbook, worksheet, s.name);
      else
        xlsx.utils.book_append_sheet(workbook, worksheet);
    })
    xlsx.writeFile(workbook, filename);
  }

  let p = ["bid_vol",	"bid_val",	"ask_vol",	"ask_val"]
  let out = data.reduce((acu,item)=>{
    if(!acu[item.date]) acu[item.date] = {...item,c:1};
    else{
 
      p.forEach(e=>{
        acu[item.date][e] += item[e]
      })
      acu[item.date].c++;
      acu[item.date].VNINDEX = item.VNINDEX
    }
    return acu;      
  },{})

  let values = Object.values(out).sort((a,b)=>  a.time-b.time);
  values.map(e=>{
    p.forEach(ep=>{
      e[ep] = e[ep]/e.c
    })
  })
writeArrayJson2XlsxNew("priceModel.xlsx",{"data":data})
writeArrayJson2XlsxNew("priceModel2.xlsx",{"data":values})