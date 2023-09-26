import fs from "fs"
import { Exchange } from './Exchange.js';
import puppeteer from "puppeteer";
import request_client from 'request-promise-native'
import jsdom from "jsdom"
const { JSDOM } = jsdom;
//sudo apt update; sudo apt-get install -y libatk-bridge2.0-0 libgtk-3.0 libasound2 libgbm-dev


let pageid = {};
let pageid2 = [];
let pagedone = {};
let stat = { count: 0 }
async function initBrowser(profileDir) {

    const browser = await puppeteer.launch({
        headless: true, args: ['--user-data-dir=' + profileDir]
    });

    const page = await browser.newPage();
    const mobile = await browser.newPage();
    await mobile.setExtraHTTPHeaders({
        "User-Agent":
            "Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1",
    })
    await mobile.setViewport({ width: 390, height: 844 });
    await page.setRequestInterception(true);
    await mobile.setRequestInterception(true);
    let loadImage = { load: false }
    page.on('request', request => {


        if (request.resourceType() == 'image') {
            if (loadImage.load)
                request.continue()
            else {
                request.abort()
            }
        } else {
            if (request.url().includes("graphql"))
                console.log("URL", request.url().includes("graphql"), request.url().slice(0, 100))
            if (request.url().includes("graphql")) {
                request_client({
                    uri: request.url(),
                    resolveWithFullResponse: true,
                }).then(response => {
                    const request_url = request.url();
                    const request_headers = request.headers();
                    const request_post_data = request.postData();
                    const response_headers = response.headers;
                    const response_size = response_headers['content-length'];
                    const response_body = response.body;
                    result.push({
                        request_url,
                        request_headers,
                        request_post_data,
                        response_headers,
                        response_size,
                        response_body,
                    });
                    console.log(request_url, "\n", request_headers)
                    request.continue();
                }).catch(error => {
                    // if (request.postData().includes("CometHovercardQueryRendererQuery")) {
                    //     console.log("error", request.url(), "\n", request.headers(), "\n", request.postData(), "\n")
                    // }
                    request.continue();
                });
            } else {
                request.continue();
            }
        }
    });

    mobile.on('request', request => {
        if (request.resourceType() == 'image') {
            if (loadImage.load)
                request.continue()
            else {
                request.abort()
            }

        } else {
            if (request.url().includes("graphql"))
                console.log("URL", request.url().includes("graphql"), request.url().slice(0, 100))
            if (request.url().includes("graphql")) {
                request_client({
                    uri: request.url(),
                    resolveWithFullResponse: true,
                }).then(response => {
                    const request_url = request.url();
                    const request_headers = request.headers();
                    const request_post_data = request.postData();
                    const response_headers = response.headers;
                    const response_size = response_headers['content-length'];
                    const response_body = response.body;
                    result.push({
                        request_url,
                        request_headers,
                        request_post_data,
                        response_headers,
                        response_size,
                        response_body,
                    });
                    console.log(request_url, "\n", request_headers)
                    request.continue();
                }).catch(error => {
                    request.continue();
                });
            } else {
                request.continue();
            }
        }
    });

    let c = 0;
    page.on('response', async (response) => {
        if (response.url().includes("graphql")) {
            try {
                let text = await response.text();
                if (text.includes('{"data":{"serpResponse":{"results":{"edges":[{"node":{"role":"ENTITY_PAGES","__typename":"SearchRenderable"}')) {
                    let datajs = JSON.parse(text);
                    let edges = datajs.data.serpResponse.results.edges
                    for (let e of edges) {
                        // await CometHovercardQueryRendererQuery(e.relay_rendering_strategy.view_model.profile.id)
                        // await axiosId(mobile, e.relay_rendering_strategy.view_model.profile.id)
                        let pid = {keyword: stat.keyword, id: e.relay_rendering_strategy.view_model.profile.id, name: e.relay_rendering_strategy.view_model.profile.name }
                        pageid[pid.id] = pid.id;
                        pageid2.push(pid.id)
                        // console.log(c++, Object.keys(pageid).length, e.relay_rendering_strategy.view_model.profile.id, e.relay_rendering_strategy.view_model.profile.name)
                        fs.appendFileSync("facebook/pageid.txt", JSON.stringify(pid) + '\n')
                        stat.total = Object.keys(pageid).length;
                        stat.count++;
                    }

                }
            } catch (error) {

            }

        }
    });

    mobile.on('response', async (response) => {
        // console.log(response.url())
    });
    return [browser, page, mobile]
}


