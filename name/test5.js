import { Exchange } from "./Exchange.js";
import fetch from "node-fetch";
import request from 'request'
import puppeteer from "puppeteer";
import http from "node:http";
import https from "node:https";
import { Console } from 'node:console'
import { Transform } from 'node:stream'
import fs from "fs";
import xlsx from "xlsx"

(async () => {
    let p = '1.2'
    console.log(+p,p)

    let Headers = ['ChangeId', 'ChangeDescription', 'ChangeDate', 'Enhancement/Fix', 'ExcutorTeam'];
    let Data = ['INC1234', 'Multiple Cert cleanup', '04/07/2022', 'Enhancement', 'IlevelSupport'];
    
    let workbook = xlsx.utils.book_new();

    
    // xlsx.utils.sheet_add_aoa(worksheet, [Headers], { origin: 'A1' });
    // xlsx.utils.sheet_add_aoa(worksheet, [Data], { origin: 'A2' });


   let a = await Exchange.vndGetAllSymbols();
   console.log(a)
    
    
   let worksheet = xlsx.utils.json_to_sheet(a);
    
   xlsx.utils.book_append_sheet(workbook, worksheet);
    xlsx.writeFile(workbook, "Test.xlsx");
    console.log("written")


  let code="VNINDEX";
    
  let start = 1421028900;
  let end = Math.floor(Date.now() / 1000);
  let out = { t: [], v: [], o: [], c: [], h: [], l: [] };
  while (true) {
    let a = await fetch("https://chartdata1.mbs.com.vn/pbRltCharts/chart/v2/history?symbol=" + code + "&resolution="+"1"+"&from=" + start + "&to=" + end, {
      "headers": {
        "accept": "*/*",
        "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
        "content-type": "text/plain",
        "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
        "sec-ch-ua-mobile": "?0",
        "sec-fetch-dest": "empty",
        "sec-fetch-mode": "cors",
        "sec-fetch-site": "same-site"
      },
      "referrer": "https://sweb.mbs.com.vn/",
      "referrerPolicy": "strict-origin-when-cross-origin",
      "body": null,
      "method": "GET",
      "mode": "cors",
      agent
    });
    let z = await a.json();
    if (z.t.length == 0) {
      break;
    } else if (z.t.at(-1) == start) {
      out.t.push(...z.t);
      out.v.push(...z.v);
      out.o.push(...z.o);
      out.c.push(...z.c);
      out.h.push(...z.h);
      out.l.push(...z.l);
      break;
    } else {
      out.t.push(...z.t);
      out.v.push(...z.v);
      out.o.push(...z.o);
      out.c.push(...z.c);
      out.h.push(...z.h);
      out.l.push(...z.l);
      start = z.t.at(-1);
    }
  }

})();