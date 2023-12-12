const { parentPort } = require("worker_threads");
const fetch = require("node-fetch-retry");
const fs = require("fs");
const path = require("path")
const stream = require('stream');
const log4js = require("log4js");
const { Parser } = require("json2csv")
const http = require("node:http");
const https = require("node:https");
// const { Exchange } = require("./Exchange.js");
const { map, map10, map20, largeCap, midCap, smallCap, mapCap } = require('./symbols.js')
var logger = log4js.getLogger();
const httpAgent = new http.Agent({ keepAlive: true });
const httpsAgent = new https.Agent({ keepAlive: true });
const agent = (_parsedURL) => _parsedURL.protocol == 'http:' ? httpAgent : httpsAgent;
const xlsx = require("xlsx")
const { SMA, EMA, RSI, StochasticRSI, MACD, MFI, BollingerBands } = require('technicalindicators');



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

const FORCE = process.env.FORCE
const LIMIT = process.env.LIMIT || 2500;
const LIMIT_PROCESS = process.env.LIMIT_PROCESS || 1000;
const SHORT_DAY = process.env.SHORT_DAY || [5, 9, 10, 12, 20, 25, 26, 30, 50, 100, 200]
const SHORT_VOL_DAY = process.env.SHORT_VOL_DAY || [5, 10, 20, 26, 30, 200, 1000]
console.log("LIMIT", LIMIT)
console.log("LIMIT_PROCESS", LIMIT_PROCESS)
let investor = async function (symbol) {
    // console.log()
    let f = async (symbol) => {
        return await fetch("https://restv2.fireant.vn/symbols/" + symbol + "/historical-quotes?startDate=2000-12-06&endDate=" + getNow2() + "&offset=0&limit=" + LIMIT, {
            "headers": {
                "accept": "application/json, text/plain, */*",
                "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
                "authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IkdYdExONzViZlZQakdvNERWdjV4QkRITHpnSSIsImtpZCI6IkdYdExONzViZlZQakdvNERWdjV4QkRITHpnSSJ9.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmZpcmVhbnQudm4iLCJhdWQiOiJodHRwczovL2FjY291bnRzLmZpcmVhbnQudm4vcmVzb3VyY2VzIiwiZXhwIjoxOTQ3MjQ3NzkxLCJuYmYiOjE2NDcyNDc3OTEsImNsaWVudF9pZCI6ImZpcmVhbnQudHJhZGVzdGF0aW9uIiwic2NvcGUiOlsib3BlbmlkIiwicHJvZmlsZSIsInJvbGVzIiwiZW1haWwiLCJhY2NvdW50cy1yZWFkIiwiYWNjb3VudHMtd3JpdGUiLCJvcmRlcnMtcmVhZCIsIm9yZGVycy13cml0ZSIsImNvbXBhbmllcy1yZWFkIiwiaW5kaXZpZHVhbHMtcmVhZCIsImZpbmFuY2UtcmVhZCIsInBvc3RzLXdyaXRlIiwicG9zdHMtcmVhZCIsInN5bWJvbHMtcmVhZCIsInVzZXItZGF0YS1yZWFkIiwidXNlci1kYXRhLXdyaXRlIiwidXNlcnMtcmVhZCIsInNlYXJjaCIsImFjYWRlbXktcmVhZCIsImFjYWRlbXktd3JpdGUiLCJibG9nLXJlYWQiLCJpbnZlc3RvcGVkaWEtcmVhZCJdLCJzdWIiOiIxZDY5YmE3NC0xNTA1LTRkNTktOTA0Mi00YWNmYjRiODA3YzQiLCJhdXRoX3RpbWUiOjE2NDcyNDc3OTEsImlkcCI6Ikdvb2dsZSIsIm5hbWUiOiJ0cmluaHZhbmh1bmdAZ21haWwuY29tIiwic2VjdXJpdHlfc3RhbXAiOiI5NTMyOGNlZi1jZmY1LTQ3Y2YtYTRkNy1kZGFjYWJmZjRhNzkiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJ0cmluaHZhbmh1bmdAZ21haWwuY29tIiwidXNlcm5hbWUiOiJ0cmluaHZhbmh1bmdAZ21haWwuY29tIiwiZnVsbF9uYW1lIjoiVHJpbmggVmFuIEh1bmciLCJlbWFpbCI6InRyaW5odmFuaHVuZ0BnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6InRydWUiLCJqdGkiOiJhMTY2MDQwOGNhMGFkYWQxOTcwZDVhNWZhMmFjNjM1NSIsImFtciI6WyJleHRlcm5hbCJdfQ.cpc3almBHrGu-c-sQ72hq6rdwOiWB1dIy1LfZ6cgjyH4YaBWiQkPt4l7M_nTlJnVOdFt9lM2OuSmCcTJMcAKLd4UmdBypeZUpTZp_bUv1Sd3xV8LHF7FSj2Awgw0HIaic08h1LaRg0pPzzf-IRJFT7YA8Leuceid6rD4BCQ3yNvz8r58u2jlCXuPGI-xA8W4Y3151hpNWCtemyizhzi7EKri_4WWpXrXPAeTAnZSdoSq87shTxm9Kyz_QJUBQN6PIEINl9sIQaKL-I_jR9LogYB_aM3hs81Ga6h-n-vbnFK8JR1JEJQmU-rxyX7XvuL-UjQVag3LxQeJwH7Nnajkkg",
                "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
                "sec-ch-ua-mobile": "?0",
                "sec-fetch-dest": "empty",
                "sec-fetch-mode": "cors",
                "sec-fetch-site": "same-site"
            },
            "referrerPolicy": "no-referrer",
            "body": null,
            "method": "GET",
            "mode": "cors",
            agent
        }, { timeout: 100 });
    }
    let a = await f(symbol);
    let x = await a.text();
    while (![x.startsWith("[")]) {
        logger.warn(x);
        await wait(500);
        a = f(symbol);
        x = await a.text();
    }
    x = JSON.parse(x);
    return { 'data': x, 'code': symbol };
}

