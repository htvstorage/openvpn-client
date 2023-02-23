const fetch = (...args) => import('node-fetch').then(({ default: fetch }) => fetch(...args));
const jsdom = require("jsdom");
const { JSDOM } = jsdom;
const fs = require("fs");

const http = require("node:http");
const https = require("node:https");
const httpAgent = new http.Agent({ keepAlive: true });
const httpsAgent = new https.Agent({ keepAlive: true });
const agent = (_parsedURL) => _parsedURL.protocol == 'http:' ? httpAgent : httpsAgent;

const fetchPlus = (url, options = {}, retries) => {
    fetch(url, options)
        .then(res => {
            if (res.ok) {
                console.log("==============", res)
                return res;
            }
            if (retries > 0) {
                return fetchPlus(url, options, retries - 1)
            }
            throw new Error(res.status)
        })
        .catch(error => console.error(error.message))
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

        stat = { req: 0, res: 0, length: guideURL.length }
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
                    console.log(stat, (Math.floor(stat.res * 10000 / stat.length) / 100) + "%")
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
        let buf = fs.readFileSync("extendURL.txt");
        let urls = new String(buf).split("\n");
        console.log(urls.at(-2));
        console.log(urls.at(-1));
        extendURL.push(...urls);
    }

    stat = { req: 0, res: 0, length: extendURL.length }
    let promise = new Promise(async resolve => {
        for (let url of extendURL) {
            console.log(url)
            while (stat.req - stat.res >= 20) {
                await wait(20);
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
                console.log(stat, (Math.floor(stat.res * 10000 / stat.length) / 100) + "%")
                const dom = new JSDOM(domtxt);
                let document = dom.window.document;
                let page = document.querySelector("div.page");
                let dic = page.querySelectorAll("div.pr.dictionary")
                for(let d of dic){
                    let title = d.querySelector("div.di-title");
                    let des = d.nextElementSibling;
                    while(des != undefined){
                        console.log(des.textContent)
                        des = des.nextElementSibling;

                    }



                }


                let header = page.querySelector("div.di-title")
                let header = page.querySelector("")
                let header = page.querySelector("")
                let header = page.querySelector("")
                let header = page.querySelector("")
                // console.log(url)
                console.log(hrefs[0].textContent);

                // for(let e of hrefs){
                //     // console.log(e.getAttribute("href"));
                //     extendURL.push("https://dictionary.cambridge.org"+e.getAttribute("href"));
                //     fs.appendFileSync("extendURL.txt","https://dictionary.cambridge.org"+e.getAttribute("href")+"\n");
                // }
                // if (stat.res == stat.length) {
                //     resolve(extendURL);
                // }

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