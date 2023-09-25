import fs from "fs"
import { Exchange } from './Exchange.js';
import puppeteer from "puppeteer";
import request_client from 'request-promise-native'
import jsdom from "jsdom"
const { JSDOM } = jsdom;
//sudo apt update; sudo apt-get install -y libatk-bridge2.0-0 libgtk-3.0 libasound2 libgbm-dev
(async () => {
    // let listSymbol = await Exchange.getlistallsymbol()
    // listSymbol = listSymbol.filter(e => e.length == 3);
    // let stockdata = {}
    // let z = await Exchange.getliststockdata(listSymbol, stockdata);

    // console.table(stockdata['SHS'])
    // console.table(stockdata['NVL'])
    // console.table(stockdata['VGI'])
    // await Exchange.SSI.getlistallsymbol()

    // // console.log(Date.now())
    // console.log("Data")
    // // let data = await Exchange.SSI.graphql("NVL")
    // let data = await Exchange.SSI.graphql("NVL")
    // console.log("End")
    // console.table(data.data.slice(0,10))
    // data = await Exchange.CafeF.DataHistory("NVL")
    // console.table(data.data.slice(0,10))

    //    let jsdata= fs.readFileSync("googlemaps/spa.json","utf-8")
    //    let adata = JSON.parse(jsdata);
    //    console.table(adata)
    //    console.table(adata.length)




})();

let pageid = [];