// main
// let stockdata = {};
let checkSymbol = {};
let formater = new Intl.NumberFormat('en-IN', { maximumSignificantDigits: 3 });

function writeArrayJson2Xlsx(filename, ...args) {
    let workbook = xlsx.utils.book_new();
    args.forEach(s => {
        let worksheet = xlsx.utils.json_to_sheet(s);
        xlsx.utils.book_append_sheet(workbook, worksheet);
    })
    xlsx.writeFile(workbook, filename);
}

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


(async () => {
    let ssiSymbol = Object.keys(map)
    let ssiCop = ssiSymbol.map(e => { return { stock_code: e } });
    console.table(ssiSymbol.length)
    console.table(ssiCop.length)

    let cop = ssiCop
    let watchlist = ['HPG']
    let total_check = 0;
    try {

        if (!fs.existsSync("./indicator/indicator" + getNow() + ".json") || FORCE) {
            let t1 = Date.now();
            let dir = "./his";

            let fun = investor;


            if (!fs.existsSync(dir)) {
                fs.mkdirSync(dir, { recursive: true });
            }
            let investorData = {}
            if (!fs.existsSync(dir + "/investorData" + getNow() + ".json") || FORCE) {
                let files = fs.readdirSync(dir);
                for (const file of files) {
                    fs.unlinkSync(path.join(dir, file));
                }
                let maxSize = 30;
                let stat = { req: 0, res: 0, record: 0 }
                total_check = cop.length;
                cop = cop.filter(e => e.stock_code.length < 4)
                // cop = [ {stock_code:"HPG"}]
                cop.push({ stock_code: "VNINDEX" }) //vnindex
                cop.push({ stock_code: "VN30" }) //vn30-index
                console.log("Fetching", cop.length)
                for (let x of cop) {
                    logger.trace(x.Code);
                    while (stat.req - stat.res >= maxSize) {
                        await wait(200);
                    }
                    stat.req++;
                    let z = fun(x.stock_code);
                    z.then((ret) => {

                        if (logger.isTraceEnabled)
                            logger.trace(ret.data.length);

                        // if (localRes == total_check) {
                        //   logger.info("Done " + getNow() + " " + (Date.now() - t1) / 1000 + " ms");
                        // }
                        if (ret.data.length == 0) {
                            stat.res++;
                            if (stat.res % 10 == 0) {
                                console.log(stat)
                            }
                            return;
                        }

                        stat.record += ret.data.length;

                        if (watchlist.includes(ret.code)) {
                            // logger.info("\n",ret.Code,"\n",data2.substr(0,data2.indexOf("\n",200)));
                        }

                        var ma = {}
                        const d = ret.data;
                        ma.p = Object.keys(d[0])
                        ma.p.forEach(pp => {
                            ma[pp] = []
                        })
                        d.reverse();
                        d.forEach(e => {
                            ma.p.forEach(pp => {
                                if (pp.includes('price')) {
                                    ma[pp].push(e[pp] / e.adjRatio)
                                } else {
                                    ma[pp].push(e[pp])
                                }
                            })
                        })

                        investorData[ret.code] = ma;
                        stat.res++;
                        if (stat.res % 10 == 0) {
                            console.log(stat)
                        }

                    })

                }

                while (stat.res < stat.req) {
                    await wait(2000);
                }
                console.log(stat)
                for (const key in investorData) {
                    fs.appendFileSync(dir + "/investorData" + getNow() + ".json", JSON.stringify({ [key]: investorData[key] }) + '\n')
                }
            }

            let combineData = {}

            let readInvestorFiles = async () => {
                let files = fs.readdirSync(dir)
                files = files.filter(e => e.endsWith(".json"))
                console.table(files)

                for (let f of files) {
                    var pm = new Promise((res, rej) => {
                        let readStream = fs.createReadStream(dir + "/" + f, {
                            encoding: 'utf8',
                            highWaterMark: 128 * 1024 * 1024, // 128 MB
                        })
                        // Handle data events      
                        let remainingData = ''
                        let stat = { req: 0, res: 0, total: 0 }
                        readStream.on('data', (chunk) => {
                            remainingData += chunk;
                            const lastNewlineIndex = remainingData.lastIndexOf('\n');
                            // If a newline character is found, process the data before the last newline
                            if (lastNewlineIndex !== -1) {
                                const dataBeforeLastNewline = remainingData.substring(0, lastNewlineIndex);
                                // console.log(dataBeforeLastNewline)         
                                remainingData = remainingData.substring(lastNewlineIndex + 1);
                                let messages = dataBeforeLastNewline.split('\n').filter(l => l.length > 0).map(l => JSON.parse(l))
                                stat.total += messages.length;
                                messages.forEach(e => {
                                    stat.req++;

                                    stat.res++;
                                    if (stat.req % 10000 == 0) {
                                        console.log(stat)
                                    }
                                    // combineData[Object.keys(e)[0]] = Object.values(e)[0].slice(0, LIMIT_PROCESS);
                                    var d = Object.values(e)[0];
                                    // console.table(d)
                                    for (var pp in d) {
                                        if (pp != "p") {
                                            d[pp] = d[pp].slice(Math.max(d[pp].length - LIMIT_PROCESS, 0))
                                        }
                                    }
                                    combineData[Object.keys(e)[0]] = d;

                                })
                            }
                        });

                        // Handle end event
                        readStream.on('end', () => {
                            res(combineData)
                            console.log('Finished reading the file.');
                        });

                        // Handle error events
                        readStream.on('error', (error) => {
                            console.error('Error reading the file:', error);
                        });
                    })
                    await pm;
                }
                investorData = Object.values(combineData)

                return combineData;
            }

            await readInvestorFiles()

            // {
            //     date: '2023-07-27T00:00:00',
            //     symbol: 'HPG',
            //     priceHigh: 28.7,
            //     priceLow: 28.1,
            //     priceOpen: 28.4,
            //     priceAverage: 28.33059,
            //     priceClose: 28.4,
            //     priceBasic: 28.4,
            //     totalVolume: 21315975,
            //     dealVolume: 21315900,
            //     putthroughVolume: 75,
            //     totalValue: 603894007131,
            //     putthroughValue: 1983750,
            //     buyForeignQuantity: 4111213,
            //     buyForeignValue: 116776160000,
            //     sellForeignQuantity: 2484392,
            //     sellForeignValue: 70242450000,
            //     buyCount: 13884,
            //     buyQuantity: 39446148,
            //     sellCount: 9947,
            //     sellQuantity: 40982978,
            //     adjRatio: 1,
            //     currentForeignRoom: 1316714310,
            //     propTradingNetDealValue: 8398910000,
            //     propTradingNetPTValue: -1984000,
            //     propTradingNetValue: 8396926000
            //   },

            // if (parentPort) {
            //     parentPort.postMessage(investorData)
            // }

            // let symbolMapData = {}
            // for (var symbol in combineData) {
            //     var ma = {}
            //     const d = combineData[symbol];
            //     ma.p = Object.keys(d[0])
            //     ma.p.forEach(pp => {
            //         ma[pp] = []
            //     })
            //     d.reverse();
            //     d.forEach(e => {
            //         ma.p.forEach(pp => {
            //             if (pp.includes('price')) {
            //                 ma[pp].push(e[pp] / e.adjRatio)
            //             } else {
            //                 ma[pp].push(e[pp])
            //             }
            //         })
            //     })
            //     symbolMapData[symbol] = ma
            // }
            let symbolMapData = combineData;
            let shortPeriods;
            let shortVolVal;
            if (typeof SHORT_DAY === 'string') {
                shortPeriods = SHORT_DAY.split(",").map(e => +e);
            } else {
                if (Array.isArray(SHORT_DAY)) {
                    shortPeriods = SHORT_DAY;
                } else {
                    shortPeriods = [5, 9, 10, 20, 25, 26, 30, 50, 100, 200];
                }
            }

            if (typeof SHORT_VOL_DAY === 'string') {
                shortVolVal = SHORT_VOL_DAY.split(",").map(e => +e);
            } else {
                if (Array.isArray(SHORT_VOL_DAY)) {
                    shortVolVal = SHORT_VOL_DAY;
                } else {
                    shortVolVal = [5, 10, 20, 26, 30, 200, 1000]
                }
            }

            var checkDate = -1;
            var mapIndicator = {}

            for (var symbol in symbolMapData) {
                var indicator = {}


                var prices = symbolMapData[symbol].priceClose
                var high = symbolMapData[symbol].priceHigh
                var low = symbolMapData[symbol].priceLow
                var val = symbolMapData[symbol].totalValue
                var vol = symbolMapData[symbol].totalVolume

                let smaRet = shortPeriods.map(e => { return SMA.calculate({ period: e, values: prices }); });
                let emaRet = shortPeriods.map(e => { return EMA.calculate({ period: e, values: prices }); });
                let smaVolRet = shortVolVal.map(e => { return SMA.calculate({ period: e, values: vol }); });
                let smaValRet = shortVolVal.map(e => { return SMA.calculate({ period: e, values: val }); });
                shortPeriods.forEach((e, i) => {
                    indicator['price_ma_' + e] = smaRet[i].at(checkDate)
                })
                shortPeriods.forEach((e, i) => {
                    indicator['price_ema_' + e] = emaRet[i].at(checkDate)
                })
                shortVolVal.forEach((e, i) => {
                    indicator['vol_' + e] = smaVolRet[i].at(checkDate)
                    indicator['val_' + e] = smaValRet[i].at(checkDate)
                    indicator['price_max_' + e] = Math.max(...high.slice(high.length - e))
                    indicator['price_min_' + e] = Math.min(...low.slice(low.length - e))
                    indicator['vol_min_' + e] = Math.min(...vol.slice(vol.length - e))
                    indicator['vol_max_' + e] = Math.max(...vol.slice(vol.length - e))
                    indicator['val_min_' + e] = Math.min(...val.slice(vol.length - e))
                    indicator['val_max_' + e] = Math.max(...val.slice(vol.length - e))
                })


                var inputRSI = {
                    values: prices,
                    period: 14
                };

                var rsi = RSI.calculate(inputRSI);

                indicator.rsi = rsi.at(checkDate)

                const bb = { period: 20, stdDev: 2, values: prices };
                const macd = { fastPeriod: 12, slowPeriod: 26, signalPeriod: 9, values: prices, };


                var bbo = BollingerBands.calculate(bb);
                var macdo = MACD.calculate(macd);

                let bbe = bbo.at(checkDate);
                let macde = macdo.at(checkDate);

                if (bbe)
                    Object.keys(bbe).forEach(e => {
                        indicator["price_bb_" + e] = bbe[e];
                    })
                if (macde)
                    Object.keys(macde).forEach(e => {
                        indicator["macd_" + e.toLowerCase()] = macde[e];
                    })

                indicator.symbol = symbol;
                // console.table(indicator)
                mapIndicator[symbol] = indicator
            }

            dir = "./indicator"
            if (!fs.existsSync(dir)) {
                fs.mkdirSync(dir)
            }
            fs.writeFileSync(dir + "/indicator" + getNow() + ".json", JSON.stringify(mapIndicator))
        } else {
            var dir = "./indicator"
            var buff = fs.readFileSync(dir + "/indicator" + getNow() + ".json", "utf-8")
            var mapIndicator = JSON.parse(buff);
            console.table(mapIndicator)
        }

    } catch (error) {
        logger.error(error);
    } finally {
        await wait(1000);
    }
})();


function getNow() {
    let fd = new Date();
    return fd.getFullYear()
        + "" + (fd.getMonth() + 1 < 10 ? "0" + (fd.getMonth() + 1) : fd.getMonth() + 1)
        + "" + (fd.getDate() < 10 ? "0" + fd.getDate() : fd.getDate());
}

function getNow2() {
    let fd = new Date();
    return fd.getFullYear()
        + "-" + (fd.getMonth() + 1 < 10 ? "0" + (fd.getMonth() + 1) : fd.getMonth() + 1)
        + "-" + (fd.getDate() < 10 ? "0" + fd.getDate() : fd.getDate());
}

function wait(ms) {
    return new Promise(resolve => {
        setTimeout(() => {
            resolve(0);
        }, ms);
    });
}

