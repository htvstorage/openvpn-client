import { Exchange } from "./Exchange.js";
import fetch from "node-fetch";
import request from 'request'
import puppeteer from "puppeteer";
import http from "node:http";
import https from "node:https";
import { resolve } from "path";
import superagent from 'superagent'
const httpAgent = new http.Agent({ keepAlive: true });
const httpsAgent = new https.Agent({ keepAlive: true });
const agent = (_parsedURL) => _parsedURL.protocol == 'http:' ? httpAgent : httpsAgent;

(async () => {
  let a = await fetch("https://bgapidatafeed.vps.com.vn/getliststocktrade/SAB", {
    "credentials": "omit",
    "headers": {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) SFive/73.0 Chrome/73.0.3683.104 Safari/537.36",
        "Accept": "application/json, text/plain, */*",
        "Accept-Language": "vi-VN,vi;q=0.8,en-US;q=0.5,en;q=0.3",
        "Sec-Fetch-Dest": "empty",
        "Sec-Fetch-Mode": "cors",
        "Sec-Fetch-Site": "same-site"
    },
    "referrer": "https://banggia.vps.com.vn/",
    "method": "GET",
    "mode": "cors"
});

let z = await a.text()



  console.log(z.length)



})()