let done = {}
let province = []
let keywords = []

async function loadKeywords() {
    if (!fs.existsSync("facebook/keywords.txt")) return [];
    let buffer = fs.readFileSync("facebook/keywords.txt", "utf-8")
    let data = buffer.toString("utf8")
        .split('\n')
        .map(e => e.trim());
    return data;
}


async function loadDone() {
    if (!fs.existsSync("facebook/done.txt")) return {};
    let buffer = fs.readFileSync("facebook/done.txt", "utf-8")
    let data = buffer.split('\n')
        .map(e => e.trim());
    let d = {}
    data.forEach(e => {
        d[e] = e;
    })
    return d;
}

async function loadProvince(filename) {
    if (!fs.existsSync(filename)) return {};
    let buffer = fs.readFileSync(filename, "utf-8")
    let data = buffer.split('\n')
        .map(e => e.trim());
    return data;
}

async function loadLocation() {
    if (!fs.existsSync("facebook/location.json")) return {};
    let buffer = fs.readFileSync("facebook/location.json", "utf-8")
    buffer = buffer.slice(0, buffer.length - 1);
    let data = buffer.split('\n')
        .map(e => e.trim()).map(e => JSON.parse(e));
    let d = {}
    data.forEach(e => {
        d[e.province] = e;
    })
    return d;
}

async function loadPageId() {
    if (!fs.existsSync("facebook/pageid.json")) return {};
    let buffer = fs.readFileSync("facebook/pageid.json", "utf-8")
    buffer = buffer.slice(0, buffer.length - 1);
    let data = buffer.split('\n')
        .map(e => e.trim()).map(e => JSON.parse(e));
    let d = {}
    data.forEach(e => {
        d[e.id] = e;
    })
    return d;
}


keywords = await loadKeywords();
done = await loadDone();


