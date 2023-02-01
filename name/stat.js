import { Exchange } from "./Exchange.js";
import fetch from "node-fetch";
import request from 'request'
import puppeteer from "puppeteer";
import http from "node:http";
import https from "node:https";
import { Console } from 'node:console'
import { Transform } from 'node:stream'
import fs from "fs";
import { Parser } from "json2csv"

(async () => {

    let dto = Date.now() / 1000
    let dfrom = new Date(Date.now - 30 * 24 * 60 * 60);
    let symbols = ['HPG', 'PLC', 'SHS', 'VIX', 'KSB']
    const ts = new Transform({ transform(chunk, enc, cb) { cb(null, chunk) } })
    const logger = new Console({ stdout: ts })

    function getTable(data) {
        logger.table(data)
        return (ts.read() || '').toString()
    }

    for (let symbol of symbols) {
        let a = await fetch("https://histdatafeed.vps.com.vn/tradingview/history?symbol=" + symbol + "&resolution=5&from=" + dfrom + "&to=" + dto, {
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
        let z3 = z1.map(e => { e['av'] = av; e['r'] = (e.v / av).toFixed(2); e.date = (new Date(e.t * 1000 + 7*60*60*1000)).toISOString(); return e })



        const str = getTable(z3)
        console.log(str.length) // 105
        console.log(str)
        fs.writeFile("./stat/" + symbol + "_report_5phut_table.txt", str, (e) => { })
        let csv = new Parser({ fields: Object.keys[z3[0]]});
        let data2 = csv.parse(z3);
        fs.writeFile("./stat/" + symbol + "_5phut_table.json", JSON.stringify(z3), (e) => { })
        fs.writeFile("./stat/" + symbol + "_5phut_table.csv", data2, (e) => { })
    }


})();