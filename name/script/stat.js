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
import path from "path";
import stats from "stats-analysis";

function getNow() {
    let fd = new Date();
    return fd.getFullYear()
        + "" + (fd.getMonth() + 1 < 10 ? "0" + (fd.getMonth() + 1) : fd.getMonth() + 1)
        + "" + (fd.getDate() < 10 ? "0" + fd.getDate() : fd.getDate());
}

(async () => {

    let dto = Date.now() / 1000 + 7 * 60 * 60
    let dfrom = new Date(dto - 100 * 24 * 60 * 60);
    let symbols = ['HPG']
    const ts = new Transform({ transform(chunk, enc, cb) { cb(null, chunk) } })
    const logger = new Console({ stdout: ts })

    function getTable(data) {
        logger.table(data)
        return (ts.read() || '').toString()
    }


    let dir = "./stattest/" + getNow() + "/";
    if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir);
    } else {
        let files = fs.readdirSync(dir);
        for (const file of files) {
            fs.unlinkSync(path.join(dir, file));
        }
    }

    for (let symbol of symbols) {
        // let a = await  fetch("https://api-common-t19.24hmoney.vn/web-hook/open-api/tradingview/history?symbol=HPG&resolution=1&from_ts=1674809165&to_ts=1675250225", {
        //     "headers": {
        //       "accept": "*/*",
        //       "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
        //       "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
        //       "sec-ch-ua-mobile": "?0",
        //       "sec-fetch-dest": "empty",
        //       "sec-fetch-mode": "cors",
        //       "sec-fetch-site": "same-site"
        //     },
        //     "referrer": "https://24hmoney.vn/",
        //     "referrerPolicy": "strict-origin-when-cross-origin",
        //     "body": null,
        //     "method": "GET",
        //     "mode": "cors"
        //   });

        // let a = await fetch("https://histdatafeed.vps.com.vn/tradingview/history?symbol=" + symbol + "&resolution=D&from=" + dfrom + "&to=" + dto, {
        //     "headers": {
        //         "accept": "*/*",
        //         "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
        //         "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
        //         "sec-ch-ua-mobile": "?0",
        //         "sec-fetch-dest": "empty",
        //         "sec-fetch-mode": "cors",
        //         "sec-fetch-site": "same-site"
        //     },
        //     "referrer": "https://chart.vps.com.vn/",
        //     "referrerPolicy": "strict-origin-when-cross-origin",
        //     "body": null,
        //     "method": "GET",
        //     "mode": "cors"
        // });
        let a = await Exchange.MBS.pbRltCharts2("HPG", "5", Math.floor((Date.now() - 30 * 24 * 60 * 60 * 1000) / 1000))
        console.log(a)
        // let z = await a.json()
        let z = a.data;
        if (z.o == undefined) continue;

        let convert = (z, period) => {
            let zx = {};
            z.o.map((e, i) => {
                let k = Math.floor(z.t[i] / period) * period;
                console.log(k, z.t[i])
                let ne = zx[k];
                if (ne == undefined) {
                    ne = {};
                    ne = { c: z.c[i], h: z.h[i], l: z.l[i], o: z.o[i], t: k, v: z.v[i] }
                    zx[k] = ne;
                } else {
                    if (ne.h < z.h[i]) ne.h = z.h[i];
                    if (ne.l > z.l[i]) ne.l = z.l[i];
                    ne.v += z.v[i];
                    ne.c = z.c[i];
                }
            });
            let out = { o: [], c: [], h: [], l: [], t: [], v: [] };
            Object.keys(zx).sort().forEach((k) => {
                let ne = zx[k];
                out.o.push(ne.o)
                out.c.push(ne.c)
                out.h.push(ne.h)
                out.l.push(ne.l)
                out.t.push(ne.t)
                out.v.push(ne.v)
            }
            )

            return out;
        }

        z = convert(z, 15 * 60);
        // console.log(z)

        let z1 = z.o.map((e, i) => { return { c: z.c[i], h: z.h[i], l: z.l[i], o: z.o[i], t: z.t[i], v: z.v[i] } })

        let z2 = z1.reduce((a, b) => { return { v: (a.v + b.v) } }, { v: 0 })

        let av = z2.v / z1.length
        let z3 = z1.map(e => {
            e['av'] = av; e['r'] = (e.v / av).toFixed(2);
            e.date = (new Date(e.t * 1000 + 7 * 60 * 60 * 1000)).toISOString();
            e.updown = (e.c > e.o) ? "up" : (e.c < e.o) ? "down" : "-";
            return e;
        })





        const str = getTable(z3)
        // console.log(str.length) // 105
        // console.log(str)
        // console.table(z.h)
        let z4 = z1.map(e => e.h - e.l);
        console.log(stats.stdev(z4))
        let o = stats.indexOfOutliers(z4, stats.outlierMethod.MAD, 3);
        let out = [];
        let sum = 0;
        o.forEach(e => {
            // console.log(z4[e], z1[e]);
            out.push(z1[e]);
            sum += z1[e].h;
            let min = 9999999;
            for (let i = 0; i < 5; i++) {
                if (e + i > z1.length) { break; }
                if (min > z1[e + i].l)
                    min = z1[e + i].l;
            }
            sum += -min;
        })
        console.log(o)
        console.table(out)
        console.table(z1.slice(0, 15));
        console.table(z1.slice(z1.length - 15, z1.length));
        console.log("sum ", sum)
        fs.writeFile(dir + symbol + "_report_5phut_table.txt", str, (e) => { })
        let csv = new Parser({ fields: Object.keys[z3[0]] });
        let data2 = csv.parse(z3);
        fs.writeFile(dir + symbol + "_5phut_table.json", JSON.stringify(z3), (e) => { })
        fs.writeFile(dir + symbol + "_5phut_table.csv", data2, (e) => { })


    }


})();