const run = async () => {

    let provinces = ["Hà Nội", "Hà Giang", "Cao Bằng", "Bắc Kạn", "Tuyên Quang", "Lào Cai", "Điện Biên", "Lai Châu", "Sơn La", "Yên Bái", "Hoà Bình", "Thái Nguyên", "Lạng Sơn", "Quảng Ninh", "Bắc Giang", "Phú Thọ", "Vĩnh Phúc", "Bắc Ninh", "Hải Dương", "Hải Phòng", "Hưng Yên", "Thái Bình", "Hà Nam", "Nam Định", "Ninh Bình", "Thanh Hóa", "Nghệ An", "Hà Tĩnh", "Quảng Bình", "Quảng Trị", "Thừa Thiên Huế", "Đà Nẵng", "Quảng Nam", "Quảng Ngãi", "Bình Định", "Phú Yên", "Khánh Hòa", "Ninh Thuận", "Bình Thuận", "Kon Tum", "Gia Lai", "Đắk Lắk", "Đắk Nông", "Lâm Đồng", "Bình Phước", "Tây Ninh", "Bình Dương", "Đồng Nai", "Bà Rịa - Vũng Tàu", "Hồ Chí Minh", "Long An", "Tiền Giang", "Bến Tre", "Trà Vinh", "Vĩnh Long", "Đồng Tháp", "An Giang", "Kiên Giang", "Cần Thơ", "Hậu Giang", "Sóc Trăng", "Bạc Liêu", "Cà Mau"]
    const browser = await puppeteer.launch({
        headless: true, args: ['--user-data-dir=./userdata6']
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
            else{
                // console.log('abort')
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
                    // console.error(error);
                    // console.log("error", request.url(), "\n", request.headers(), "\n", request.postData(), "\n")

                    if (request.postData().includes("CometHovercardQueryRendererQuery")) {
                        console.log("error", request.url(), "\n", request.headers(), "\n", request.postData(), "\n")
                    }
                    request.continue();
                    // request.abort();
                });
            } else {
                request.continue();
            }
        }
    });

    mobile.on('request', request => {
        // console.log("request.resourceType()", request.resourceType())
        if (request.resourceType() == 'image') {
            if (loadImage.load)
                request.continue()
            else{
                // console.log('abort')
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
                    // console.error(error);
                    // console.log("error", request.url(), "\n", request.headers(), "\n", request.postData(), "\n")

                    if (request.postData().includes("CometHovercardQueryRendererQuery")) {
                        console.log("error", request.url(), "\n", request.headers(), "\n", request.postData(), "\n")
                    }
                    request.continue();
                    // request.abort();
                });
            } else {
                request.continue();
            }
        }
    });

    let c = 0;
    page.on('response', async (response) => {
        if (response.url().includes("graphql")) {
            let text = await response.text();
            if (text.includes('{"data":{"serpResponse":{"results":{"edges":[{"node":{"role":"ENTITY_PAGES","__typename":"SearchRenderable"}')) {
                let datajs = JSON.parse(text);
                let edges = datajs.data.serpResponse.results.edges
                for (let e of edges) {
                    // await CometHovercardQueryRendererQuery(e.relay_rendering_strategy.view_model.profile.id)
                    // await axiosId(mobile, e.relay_rendering_strategy.view_model.profile.id)
                    pageid.push(e.relay_rendering_strategy.view_model.profile.id)
                    console.log(c++, pageid.length, e.relay_rendering_strategy.view_model.profile.id, e.relay_rendering_strategy.view_model.profile.name)
                }

            }
            // console.log(response.url(), '\n', text.slice(0, 200));
        }
    });

    mobile.on('response', async (response) => {
        // console.log(response.url())
    });

    // await axiosId(mobile, 100070844978150)
    // await axiosId(mobile, 100085949237392)
    // await axiosId(mobile, 100063976845361)
    // await axiosId(mobile, 61550339098784)
    // await axiosId(mobile, 100063547931773)
    
    // await axiosId(mobile, 100081861570696)
    // await axiosId(mobile, 211653718883582) //test lai
    
    // queryPage(mobile)
    // await wait(60000)

    // if(true) return;


    await page.setViewport({ width: 1920, height: 2000 });
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

    fs.writeFileSync("source.txt", source1)
    const toSaveCookies = await page.cookies();
    console.log(toSaveCookies)
    fs.writeFileSync("./cookies.json", JSON.stringify(toSaveCookies, null, 2));
    // await page.waitForNavigation();
    await wait(5000)
    await page.screenshot({ path: "after-login.jpg" });
    let searchclass = "input.x1i10hfl.xggy1nq.x1s07b3s.x1kdt53j.x1yc453h.xhb22t3.xb5gni.xcj1dhv.x2s2ed0.xq33zhf.xjyslct.xjbqb8w.xnwf7zb.x40j3uw.x1s7lred.x15gyhx8.x972fbf.xcfux6l.x1qhh985.xm0m39n.x9f619.xzsf02u.xdl72j9.x1iyjqo2.xs83m0k.xjb2p0i.x6prxxf.xeuugli.x1a2a7pz.x1n2onr6.x15h3p50.xm7lytj.x1sxyh0.xdvlbce.xurb0ha.x1vqgdyp.x1xtgk1k.x17hph69.xo6swyp.x1ad04t7.x1glnyev.x1ix68h3.x19gujb8";
    await page.waitForSelector('input[aria-label="Search Facebook"]');
    await page.focus('input[aria-label="Search Facebook"]')
    await page.click('input[aria-label="Search Facebook"]');
    // await page.type('input[aria-label="Search Facebook"]',"Cua hang\n")
    await page.keyboard.type('spa a\n');
    await page.focus('span[class="xhb22t3 xb5gni xcj1dhv x6s0dn4 x78zum5 xuxw1ft x47corl x1ye3gou"]')
    await page.keyboard.press('\n');
    await page.waitForNavigation({ waitUntil: 'networkidle0' })
    await wait(5000)
    let list = await page.$$('div[role="listitem"]');
    console.log(await list[3].getProperty('textContent'))
    const text = await (await list[3].getProperty('textContent')).jsonValue()
    console.log("Text is: " + text)
    let link = await list[6].$('a[role="link"]');
    // await link.evaluate(b => b.click());
    console.log(page.url());
    // console.log( 'Clicking on: ', await page.evaluate( el => el.href, link ) );
    await link.click();  // OK
    // await link.evaluate(b => b.click());

    // page.click()
    // await list[3].click();
    await page.waitForSelector('input[aria-label="Location"][role="combobox"]')
    await page.$('input[aria-label="Location"][role="combobox"]')
    await page.focus('input[aria-label="Location"][role="combobox"]')
    await page.click('input[aria-label="Location"][role="combobox"]');

    await page.keyboard.type('Ho Chi Minh', { delay: 2000 });

    // await page.keyboard.press('\n');
    // await page.waitForNavigation({ waitUntil: 'networkidle0' })
    console.log(page.url());
    // await wait(5000)
    await page.waitForSelector('ul[aria-label="5 suggested searches"][role="listbox"]')
    list = await page.$('ul[aria-label="5 suggested searches"][role="listbox"]');
    let option = await list.$('li[role="option"]')
    await option.click()
    await wait(5000)
    queryPage(mobile)
    console.log(page.url());
    console.log("Start move move")
    list = await page.$$('div[role="article"]');
    console.log(list.length)


    const rect = await page.evaluate(el => {
        const { x, y } = el.getBoundingClientRect();
        return { x, y };
    }, list[0]);

    await page.mouse.move(rect.x + 25, rect.y + 25)
    await wait(5000)
    await page.screenshot({ path: "after-move.jpg" });

    await wait(5000000)
    // for(let i=0;i<500000;i++){
    //     await wait(5000)
    //     await page.evaluate('window.scrollTo(0, document.body.scrollHeight)')
    // }

    // await page.waitForNavigation({ waitUntil: 'networkidle0' })
    // await page.click('a[aria-current="page"]')
    // await page.waitForNavigation({ waitUntil: 'networkidle0' })
    // await page.screenshot({ path: "after-login.jpg" });

    let source = await page.content({ "waitUntil": "domcontentloaded" });

    fs.writeFileSync("source.txt", source)

    const cookies = JSON.parse(fs.readFileSync("./cookies.json"));
    const context = await browser.createIncognitoBrowserContext();
    const page2 = await context.newPage();
    console.table(cookies)
    await page2.setCookie(...cookies);

    // for (let cookie of cookies) {
    //     await page2.setCookie({
    //         'name': cookie.name,
    //         'value': cookie.value,
    //         'domain': cookie.domain
    //     })
    // }
    console.table(await page2.cookies('.facebook.com'))

    await page2.goto("https://www.facebook.com", {
        waitUntil: "networkidle2",
    });
    // await page2.screenshot({ path: "login-using-cookies.jpg" });
    // await browser.close();
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