const run = async () => {

    let args = process.argv.slice(2);
    let provinces = null;
    if (args.length == 0) {
        provinces = [ "Hà Giang","Hà Nội", "Cao Bằng", "Bắc Kạn", "Tuyên Quang", "Lào Cai", "Điện Biên", "Lai Châu", "Sơn La", "Yên Bái", "Hoà Bình", "Thái Nguyên", "Lạng Sơn", "Quảng Ninh", "Bắc Giang", "Phú Thọ", "Vĩnh Phúc", "Bắc Ninh", "Hải Dương", "Hải Phòng", "Hưng Yên", "Thái Bình", "Hà Nam", "Nam Định", "Ninh Bình", "Thanh Hóa", "Nghệ An", "Hà Tĩnh", "Quảng Bình", "Quảng Trị", "Thừa Thiên Huế", "Đà Nẵng", "Quảng Nam", "Quảng Ngãi", "Bình Định", "Phú Yên", "Khánh Hòa", "Ninh Thuận", "Bình Thuận", "Kon Tum", "Gia Lai", "Đắk Lắk", "Đắk Nông", "Lâm Đồng", "Bình Phước", "Tây Ninh", "Bình Dương", "Đồng Nai", "Bà Rịa - Vũng Tàu", "Hồ Chí Minh", "Long An", "Tiền Giang", "Bến Tre", "Trà Vinh", "Vĩnh Long", "Đồng Tháp", "An Giang", "Kiên Giang", "Cần Thơ", "Hậu Giang", "Sóc Trăng", "Bạc Liêu", "Cà Mau"]
    } else {
        provinces = loadProvince(args[0]);

    }

    let location = await loadLocation();
    // console.table(location)

    let [browser, page, mobile] = await initBrowser("./userdata8")

     queryPage(mobile)

    await page.setViewport({ width: 1920, height: 100000 });
    await page.goto("https://www.facebook.com/", {
        waitUntil: 'domcontentloaded',
        timeout: 60000
    });
    if (await page.$('#email'))
        await page.type("#email", "quanghuyluxury911681169@gmail.com");
    if (await page.$('#pass'))
        await page.type("#pass", "Htv.@123");
    if (await page.$('#loginbutton'))
        await page.click("#loginbutton");
    if (await page.$('button[name="login"]')) {
        console.log("Login")
        await page.click('button[name="login"]');
    }


    let source1 = await page.content({ "waitUntil": "domcontentloaded" });

    await wait(3000)
    if (page.viewport.height < 10000)
        await page.screenshot({ path: "after-login.jpg" });

    for (let province of provinces) {
        try {
            for (let keyword of keywords) {
                if (done[keyword + " " + province]) {
                    console.log("Skip for done ", keyword, province)
                    continue;
                }
                stat.keyword = keyword;
                let kuri = encodeURI(keyword);
                let url = location[province].filter.replaceAll("Cua%20hang", kuri);
                console.log(url)
                await page.goto(url, {
                    waitUntil: 'domcontentloaded',
                    timeout: 60000
                });
                let last = Date.now();
                let i = 0;
                let lastCount = 0;
                while (true) {
                    i++;
                    await wait(1000)
                    console.log("Load more ....", i,lastCount, stat)
                    if (lastCount < stat.count) {
                        lastCount = stat.count
                        last = Date.now();
                    }
                    if ((Date.now() - last >= 20000) || (stat.count == 0 && Date.now() - last >= 10000)) {
                        console.log("Done load ", keyword, province)
                        done[keyword + " " + province]=keyword + " " + province
                        stat = {count:0}
                        fs.appendFileSync("facebook/done.txt", keyword + " " + province + "\n")
                        break;
                    }
                    await page.evaluate('window.scrollTo(0, document.body.scrollHeight)')
                }

                // await page.waitForNavigation({ waitUntil: 'networkidle0' })
                // await page.click('a[aria-current="page"]')
                // await page.waitForNavigation({ waitUntil: 'networkidle0' })
                // await page.screenshot({ path: "after-login.jpg" });

                let source = await page.content({ "waitUntil": "domcontentloaded" });

                fs.writeFileSync("source.txt", source)
            }

        } catch (error) {
            console.log(error)
        } finally {

        }


    }

    await browser.close();
};

run();


const scrollPage = async (page, scrollContainer, itemTargetCount) => {
    let items = [];
    let previousHeight = await page.evaluate(`document.querySelector("${scrollContainer}").scrollHeight`);
    let lastLength = 0;
    let c = 0;
    while ((c <= 8) && (itemTargetCount > items.length)) {
        // items = await extractItems(page);
        await page.evaluate(`document.querySelector("${scrollContainer}").scrollTo(0, document.querySelector("${scrollContainer}").scrollHeight)`);
        await page.evaluate(`document.querySelector("${scrollContainer}").scrollHeight > ${previousHeight}`);
        await page.waitForTimeout(500);
        console.log(items.length, c)
        if (lastLength < items.length) {
            lastLength = items.length
            c = 0;
        } else {
            c++;
        }

    }
    return items;
}

function wait(ms) {
    return new Promise(resolve => {
        setTimeout(() => {
            resolve(0);
        }, ms);
    });
}


