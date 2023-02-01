import { Exchange } from "./Exchange.js";
import fetch from "node-fetch";
import request from 'request'
import puppeteer from "puppeteer";
import http from "node:http";
import https from "node:https";
import { Console } from 'node:console'
import { Transform } from 'node:stream'
import fs from "fs";


(async () => {

    let a = await fetch("https://histdatafeed.vps.com.vn/tradingview/history?symbol=HPG&resolution=5&from=1672526870&to=1675214330", {
        "headers": {
            "accept": "*/*",
            "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
            "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
            "sec-ch-ua-mobile": "?0",
            "sec-fetch-dest": "empty",
            "sec-fetch-mode": "cors",
            "sec-fetch-site": "same-site"
        },
        "referrer": "https://chart.vps.com.vn/",
        "referrerPolicy": "strict-origin-when-cross-origin",
        "body": null,
        "method": "GET",
        "mode": "cors"
    });


    let z = await a.json()

    let z1 = z.o.map((e, i) => { return { c: z.c[i], h: z.h[i], l: z.l[i], o: z.o[i], t: z.t[i], v: z.v[i] } })

    let z2 = z1.reduce((a, b) => { return { v: (a.v + b.v) } }, { v: 0 })

    let av = z2.v / z1.length
    let z3 = z1.map(e => { e['av'] = av; e['r'] = e.v / av; e.date = (new Date(e.t * 1000)).toISOString(); return e })

    const ts = new Transform({ transform(chunk, enc, cb) { cb(null, chunk) } })
    const logger = new Console({ stdout: ts })
    
    function getTable (data) {
      logger.table(data)
      return (ts.read() || '').toString()
    }
    
    const str = getTable(z3)
    console.log(str.length) // 105
    console.log(str)    
    fs.appendFile("hpg_5p_table.txt",str,(e)=>{})

})();