// {
//     'sec-ch-ua': '',
//     'sec-ch-ua-mobile': '?0',
//     'user-agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/105.0.5173.0 Safari/537.36',
//     'x-fb-friendly-name': 'CometHovercardQueryRendererQuery',
//     'x-fb-lsd': 'OgD-6UJT1qT5XjAqWrl4im',
//     referer: 'https://www.facebook.com/search/pages?q=spa%20a&filters=eyJmaWx0ZXJfcGFnZXNfbG9jYXRpb246MCI6IntcIm5hbWVcIjpcImZpbHRlcl9wYWdlc19sb2NhdGlvblwiLFwiYXJnc1wiOlwiMTA4NDU4NzY5MTg0NDk1XCJ9In0%3D',
//     'x-asbd-id': '129477',
//     'content-type': 'application/x-www-form-urlencoded',
//     'sec-ch-ua-platform': '',
//     accept: '*/*',
//     cookie: 'sb=-WwKZXB4C5TTItn_PoQFswQl; datr=-WwKZaec5A6gix74GmdJ51EB; c_user=61551414121483; wd=1920x2000; xs=47%3Ak-bz1Hxa0kiNLQ%3A2%3A1695182074%3A-1%3A-1%3A%3AAcUzlSEZIdUCh5chSjlEUlkkbo6AuRGTN4w5K4fP1Oc; fr=0173QcFiWpvbhkwhR.AWU_JtXCzMCTqjfjPtcGGhPrLx8.BlDWvc.tR.AAA.0.0.BlDW3J.AWUKUBk5cq4; presence=C%7B%22t3%22%3A%5B%5D%2C%22utc3%22%3A1695378893438%2C%22v%22%3A1%7D',
//     origin: 'https://www.facebook.com'
//   } 

