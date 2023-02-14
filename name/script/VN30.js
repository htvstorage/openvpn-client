import fetch from "node-fetch";
import fs from "fs";
import log4js from "log4js";
import { Parser } from "json2csv"
import path from "path";
import http from "node:http";
import https from "node:https";
import { Exchange } from "./Exchange.js";
import { Console } from 'node:console'
import { Transform } from 'node:stream'


var logger = log4js.getLogger();

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


const httpAgent = new http.Agent({ keepAlive: true });
const httpsAgent = new https.Agent({ keepAlive: true });
const agent = (_parsedURL) => _parsedURL.protocol == 'http:' ? httpAgent : httpsAgent;

const ts = new Transform({ transform(chunk, enc, cb) { cb(null, chunk) } })
const log = new Console({ stdout: ts })

function getTable(data) {
    log.table(data)
    return (ts.read() || '').toString()
}

(async () => {

    let out = await Exchange.SSI.vn30();
    let data = out.data.stockRealtimesByGroup.map(e => {
        let ne = {};
        Object.keys(e).forEach(k => {
            if (e[k] != null) ne[k] = e[k];
        })

        return ne;
    });

    let bid = data.reduce((a, b) => { return { best1BidVol: a.best1BidVol + b.best1BidVol, best2BidVol: (a.best2BidVol + b.best2BidVol), best3BidVol: (a.best3BidVol + b.best3BidVol) } }, { best1BidVol: 0, best2BidVol: 0, best3BidVol: 0 })

    let ask = data.reduce((a, b) => { return { best1OfferVol: a.best1OfferVol + b.best1OfferVol, best2OfferVol: (a.best2OfferVol + b.best2OfferVol), best3OfferVol: (a.best3OfferVol + b.best3OfferVol) } }, { best1OfferVol: 0, best2OfferVol: 0, best3OfferVol: 0 })

    logger.info(getTable(data.sort((a, b) => {
        let c = a.priceChangePercent - b.priceChangePercent;
        return c < 0 ? 1 : c > 0 ? -1 : 0

    })));
    console.table(bid);
    console.table(ask);


    fetch("https://wgateway-iboard.ssi.com.vn/graphql", {
  "headers": {
    "accept": "*/*",
    "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
    "content-type": "application/json",
    "g-captcha": "",
    "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
    "sec-ch-ua-mobile": "?0",
    "sec-fetch-dest": "empty",
    "sec-fetch-mode": "cors",
    "sec-fetch-site": "same-site"
  },
  "referrer": "https://iboard.ssi.com.vn/",
  "referrerPolicy": "strict-origin-when-cross-origin",
  "body": "{\"operationName\":\"stockRealtimes\",\"variables\":{\"exchange\":\"hose\"},\"query\":\"query stockRealtimes($exchange: String) {\\n  stockRealtimes(exchange: $exchange) {\\n    stockNo\\n    ceiling\\n    floor\\n    refPrice\\n    stockSymbol\\n    stockType\\n    exchange\\n    prevMatchedPrice\\n    lastMatchedPrice\\n    matchedPrice\\n    matchedVolume\\n    priceChange\\n    priceChangePercent\\n    highest\\n    avgPrice\\n    lowest\\n    nmTotalTradedQty\\n    best1Bid\\n    best1BidVol\\n    best2Bid\\n    best2BidVol\\n    best3Bid\\n    best3BidVol\\n    best4Bid\\n    best4BidVol\\n    best5Bid\\n    best5BidVol\\n    best6Bid\\n    best6BidVol\\n    best7Bid\\n    best7BidVol\\n    best8Bid\\n    best8BidVol\\n    best9Bid\\n    best9BidVol\\n    best10Bid\\n    best10BidVol\\n    best1Offer\\n    best1OfferVol\\n    best2Offer\\n    best2OfferVol\\n    best3Offer\\n    best3OfferVol\\n    best4Offer\\n    best4OfferVol\\n    best5Offer\\n    best5OfferVol\\n    best6Offer\\n    best6OfferVol\\n    best7Offer\\n    best7OfferVol\\n    best8Offer\\n    best8OfferVol\\n    best9Offer\\n    best9OfferVol\\n    best10Offer\\n    best10OfferVol\\n    buyForeignQtty\\n    buyForeignValue\\n    sellForeignQtty\\n    sellForeignValue\\n    caStatus\\n    tradingStatus\\n    remainForeignQtty\\n    currentBidQty\\n    currentOfferQty\\n    session\\n    __typename\\n  }\\n}\\n\"}",
  "method": "POST",
  "mode": "cors"
});

})();