async function CometHovercardQueryRendererQuery(id) {
    await wait(200)
    let a = await fetch("https://m.facebook.com/p/N%E1%BB%99i-Th%E1%BA%A5t-Kim-Th%C3%A0nh-100092039206008/?profile_tab_item_selected=about&wtsid=rdr_065lWbujEWpg92ZjR", {
        "headers": {
            "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
            "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
            "cache-control": "max-age=0",
            "dpr": "1.125",
            "sec-ch-prefers-color-scheme": "dark",
            "sec-ch-ua": "\"Chromium\";v=\"116\", \"Not)A;Brand\";v=\"24\", \"Google Chrome\";v=\"116\"",
            "sec-ch-ua-full-version-list": "\"Chromium\";v=\"116.0.5845.188\", \"Not)A;Brand\";v=\"24.0.0.0\", \"Google Chrome\";v=\"116.0.5845.188\"",
            "sec-ch-ua-mobile": "?1",
            "sec-ch-ua-model": "\"Nexus 5\"",
            "sec-ch-ua-platform": "\"Android\"",
            "sec-ch-ua-platform-version": "\"6.0\"",
            "sec-fetch-dest": "document",
            "sec-fetch-mode": "navigate",
            "sec-fetch-site": "none",
            "sec-fetch-user": "?1",
            "upgrade-insecure-requests": "1",
            "viewport-width": "1115",
            "cookie": "datr=eo8PZam4GwCy---3HcmaIWaz; sb=_pEPZdCeyLe6DtskgTzUM9Yv; x-referer=eyJyIjoiL2hvbWUucGhwIiwiaCI6Ii9ob21lLnBocCIsInMiOiJtIn0%3D; m_pixel_ratio=2.0000000596046448; c_user=61551901135560; xs=19%3AbleOnVh1LZSrQQ%3A2%3A1695569747%3A-1%3A-1; fr=02vWgarKGFf2Vfo35.AWVtTcGpATqdanrsY76xDeOgJOs.BlD5x5.da.AAA.0.0.BlEFdT.AWWNPITFpjA; m_page_voice=61551901135560; locale=en_GB; fbl_cs=AhBoRvhMVvdYU2NpSGUbqAu4GEdaWUtzaFpVeWYrRzAyZ2lwWEd0QW91dA; fbl_ci=1018605369336211; presence=C%7B%22t3%22%3A%5B%5D%2C%22utc3%22%3A1695573189859%2C%22v%22%3A1%7D; wd=390x844; dpr=3; vpd=v1%3B1638x1114x2.0000000596046448; fbl_st=100422777%3BT%3A28259570; wl_cbv=v2%3Bclient_version%3A2328%3Btimestamp%3A1695574243"
        },
        "referrerPolicy": "strict-origin-when-cross-origin",
        "body": null,
        "method": "GET"
    });


    let z = await a.text()
    // console.log(z)
    const dom = new JSDOM(z);
    fs.writeFileSync("query.html", z)
    let div = dom.window.document.querySelector('div[data-pagelet="ProfileTilesFeed_0"]');
    if (div) {
        let about = {}
        about.intro = div.querySelector('div.xieb3on').firstElementChild.textContent
        let fields = div.querySelector('ul').childNodes

        for (let f of fields) {
            if (f.innerHTML.includes("XLGk7XTX1NS")) {
                about.category = f.textContent;
            }
            if (f.innerHTML.includes("V632KGZoHho")) {
                about.address = f.textContent;
            }
            if (f.innerHTML.includes("7KDVc3hw483")) {
                about.phone = f.textContent;
            }
            if (f.innerHTML.includes("W4m-1QXtJyK")) {
                about.email = f.textContent;
            }
            if (f.innerHTML.includes("DzX7o-tOmJ6")) {
                about.link = f.textContent;
            }
            if (f.innerHTML.includes("XLGk7XTX1NS")) {
                about.category = f.textContent;
            }
        }

        console.table(about)
    }


    if (div == null) {
        console.log("Mobile===================")
        div = dom.window.document.querySelector('#screen-root');
        console.log("Mobile DIV===================", JSON.stringify(div))
        if (!div) {
            return
        }
        let about = {}

        about.top = div.querySelector('#screen-root > div > div.m.fixed-container.top > div').textContent;
        about.name = div.querySelector('#screen-root > div > div:nth-child(2) > div:nth-child(3) > div:nth-child(6)').textContent
        about.like = div.querySelector("#screen-root > div > div:nth-child(2) > div:nth-child(3) > div:nth-child(7)").textContent
        about.follower = div.querySelector("#screen-root > div > div:nth-child(2) > div:nth-child(3) > div:nth-child(9)").textContent
        about.desc = div.querySelector("#screen-root > div > div:nth-child(2) > div:nth-child(3) > div.m.bg-s4").textContent
        for (let f of fields) {
            if (f.innerHTML.includes("XLGk7XTX1NS")) {
                about.category = f.textContent;
            }
            if (f.innerHTML.includes("V632KGZoHho")) {
                about.address = f.textContent;
            }
            if (f.innerHTML.includes("7KDVc3hw483")) {
                about.phone = f.textContent;
            }
            if (f.innerHTML.includes("W4m-1QXtJyK")) {
                about.email = f.textContent;
            }
            if (f.innerHTML.includes("DzX7o-tOmJ6")) {
                about.link = f.textContent;
            }
            if (f.innerHTML.includes("XLGk7XTX1NS")) {
                about.category = f.textContent;
            }
        }

        console.table(about)
    }
}

