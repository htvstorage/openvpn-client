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
let stat = { count: 0, countAll: 0 }
async function initBrowser(profileDir, pagescan) {

    const browser = await puppeteer.launch({
        headless: true, args: ['--user-data-dir=' + profileDir]
    });

    const page = await browser.newPage();
    const mobile = await browser.newPage();
    // if (pagescan == 0) {
    //     await mobile.setExtraHTTPHeaders({
    //         "User-Agent":
    //             "Mozilla/5.0 (iPhone; CPU iPhone OS 13_2_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.3 Mobile/15E148 Safari/604.1",
    //     })

    // }
    // await mobile.setViewport({ width: 390, height: 844 });
    await page.setRequestInterception(true);
    await mobile.setRequestInterception(true);
    let loadImage = {
        load: false, disable: {
            // 'font': 'font',
            'image': 'image',
            // 'manifest': 'manifest',
            // 'ping': 'ping',
            // 'stylesheet': 'stylesheet',
        }
    }
    page.on('request', request => {


        if (loadImage.disable[request.resourceType()]) {
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
        // console.log(request.resourceType())
        if (loadImage.disable[request.resourceType()]) {
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
                // console.log(text)
                if (text.includes('{"data":{"serpResponse":{"results":{"edges":[{"node":{"role":"ENTITY_PAGES","__typename":"SearchRenderable"}')) {
                    let datajs = JSON.parse(text);
                    let edges = datajs.data.serpResponse.results.edges
                    for (let e of edges) {
                        // await CometHovercardQueryRendererQuery(e.relay_rendering_strategy.view_model.profile.id)
                        // await axiosId(mobile, e.relay_rendering_strategy.view_model.profile.id)
                        let pid = { keyword: stat.keyword, id: e.relay_rendering_strategy.view_model.profile.id, name: e.relay_rendering_strategy.view_model.profile.name, province: stat.province }
                        if (!pageid[pid.id])
                            pageid[pid.id] = pid;
                        else {
                            pid['about'] = { ...pageid[pid.id]['about'] }
                            pageid[pid.id] = pid;
                        }
                        pageid2.push({ keyword: stat.keyword, id: pid.id, province: stat.province })
                        console.log(c++, Object.keys(pageid).length, e.relay_rendering_strategy.view_model.profile.id, e.relay_rendering_strategy.view_model.profile.name)
                        fs.appendFileSync("facebook/pageid.txt", JSON.stringify(pid) + '\n')
                        stat.total = Object.keys(pageid).length;
                        stat.count++;
                        stat.countAll++;
                    }

                } else {
                    if (text.includes('{"errors":[{"message":"Rate limit exceeded') || text.includes('been temporarily blocked')) {
                        console.log(text)
                    }
                }
            } catch (error) {
                console.log(error)
            }

        }
    });

    mobile.on('response', async (response) => {
        // console.log(await response.text())
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

async function loadPage() {
    if (!fs.existsSync("facebook/data.txt")) return {};
    let buffer = fs.readFileSync("facebook/data.txt", "utf-8")
    buffer = buffer.slice(0, buffer.length - 1);
    let data = buffer.split('\n')
        .map(e => e.trim()).map(e => JSON.parse(e));
    let d = {}
    data.forEach(e => {
        d[e.id] = e;
    })
    return d;
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
async function loadUser() {
    if (!fs.existsSync("facebook/user.txt")) return {};
    let buffer = fs.readFileSync("facebook/user.txt", "utf-8")
    // buffer = buffer.slice(0, buffer.length - 1);
    let data = buffer.split('\n')
        .map(e => e.trim()).filter(e => e.length > 0).map(e => JSON.parse(e));
    let d = {}
    data.forEach(e => {
        d[e.username] = e;
    })
    return Object.values(d);
}


async function loadPageId() {
    if (!fs.existsSync("facebook/pageid.txt")) return {};
    let buffer = fs.readFileSync("facebook/pageid.txt", "utf-8")
    buffer = buffer.slice(0, buffer.length - 1);
    let data = buffer.split('\n')
        .map(e => e.trim()).map(e => JSON.parse(e));
    let d = {}
    data.forEach(e => {
        d[e.id] = e;
    })
    return d;
}

async function loadProcess() {
    if (!fs.existsSync("facebook/process.json")) return { "fetch": 1, "query": 1, "fetch_max_tps": 10000, "query_max_tps": 0.3 };
    let buffer = fs.readFileSync("facebook/process.json", "utf-8")
    return JSON.parse(buffer);
}

keywords = await loadKeywords();
done = await loadDone();

function mkdirSyncRecursive(directoryPath) {
    const parts = directoryPath.split('/');

    for (let i = 1; i <= parts.length; i++) {
        const currentPath = parts.slice(0, i).join('/');
        if (!fs.existsSync(currentPath)) {
            fs.mkdirSync(currentPath);
        }
    }
}

const run = async () => {

    let args = process.argv.slice(2);
    let provinces = null;
    let indexUser = 0;
    if (args.length == 0) {
        provinces = ["Hà Giang", "Hà Nội", "Cao Bằng", "Bắc Kạn", "Tuyên Quang", "Lào Cai", "Điện Biên", "Lai Châu", "Sơn La", "Yên Bái", "Hoà Bình", "Thái Nguyên", "Lạng Sơn", "Quảng Ninh", "Bắc Giang", "Phú Thọ", "Vĩnh Phúc", "Bắc Ninh", "Hải Dương", "Hải Phòng", "Hưng Yên", "Thái Bình", "Hà Nam", "Nam Định", "Ninh Bình", "Thanh Hóa", "Nghệ An", "Hà Tĩnh", "Quảng Bình", "Quảng Trị", "Thừa Thiên Huế", "Đà Nẵng", "Quảng Nam", "Quảng Ngãi", "Bình Định", "Phú Yên", "Khánh Hòa", "Ninh Thuận", "Bình Thuận", "Kon Tum", "Gia Lai", "Đắk Lắk", "Đắk Nông", "Lâm Đồng", "Bình Phước", "Tây Ninh", "Bình Dương", "Đồng Nai", "Bà Rịa - Vũng Tàu", "Hồ Chí Minh", "Long An", "Tiền Giang", "Bến Tre", "Trà Vinh", "Vĩnh Long", "Đồng Tháp", "An Giang", "Kiên Giang", "Cần Thơ", "Hậu Giang", "Sóc Trăng", "Bạc Liêu", "Cà Mau"]
        indexUser = 0;
    } else if (args.length == 1) {
        indexUser = +args[0];
        provinces = ["Hà Giang", "Hà Nội", "Cao Bằng", "Bắc Kạn", "Tuyên Quang", "Lào Cai", "Điện Biên", "Lai Châu", "Sơn La", "Yên Bái", "Hoà Bình", "Thái Nguyên", "Lạng Sơn", "Quảng Ninh", "Bắc Giang", "Phú Thọ", "Vĩnh Phúc", "Bắc Ninh", "Hải Dương", "Hải Phòng", "Hưng Yên", "Thái Bình", "Hà Nam", "Nam Định", "Ninh Bình", "Thanh Hóa", "Nghệ An", "Hà Tĩnh", "Quảng Bình", "Quảng Trị", "Thừa Thiên Huế", "Đà Nẵng", "Quảng Nam", "Quảng Ngãi", "Bình Định", "Phú Yên", "Khánh Hòa", "Ninh Thuận", "Bình Thuận", "Kon Tum", "Gia Lai", "Đắk Lắk", "Đắk Nông", "Lâm Đồng", "Bình Phước", "Tây Ninh", "Bình Dương", "Đồng Nai", "Bà Rịa - Vũng Tàu", "Hồ Chí Minh", "Long An", "Tiền Giang", "Bến Tre", "Trà Vinh", "Vĩnh Long", "Đồng Tháp", "An Giang", "Kiên Giang", "Cần Thơ", "Hậu Giang", "Sóc Trăng", "Bạc Liêu", "Cà Mau"]
    } else {
        indexUser = +args[0];
        provinces = loadProvince(args[1]);
    }

    let cfg = await loadProcess();

    let location = await loadLocation();
    let users = await loadUser();
    let pageData = await loadPage();
    let pageIdData = await loadPageId();
    Object.keys(pageData).forEach(k => {
        let data = pageData[k]
        data['about'] = { ...data }
        pageid[k] = data;
        pagedone[k] = k;
    })

    console.log("Page done")
    // console.table(pagedone)
    // console.table(pageid)
    console.log("Loaded page data total:", Object.keys(pageData).length)

    Object.keys(pageIdData).forEach(k => {
        let data = pageIdData[k]

        if (!pageData[k])
            pageid2.push({ keyword: data.keyword, id: data.id })
        if (!pageid[k])
            pageid[k] = data;
    })

    console.log("Loaded pageid 2 total:", pageid2.length)

    // console.table(location)


    let user = users[indexUser];
    mkdirSyncRecursive("facebook/out")
    mkdirSyncRecursive("facebook/profile")
    console.log("profile", "./facebook/profile/" + user.email.slice(0, user.email.indexOf('@')))
    let [browser, page, mobile] = await initBrowser("./facebook/profile/" + user.email.slice(0, user.email.indexOf('@')), cfg.pagescan);
    // let [browser, page, mobile] = await initBrowser("./userdata9");        

    await page.setViewport({ width: 1920, height: 1000 });
    await page.goto("https://www.facebook.com/", {
        waitUntil: 'domcontentloaded',
        timeout: 60000
    });



    await wait(2000)
    await page.screenshot({ path: "before-login.jpg" });
    if (await page.$('#email'))
        await page.type("#email", user.email);
    // await page.type("#email", 'hungtvalbum@gmail.com');
    if (await page.$('#pass'))
        await page.type("#pass", user.password);
    if (await page.$('#loginbutton'))
        await page.click("#loginbutton");
    if (await page.$('button[name="login"]')) {
        console.log("Login")
        await page.click('button[name="login"]');
    }


    let source1 = await page.content({ "waitUntil": "domcontentloaded" });

    await wait(2000)
    // await mobile.setViewport({ width: 1920, height: 1000 });
    await mobile.setViewport({ width: 390, height: 844 });
    await mobile.goto("https://mtouch.facebook.com/", {
        waitUntil: 'domcontentloaded',
        timeout: 60000
    });
    await wait(2000)
    await mobile.screenshot({ path: "mobile-init.jpg" });
    // await axiosId(mobile, 211653718883582) //test lai

    // await axiosId(mobile, 100069572883858)
    // await axiosId(mobile, 115806726641456)
    // await axiosId(mobile, 115806726641456)
    // await axiosId(mobile, 100066500112707)
    // await axiosId(mobile, 100050174962984)

    // await axiosId2(mobile, 100068333149695)
    // 100063522644002
    // await axiosId2(mobile, 100063522644002)
    await axiosId2(mobile, 119944931693126)

    // 100050174962984
    // 100063490543470
    // // if (true) return;
    // queryPage(mobile)
    let pquery = null;
    let pfetch = null;

    if (cfg.query > 0) {
        pquery = queryPage(mobile, cfg.mode, cfg.remain, cfg.query_max_tps)
        // pquery = queryPage(page, cfg.mode, cfg.remain, cfg.query_max_tps)
    }
    console.log("page.viewport.height", page.viewport().height)
    if (page.viewport().height < 10000) {
        console.log("after-login.jpg")
        await page.screenshot({ path: "after-login.jpg" });
    }

    let fetchPageId = async () => {

        for (let province of provinces) {
            try {
                for (let keyword of keywords) {
                    if (done[keyword + " " + province]) {
                        console.log("Skip for done ", keyword, province)
                        continue;
                    }
                    stat.keyword = keyword;
                    stat.province = province;
                    let kuri = encodeURI(keyword);
                    let url = location[province].filter.replaceAll("Cua%20hang", kuri);
                    console.log(url)
                    await page.goto(url, {
                        waitUntil: 'domcontentloaded',
                        timeout: 60000
                    });

                    // await wait(5000)
                    if (page.viewport().height < 10000) {
                        await page.screenshot({ path: removeDiacriticsAndSpaces(keyword) + "_" + "after-login.jpg" });
                    }
                    let last = Date.now();
                    let i = 0;
                    let lastCount = 0;
                    let fetch_tps;
                    let start = Date.now() - 1;

                    while (true) {
                        i++;
                        await wait(1000)
                        console.log("Load more ....", i, lastCount, stat)
                        fetch_tps = stat.countAll * 1000.0 / (Date.now() - start)
                        while (fetch_tps > cfg.fetch_max_tps) {
                            console.log("Over fetch_max_tps", i, fetch_tps, stat)
                            await wait(1000)
                            fetch_tps = stat.countAll * 1000.0 / (Date.now() - start);
                        }
                        if (lastCount < stat.count) {
                            lastCount = stat.count
                            last = Date.now();
                        }
                        if ((Date.now() - last >= 20000) || (stat.count == 0 && Date.now() - last >= 10000)) {
                            console.log("Done load ", keyword, province)
                            done[keyword + " " + province] = keyword + " " + province
                            stat = { count: 0, countAll: stat.countAll }
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
    }

    if (cfg.fetch > 0) {
        pfetch = fetchPageId();
    }

    if (pquery) {
        await pquery;
    }
    if (pfetch) {
        await pfetch;
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

async function queryPage(page, mode, remain, query_max_tps) {
    console.log("queryPage================================================")
    let last = Date.now();
    console.log("queryPage================================================", (pageid2.length > 0) || (Date.now() - last <= 60000), Date.now() - last)


    // let pid = { keyword: stat.keyword, id: e.relay_rendering_strategy.view_model.profile.id, name: e.relay_rendering_strategy.view_model.profile.name }
    // pageid[pid.id] = pid;
    // pageid2.push(pid.id)

    let start = Date.now() - 1;
    let count = 0;

    while ((pageid2.length > 0) || (Date.now() - last <= 60000)) {
        console.log("queryPage================================================", 22)
        let pid = pageid2.shift()

        if (pid) {
            if (+pid.id % mode != remain) {
                console.log("Ignore ", pid, mode, remain, +pid.id % mode)
                continue;
            }
        }

        while (count * 1000.0 / (Date.now() - start) > query_max_tps) {
            await wait(200)
        }
        if (pid && !pagedone[pid.id]) {
            console.log("start queryPage", pid)
            let data = await axiosId2(page, pid.id);
            count++;
            let p = pageid[pid.id]
            p['about'] = data;
            data.name2 = p.name;
            data.province = p.province;

            fs.appendFileSync("facebook/out/" + removeDiacriticsAndSpaces(pid.keyword) + ".txt", JSON.stringify(data) + '\n')
            fs.appendFileSync("facebook/data.txt", JSON.stringify(data) + '\n')
            pagedone[pid.id] = pid.id;
            console.log("end queryPage", pid, (Date.now() - last) / 1000.0)
            last = Date.now();
        } else {
            console.log("Already done! =============", pid, pageid2.length)
            if (pid && pagedone[pid.id]) {

                let p = pageid[pid.id]
                let data = { ...p['about'] }
                // console.table(pageid)
                console.log(p, pagedone[pid.id], data)
                data.name2 = p.name;
                data.province = p.province;
                fs.appendFileSync("facebook/out/" + removeDiacriticsAndSpaces(pid.keyword) + ".txt", JSON.stringify(data) + '\n')
            }
        }
        if (!pid) {
            await wait(2000);
        }
    }
}

async function axiosId2(page, id) {
    console.log("Query ", id)
    await page.goto("https://www.facebook.com/profile.php/?id=" + id + "&sk=about", {
        waitUntil: 'networkidle0',
        timeout: 60000
    });
    let about = {}
    about.id = id;
    // await page.waitForNavigation({ waitUntil: 'domcontentloaded' })
    // await wait(1000)
    await page.screenshot({ path: "query.jpg" });
    let source = await page.content({ "waitUntil": "domcontentloaded" });
    let scripts = await page.$$('script')
    fs.writeFileSync("query.html", source)
    let v = async (e) => {
        if (e == null || e == undefined) return null;
        return await e.evaluate(e => { return e ? e.innerHTML : '' }, e)
    }
    // let 
    let data = null;
    let head = null;
    let pageData = null;
    let pro = new Promise(resolve => {
        scripts.forEach(async (s, i) => {
            let text = await v(s)
            if (text.includes('"field_section_type":"category"')) {
                data = text;
            }
            if (text.includes('page_about_fields') && text.includes('comet_page_cards')) {
                pageData = text;
            }
            if (text.includes('profile_header_renderer') &&
                text.includes('likes') &&
                text.includes('followers')
            ) {
                head = text;
            }
            if ((data && head) || i == scripts.length - 1) {
                resolve({ data: data, head: head })
            }
        })
    });
    await pro;

    if(pageData){
        let datajson = JSON.parse(pageData);
        let relayData = null;
        datajson.require[0][3][0].__bbox.require.forEach(e => {
            if (e[0] == 'RelayPrefetchedStreamCache') {
                relayData = e;
            }
        })
 
        if (!relayData) {
            console.log(data)
            return about;
        }
    
        if ((!relayData[3][1].__bbox ||
            !relayData[3][1].__bbox.result.data.page)) {
            console.log(data)
            return about;
        }
        let pageInfo = relayData[3][1].__bbox.result.data.page.comet_page_cards[0].page;
        about.name = pageInfo.name
        about.followers = pageInfo.follower_count
        if(pageInfo.page_about_fields.formatted_phone_number)
            about.profile_phone = pageInfo.page_about_fields.formatted_phone_number
        about.address = pageInfo.page_about_fields.address.full_address
        about.likes = pageInfo.page_likers.global_likers_count
        about.checkin = pageInfo.were_here_count
        console.table(about)

    }

    if (!data) {
        console.log("data",data)
        return about;
    }
    //
    // let map = '{"require":[["ScheduledServerJS","handle",null,[{"__bbox":{"define":[["TilesMapConfig"'
    // let idx = source.indexOf(map);
    // let idx2 = source.indexOf("</script>",idx);
    // if(idx <= 0 || idx2 <= 0){
    //     return about;
    // }
    // let data = source.slice(idx,idx2)
    // console.log("data", data)
    let datajson = JSON.parse(data);
    // console.log(data)
    // console.log(datajson.require[0][3][0].__bbox.require[7][3][1].__bbox.result.data.user.id)
    //require[0][3][0].__bbox.require[5][3][1].__bbox.result.data.user.about_app_sections.nodes[0].activeCollections.nodes[0].style_renderer.profile_field_sections[0].field_section_type
    let relayData = null;
    datajson.require[0][3][0].__bbox.require.forEach(e => {
        if (e[0] == 'RelayPrefetchedStreamCache') {
            relayData = e;
        }
    })

    if (!relayData) {
        console.log(data)
        return about;
    }

    if ((!relayData[3][1].__bbox ||
        !relayData[3][1].__bbox.result.data.user)) {
        console.log(data)
        return about;
    }

    let profile_field_sections = relayData[3][1].__bbox.result.data.user.about_app_sections.nodes[0].activeCollections.nodes[0].style_renderer.profile_field_sections;

    profile_field_sections.forEach(p => {
        if (p.field_section_type == "category")
            about.category = p.profile_fields.nodes[0].title.text;
        if (p.field_section_type == "about_contact_info") {
            let address = p.profile_fields.nodes;
            address.forEach(e => {
                about[e.field_type] = e.title.text;
            })
        }
        if (p.field_section_type == "websites_and_social_links") {
            let address = p.profile_fields.nodes;
            address.forEach(e => {
                about[e.field_type] = e.title.text;
            })
        }
    })
    console.table(about)
    //Head

    datajson = JSON.parse(head);
    if (!head || !datajson) {
        return about;
    }
    datajson.require[0][3][0].__bbox.require.forEach(e => {
        if (e[0] == 'RelayPrefetchedStreamCache') {
            relayData = e;
        }
    })
    if (!relayData) {
        console.log(head)
        return about;
    }


    if ((!relayData[3][1].__bbox ||
        !relayData[3][1].__bbox.result.data.user)) {
        console.log(head)
        return about;
    }
    about.name = relayData[3][1].__bbox.result.data.user.profile_header_renderer.user.name;

    profile_field_sections = relayData[3][1].__bbox.result.data.user.profile_header_renderer.user.profile_social_context.content
    // require[0][3][0].__bbox.require[7][3][1].__bbox.result.data.user.profile_header_renderer.user.profile_social_context.content[0].text.text
    profile_field_sections.forEach(p => {
        if (p.uri.includes('like'))
            about.likes = p.text.text;
        if (p.uri.includes('followers')) {
            about.followers = p.text.text;
        }

    })
    console.table(about)
    // let websitelink = 
    return about;

}

async function axiosId(page, id) {
    console.log("Query ", id)
    await page.goto("https://m.facebook.com/profile.php/?id=" + id + "&profile_tab_item_selected=about", {
        waitUntil: 'networkidle0',
        timeout: 60000
    });
    // await page.reload({ waitUntil: ["networkidle0", "domcontentloaded"] });
    // await page.waitForNavigation({ waitUntil: 'domcontentloaded' })
    await wait(1000)
    await page.screenshot({ path: "query.jpg" });
    let source = await page.content({ "waitUntil": "domcontentloaded" });

    fs.writeFileSync("query.html", source)
    let div = page.$('#screen-root');
    let about = {}

    if (!div) {
        return about
    }
    about.id = id;
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
    // let tdiv = await page.$('#screen-root > div > div:nth-child(2) > div:nth-child(3) > div[data-mcomponent="ServerTextArea"]');    
    let tdivs = await page.$$('#screen-root > div > div:nth-child(2) > div')
    //c == Object.keys(keys).length)
    let tdiv = null;
    let divDetail = null;
    // console.log(tdivs)
    let c = 0;
    for (let d of tdivs) {
        let x = await v(d)
        if (tdiv == null) {
            if (x.toLocaleLowerCase().includes("likes") || x.toLocaleLowerCase().includes("thích") || x.toLocaleLowerCase().includes("follower") || x.toLocaleLowerCase().includes("theo dõi")) {
                tdiv = await d.$$('div > div[data-mcomponent="ServerTextArea"]')
                console.log("Found ", tdiv, x)
            }
        }
        // console.log(c++, encodeURI(x))
        if (encodeURI(x).includes('%F3%B1%9B%90%0A') || encodeURI(x).includes('%F3%B0%9B%AA%0A') || encodeURI(x).includes('%F3%B1%9B%90%0A')) {
            //
            console.log("===================================================================", "detail")
            divDetail = d;
        }
    }

    if (!tdiv) {
        console.log("Not found div includes likes!")
    }
    if (tdiv) {
        about.name = await v(tdiv[0]);
        // tdiv = await next(tdiv);
        // if ((await v(tdiv)) && (await v(tdiv)).length == 0) {
        //     tdiv = await next(tdiv);
        //     tdiv = await next(tdiv);
        // }
        // let t = null;
        // t = (await v(tdiv))

        // about.like = (t = await v(tdiv)) ? t.split(' ')[0] : ''
        // tdiv = await next(tdiv);
        // tdiv = await next(tdiv);
        // about.follower = (t = await v(tdiv)) ? t.split(' ')[0] : ''
        // tdiv = await next(tdiv);
        // tdiv = await next(tdiv);
        for (let e of tdiv) {
            let x = await v(e)
            if (x.toLocaleLowerCase().includes("likes") || x.toLocaleLowerCase().includes("thích") || x.toLocaleLowerCase().includes("follower") || x.toLocaleLowerCase().includes("theo dõi")) {
                let k = 'likes'
                if (x.indexOf(k) > 0) {
                    about[k] = x.slice(0, x.indexOf(k))
                    let f = 'followers'
                    if (x.indexOf(f) > 0) {
                        about[f] = x.slice(x.indexOf(k) + k.length, x.indexOf(f))
                    }
                } else {
                    let f = 'followers'
                    if (x.indexOf(f) > 0) {
                        about[f] = x.slice(0, x.indexOf(f))
                    }
                }



            }
        }

        about.desc = await v(tdiv.at(-1))
    }

    // let tdiva = await page.$$('#screen-root > div > div:nth-child(2) > div:nth-child(8) > div:nth-child(1) > div');
    // tdivs = await divDetail.$$('div > div')
    // c=0
    // for(let d of tdivs){         
    //     let x = await v(d)        
    //     console.log(c++,encodeURI(x))
    //     if(encodeURI(x).includes('%F3%B1%9B%90%0A')){
    //         console.log("===================================================================","detail")
    //         divDetail = d;
    //     }
    // }
    if (!divDetail) {
        return about
    }
    let tdiva = await divDetail.$$('div div div[data-mcomponent="MContainer"]')

    for (let e of tdiva) {
        // console.log("DIV NOW=> ", encodeURI(await v(e)),await v(e))
    }
    let findDiv = async (a, text) => {
        for (let e of a) {
            if (encodeURI(await v(e)).includes(text)) return decodeURI(encodeURI(await v(e)).slice(text.length)).trim();
        }
    }

    let keys = {
        category: '%F3%B1%9B%90%0A',
        phone: '%F3%B1%9B%AA%0A',
        add: '%F3%B1%A6%97%0A',
        link: '%F3%B1%A4%82%0A',
        email: '%F3%B1%98%A2%0A',
    }
    let keys2 = {
        category: '%F3%B0%9E%B4%0A',
        phone: '%F3%B0%9B%AA%0A',
        add: '%F3%B1%A6%97%0A',
        link: '%F3%B0%98%96%0A',
        email: '%F3%B1%98%A2%0A',
    }
    // let tdiva2 = await divDetail.$$('div.m.bg-s3.displayed div.m.bg-s3 div.m.bg-s3[data-mcomponent="MContainer"]')
    let tdiva2 = await divDetail.$$('div div div[data-mcomponent="MContainer"]')
    tdiva2 = tdiva2
    let c2 = 0;
    for (let e of tdiva2) {
        // console.log("DIV NOW=> ", c2++, encodeURI(await v(e)), await v(e))
    }
    let pro = new Promise(resolve => {
        let c = 0;
        Object.keys(keys).forEach(async (k, i) => {
            let v = await findDiv(tdiva, keys[k])
            if (v) about[k] = v
            c++;
            if (c == Object.keys(keys).length) resolve()
        })
        if (!about.category && c == Object.keys(keys).length) {
            c = 0;
            Object.keys(keys2).forEach(async (k, i) => {
                let v = await findDiv(tdiva2, keys2[k])
                if (v) about[k] = v
                c++;
                if (c == Object.keys(keys2).length) resolve()
            })
        }
    })
    await pro;
    console.table(about)
    return about;

}
// CometHovercardQueryRendererQuery(100092039206008)

function removeDiacriticsAndSpaces(inputString) {
    const diacriticsMap = {
        'à': 'a', 'á': 'a', 'ả': 'a', 'ã': 'a', 'ạ': 'a',
        'â': 'a', 'ầ': 'a', 'ấ': 'a', 'ẩ': 'a', 'ẫ': 'a', 'ậ': 'a',
        'ă': 'a', 'ằ': 'a', 'ắ': 'a', 'ẳ': 'a', 'ẵ': 'a', 'ặ': 'a',
        'è': 'e', 'é': 'e', 'ẻ': 'e', 'ẽ': 'e', 'ẹ': 'e',
        'ê': 'e', 'ề': 'e', 'ế': 'e', 'ể': 'e', 'ễ': 'e', 'ệ': 'e',
        'đ': 'd',
        'ì': 'i', 'í': 'i', 'ỉ': 'i', 'ĩ': 'i', 'ị': 'i',
        'ò': 'o', 'ó': 'o', 'ỏ': 'o', 'õ': 'o', 'ọ': 'o',
        'ô': 'o', 'ồ': 'o', 'ố': 'o', 'ổ': 'o', 'ỗ': 'o', 'ộ': 'o',
        'ơ': 'o', 'ờ': 'o', 'ớ': 'o', 'ở': 'o', 'ỡ': 'o', 'ợ': 'o',
        'ù': 'u', 'ú': 'u', 'ủ': 'u', 'ũ': 'u', 'ụ': 'u',
        'ư': 'u', 'ừ': 'u', 'ứ': 'u', 'ử': 'u', 'ữ': 'u', 'ự': 'u',
        'ỳ': 'y', 'ý': 'y', 'ỷ': 'y', 'ỹ': 'y', 'ỵ': 'y',
    };

    let cleanedString = '';
    for (let i = 0; i < inputString.length; i++) {
        const char = inputString[i];
        if (diacriticsMap[char]) {
            cleanedString += diacriticsMap[char];
        } else if (char === ' ') {
            cleanedString += '_';
        } else if (/^[a-zA-Z0-9_]+$/.test(char)) {
            cleanedString += char;
        }
    }

    return cleanedString;
}