const fetch = (...args) => import('node-fetch').then(({ default: fetch }) => fetch(...args));
const jsdom = require("jsdom");
const { JSDOM } = jsdom;
const fs = require("fs");

const http = require("node:http");
const https = require("node:https");
const httpAgent = new http.Agent({ keepAlive: true });
const httpsAgent = new https.Agent({ keepAlive: true });
const agent = (_parsedURL) => _parsedURL.protocol == 'http:' ? httpAgent : httpsAgent;

const Console = require('node:console').Console;
const Transform = require('node:stream').Transform;
const ts = new Transform({ transform(chunk, enc, cb) { cb(null, chunk) } })
const log = new Console({ stdout: ts })
const innertext = require('innertext');


function getTable(data) {
    log.table(data)
    return (ts.read() || '').toString()
}


(async () => {

    var args = process.argv.slice(2);

    let cmd = args[0];

    let guideURL = [];
    let extendURL = [];
    let abc = "a b c d e f g h i j k l m n o p q r s t u v w x y z".split(" ");
    stat = { req: 0, res: 0, length: abc.length }
    if (cmd != undefined && cmd.includes("download")) {
        if (fs.existsSync("guideURL.txt")) fs.unlinkSync("guideURL.txt");
        if (fs.existsSync("extendURL.txt")) fs.unlinkSync("extendURL.txt");
        let promise = new Promise(resolve => {
            for (let c of abc) {
                console.log(c)
                let a = fetch("https://dictionary.cambridge.org/browse/english/" + c, {
                    "headers": {
                        "accept": "application/json, text/plain, */*",
                        "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
                        "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
                        "sec-ch-ua-mobile": "?0",
                        "sec-fetch-dest": "empty",
                        "sec-fetch-mode": "cors",
                        "sec-fetch-site": "same-site"
                    },
                    "body": null,
                    "method": "GET",
                    "mode": "cors",
                    agent
                });
                a.then(res => res.text()).then(text => {
                    stat.res++;
                    let domtxt = text;
                    console.log(stat)
                    const dom = new JSDOM(domtxt);
                    let hrefs = dom.window.document.querySelectorAll("a.hlh32.hdb.dil.tcbd");
                    for (let e of hrefs) {
                        // console.log(e.getAttribute("href"));
                        guideURL.push(e.getAttribute("href"));
                        // fs.appendFileSync("guideURL.txt", e.getAttribute("href") + "\n");
                    }

                    if (stat.res == stat.length) {
                        resolve(guideURL);
                    }

                })

            }

        });
        let ret = await promise;

        console.table(guideURL);

        stat = { req: 0, res: 0, length: guideURL.length, start: Date.now() }
        promise = new Promise(async resolve => {
            for (let url of guideURL) {
                // console.log(c)
                while (stat.req - stat.res >= 20) {
                    await wait(100);
                }
                let a = fetch(url, {
                    "headers": {
                        "accept": "application/json, text/plain, */*",
                        "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
                        "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
                        "sec-ch-ua-mobile": "?0",
                        "sec-fetch-dest": "empty",
                        "sec-fetch-mode": "cors",
                        "sec-fetch-site": "same-site"
                    },
                    "body": null,
                    "method": "GET",
                    "mode": "cors",
                    agent
                });
                stat.req++;
                a.then(res => res.text()).then(text => {
                    stat.res++;
                    let domtxt = text;
                    console.log(stat, (Math.floor(stat.res * 10000 / stat.length) / 100) + "%", " tps ", stat.res * 1000 / (Date.now() - stat.start))
                    const dom = new JSDOM(domtxt);
                    let hrefs = dom.window.document.querySelectorAll("a.tc-bd[title]");
                    for (let e of hrefs) {
                        // console.log(e.getAttribute("href"));
                        extendURL.push("https://dictionary.cambridge.org" + e.getAttribute("href"));
                        fs.appendFileSync("extendURL.txt", "https://dictionary.cambridge.org" + e.getAttribute("href") + "\n");
                    }

                    if (stat.res == stat.length) {
                        resolve(extendURL);
                    }

                })

            }

        });

        await promise;
    } else {
        if (args.length == 0) {
            return;
        }
        let urls = [];
        for (let f of args) {
            let buf = fs.readFileSync(f);
            let urls = new String(buf).split("\n");
            console.log(urls.at(-2));
            console.log(urls.at(-1));
            extendURL.push(...urls.filter(s => s != ''));
        }
    }

    stat = { req: 0, res: 0, length: extendURL.length, start: Date.now() }

    let divTag = {};

    let promise = new Promise(async resolve => {
        for (let url of extendURL) {
            // console.log(url)
            while (stat.req - stat.res >= 5) {
                await wait(20);
            }

            const fetchPlus = (url, options = {}, retries) => {
                fetch(url, options)
                    .then(res => {
                        if (res.ok) {
                            return res;
                        }
                        if (retries > 0) {
                            return fetchPlus(url, options, retries - 1)
                        }
                        throw new Error(res.status)
                    })
                    .catch(error => console.error(error.message))
            }

            let a = fetch(url, {
                "headers": {
                    "accept": "application/json, text/plain, */*",
                    "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
                    "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
                    "sec-ch-ua-mobile": "?0",
                    "sec-fetch-dest": "empty",
                    "sec-fetch-mode": "cors",
                    "sec-fetch-site": "same-site"
                },
                "body": null,
                "method": "GET",
                "mode": "cors",
                agent,
                timeout: 100
            });
            // AND (both classes)

            // var list = document.getElementsByClassName("class1 class2");
            // var list = document.querySelectorAll(".class1.class2");
            // OR (at least one class)

            // var list = document.querySelectorAll(".class1,.class2");
            // XOR (one class but not the other)

            // var list = document.querySelectorAll(".class1:not(.class2),.class2:not(.class1)");
            // NAND (not both classes)

            // var list = document.querySelectorAll(":not(.class1),:not(.class2)");
            // NOR (not any of the two classes)

            // var list = document.querySelectorAll(":not(.class1):not(.class2)");            
            stat.req++;
            a.then(res => res.text()).then(text => {
                stat.res++;
                let domtxt = text;
                if (stat.res % 10 == 0) {
                    console.log(stat, (Math.floor(stat.res * 10000 / stat.length) / 100) + "%", " tps ", stat.res * 1000 / (Date.now() - stat.start), " ", Object.keys(divTag).length, args)
                    // fs.writeFileSync("./tag.txt", getTable(divTag), e => { });
                }
                const dom = new JSDOM(domtxt);
                let document = dom.window.document;
                if (document == null || document == undefined) {
                    console.log("PRO:", url)
                    // console.log(domtxt)
                }
                let page = document.querySelector("#page-content");
                if (page == null || page == undefined) {
                    console.log("PRO:", url)
                    // console.log(domtxt)
                }
                // let dic = page.querySelectorAll("div.pr.dictionary")
                // for (let d of dic) {
                //     let title = d.querySelector("div.di-title");
                //     let des = d.nextElementSibling;
                //     while (des != undefined) {
                //         // console.log(des.textContent)
                //         des = des.nextElementSibling;

                //     }
                // }

                let f = (n) => {
                    var children = n.children;
                    for (let c of children) {
                        // console.log(c.tagName,c.getAttribute("class"));
                        if (divTag[c.tagName + "." + c.getAttribute("class")] == undefined) {
                            let t = c.innerHTML;
                            t = innertext(t);
                            while (t.includes("  ")) { t = t.replaceAll("  ", " "); }
                            divTag[c.tagName + "." + c.getAttribute("class")] = t;
                        }
                        if (c.getAttribute("class") == null || c.getAttribute("class") == undefined) {
                            // console.log(c);
                        }
                        f(c);
                    }
                }
                // f(page);

                let title = page.querySelector("div.di-title");
                if (title == null) {
                    return;
                    // console.log("abc ", url, innertext(page.innerHTML))
                }

                let uk = page.querySelector("span.uk.dpron-i");
                let pronuk = uk != undefined ? uk.querySelector("span.pron.dpron") : ""
                let us = page.querySelector("span.us.dpron-i");
                let pronus = us != undefined ? us.querySelector("span.pron.dpron") : ""
                // console.table([{
                //     title: title!= undefined ? innertext(title.innerHTML): "",
                //     uk: uk != undefined ? innertext(uk.innerHTML).replaceAll("Your browser doesn't support HTML5 audio","") : "",
                //     ukp: pronuk != undefined ? pronuk.textContent : "",
                //     us: us != undefined ? innertext(us.innerHTML).replaceAll("Your browser doesn't support HTML5 audio","") : "",
                //     usp: pronus != undefined ? pronus.textContent : "",
                //     // url: url,
                //     // page: page.innerHTML,

                // }])

                let ou = {
                    title: title != undefined ? innertext(title.innerHTML) : "",
                    uk: uk != undefined ? innertext(uk.innerHTML).replaceAll("Your browser doesn't support HTML5 audio", "") : "",
                    ukp: pronuk != undefined ? pronuk.textContent : "",
                    us: us != undefined ? innertext(us.innerHTML).replaceAll("Your browser doesn't support HTML5 audio", "") : "",
                    usp: pronus != undefined ? pronus.textContent : "",
                    // url: url,
                    // page: page.innerHTML,

                }

                fs.appendFileSync(args[0] + ".dic", JSON.stringify(ou) + "\n", e => { });


            })

        }

    });


})();

function wait(ms) {
    return new Promise(resolve => {
        setTimeout(() => {
            resolve(0);
        }, ms);
    });
}