async function queryPage(page) {
    console.log("queryPage================================================")
    let last = Date.now();
    console.log("queryPage================================================",(pageid2.length > 0) || (Date.now() - last <= 60000),Date.now() - last)
    while ((pageid2.length > 0) || (Date.now() - last <= 60000)) {
        console.log("queryPage================================================" ,22)
        let pid = pageid2.shift()
        if (pid) {
            console.log("start queryPage", pid)
            await axiosId(page, pid);
            pagedone[pid] = pid;
            console.log("end queryPage", pid, (Date.now() - last) / 1000.0)
            last = Date.now();
        }
        console.log("Query =============",pid,pageid2.length)
        await wait(1000)
    }
}

async function axiosId(page, id) {
    console.log("Query ", id)
    await page.goto("https://mtouch.facebook.com/profile.php/?id=" + id + "&profile_tab_item_selected=about", {
        waitUntil: 'networkidle0',
        timeout: 60000
    });

    // await page.waitForNavigation({ waitUntil: 'domcontentloaded' })
    await wait(1000)
    // await page.screenshot({ path: "query.jpg" });
    let source = await page.content({ "waitUntil": "domcontentloaded" });

    // fs.writeFileSync("query.html", source)
    let div = page.$('#screen-root');
    if (!div) {
        return
    }
    let about = {}
    let f = async (select) => {
        let e = await page.$(select);
        if (e == null || e == undefined) return null;
        return await e.evaluate(e => { return e ? e.innerText : '' }, e)
    }

    let v = async (e) => {
        if (e == null || e == undefined) return null;
        return await e.evaluate(e => { return e ? e.innerText : '' }, e)
    }
    let next = async (e) => {
        return e ? await e.evaluateHandle(e => e ? e.nextElementSibling : null, e) : null
    }
    // about.top = (await f('#screen-root > div > div.m.fixed-container.top > div')).trim();

    let tdiv = await page.$('#screen-root > div > div:nth-child(2) > div:nth-child(3) > div[data-mcomponent="ServerTextArea"]');
    about.name = await v(tdiv);
    tdiv = await next(tdiv);
    if ((await v(tdiv)) && (await v(tdiv)).length == 0) {
        tdiv = await next(tdiv);
        tdiv = await next(tdiv);
    }
    about.like = (await v(tdiv)).split(' ')[0]
    tdiv = await next(tdiv);
    tdiv = await next(tdiv);
    about.follower = (await v(tdiv)).split(' ')[0]
    tdiv = await next(tdiv);
    tdiv = await next(tdiv);
    about.desc = await v(tdiv)
    let tdiva = await page.$$('#screen-root > div > div:nth-child(2) > div:nth-child(8) > div:nth-child(1) > div');
    for (let e of tdiva) {
        console.log("DIV NOW=> ", encodeURI(await v(e)))
    }

    let findDiv = async (a, text) => {
        for (let e of tdiva) {
            if (encodeURI(await v(e)).includes(text)) return decodeURI(encodeURI(await v(e)).slice(text.length)).trim();
        }
    }
    console.log("NNN", encodeURI('\n'))
    let keys = {
        category: '%F3%B1%9B%90%0A',
        phone: '%F3%B1%9B%AA%0A',
        add: '%F3%B1%A6%97%0A',
        link: '%F3%B1%A4%82%0A',
        email: '%F3%B1%98%A2%0A',
    }
    let pro = new Promise(resolve => {
        let c = 0;
        Object.keys(keys).forEach(async (k, i) => {
            let v = await findDiv(tdiva, keys[k])
            if (v) about[k] = v
            c++;
            if (c == Object.keys(keys).length) resolve()
        })
    })
    await pro;
    console.table(about)

}
// CometHovercardQueryRendererQuery(100092039206008)