// av=61551414121483&__user=61551414121483&__a=1&__req=1s&__hs=19622.HYP%3Acomet_pkg.2.1..2.1&dpr=1&__ccg=EXCELLENT&__rev=1008798983&__s=0dabim%3Akqb6j0%3Aain1ac&__hsi=7281596883066485181&__dyn=7AzHK4HzEmwIxt0mUyEqxenFwLBwopU98nwgUao4u5QdwSxucyUco5S3O2Saw8i2S1DwUx60DUG1sw9u0LVEtwMw65xO2OU7m2210wEwgolzUO0-E4a3a4oaEnxO0Bo7O2l2Utwwwi831wiE567Udo5qfK0zEkxe2GewyDwkUtxGm2SUbElxm3y3aexfxmu3W3rwxwjFovUy2a1ywtUuBwFKq2-azqwqo4i223908O3216xi4UdUcojxK2B0oobo8oC1hxB0qo4e16wWw&__csr=gpPggsysaEAsxl8ox44dFPFNlFNuOn9qkIAQigkB-IzyeAIxiVn8rXiFEHp2a9nGVuRJfRBApAnjCCl5XWh9VVFQ4uZdp8ICQS8-qlQc_Gii8ABVpeAaJbG48KA4rGeiK4EWloyUR3FE8Xx-5WGQl0xyEDzo-mES9ByoOczryWgnwPy_J1G8K22dz8S78C2mfyVk58izE76EpzoGUkwCy-exG22F8iwzxuK222G2Wdwg9UfE5a3W4EkxKq3ObxC48b8fUmxa2mawoo2iwtoW4U0zq05eU2Vw7hovwKxe4E9U0dEE0vqCw1pfwWw0sFE0f3Q0m60Mo0JC0r1oduE30wfG0iC3e0fhwAgbV80hFS02qC06Fy07VyU5u3G0dCwAw0J7w8B01bq3K0csw4opk8yowjU2aU3zw6rwqm1Hw2wA&__comet_req=15&fb_dtsg=NAcOPUL1aXHnXO68Q0EGnhldG4tY3c03bweMgsyaRMrV4vGaI27Szig%3A47%3A1695182074&jazoest=25388&lsd=OgD-6UJT1qT5XjAqWrl4im&__spin_r=1008798983&__spin_b=trunk&__spin_t=1695378889&fb_api_caller_class=RelayModern&fb_api_req_friendly_name=CometHovercardQueryRendererQuery&variables=%7B%22actionBarRenderLocation%22%3A%22WWW_COMET_HOVERCARD%22%2C%22context%22%3A%22DEFAULT%22%2C%22entityID%22%3A%22111915851721340%22%2C%22includeTdaInfo%22%3Afalse%2C%22scale%22%3A1%2C%22__relay_internal__pv__GroupsCometGroupChatLazyLoadLastMessageSnippetrelayprovider%22%3Afalse%7D&server_timestamps=true&doc_id=6595871777147408 

import axios from 'axios'
import { resolve } from "path";


async function queryPage(page) {
    console.log("queryPage================================================")
    let last = Date.now();
    while ((pageid.length > 0) || (Date.now - last <= 60000)) {
        let pid = pageid.shift()
        if(pid){
            console.log("start queryPage",pid)
            await axiosId(page,pid); 
            console.log("end queryPage",pid, (Date.now()-last)/1000.0)     
            last =  Date.now();
        }
    }
}

async function axiosId(page, id) {
    await page.goto("https://mtouch.facebook.com/profile.php/?id=" + id + "&profile_tab_item_selected=about", {
        waitUntil: 'networkidle0',
        timeout: 60000
    });

    // await page.waitForNavigation({ waitUntil: 'domcontentloaded' })
    await wait(500)
    await page.screenshot({ path: "query.jpg" });
    let source = await page.content({ "waitUntil": "domcontentloaded" });

    fs.writeFileSync("query.html", source)
    let div = page.$('#screen-root');
    if (!div) {
        return
    }
    let about = {}
    let f = async (select) => {
        let e = await page.$(select);
        if(e == null || e == undefined) return null;
        return await e.evaluate(e =>{return e ? e.innerText:''}, e) 
    }

    let v = async (e) => {
        if(e == null || e == undefined) return null;
        return await e.evaluate(e =>{return e ? e.innerText:''}, e) 
    }
    let next = async (e) => {
        return e ? await e.evaluateHandle(e => e?e.nextElementSibling:null, e) : null
    }
    // about.top = (await f('#screen-root > div > div.m.fixed-container.top > div')).trim();

    let tdiv = await page.$('#screen-root > div > div:nth-child(2) > div:nth-child(3) > div[data-mcomponent="ServerTextArea"]');
    about.name = await v(tdiv);
    tdiv = await next(tdiv);
    if((await v(tdiv)).length == 0){
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
    // about.category =await findDiv(tdiva, keys.category)
    // about.add = await findDiv(tdiva, keys.add)
    // about.phone = await findDiv(tdiva, keys.phone)
    // about.email = await f("#screen-root > div > div:nth-child(2) > div:nth-child(8) > div:nth-child(1) > div:nth-child(10)")

    // about.link = await f("#screen-root > div > div:nth-child(2) > div:nth-child(8) > div:nth-child(1) > div:nth-child(14)")

    console.table(about)

}
CometHovercardQueryRendererQuery(100092039206008)