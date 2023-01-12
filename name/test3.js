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
  let a = await fetch("https://bgapidatafeed.vps.com.vn/getliststocktrade/AAA/", {
    "method": "GET",
    "mode": "cors",
    agent
  });
  let z = await a.text()



  console.log(z.length)




  superagent.get('https://bgapidatafeed.vps.com.vn/getliststocktrade/AAA/')
    .set('connection', 'keep-alive')
    .set('user-agent','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.131 Safari/537.36')
    .end((err, res) => {
      if (err) { return console.log(err); }
      console.log(res);
      console.log(res.body);
      // console.log(res.body);
    });


})()