import fs from "fs"
import { Exchange } from './Exchange.js';
import puppeteer from "puppeteer";
import request_client from 'request-promise-native'
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


const run = async () => {

    let provinces = ["Hà Nội", "Hà Giang", "Cao Bằng", "Bắc Kạn", "Tuyên Quang", "Lào Cai", "Điện Biên", "Lai Châu", "Sơn La", "Yên Bái", "Hoà Bình", "Thái Nguyên", "Lạng Sơn", "Quảng Ninh", "Bắc Giang", "Phú Thọ", "Vĩnh Phúc", "Bắc Ninh", "Hải Dương", "Hải Phòng", "Hưng Yên", "Thái Bình", "Hà Nam", "Nam Định", "Ninh Bình", "Thanh Hóa", "Nghệ An", "Hà Tĩnh", "Quảng Bình", "Quảng Trị", "Thừa Thiên Huế", "Đà Nẵng", "Quảng Nam", "Quảng Ngãi", "Bình Định", "Phú Yên", "Khánh Hòa", "Ninh Thuận", "Bình Thuận", "Kon Tum", "Gia Lai", "Đắk Lắk", "Đắk Nông", "Lâm Đồng", "Bình Phước", "Tây Ninh", "Bình Dương", "Đồng Nai", "Bà Rịa - Vũng Tàu", "Hồ Chí Minh", "Long An", "Tiền Giang", "Bến Tre", "Trà Vinh", "Vĩnh Long", "Đồng Tháp", "An Giang", "Kiên Giang", "Cần Thơ", "Hậu Giang", "Sóc Trăng", "Bạc Liêu", "Cà Mau"]
    const browser = await puppeteer.launch({
        headless: true, args: ['--user-data-dir=./userdata']
    });
    const page = await browser.newPage();
    await page.setRequestInterception(true);
    let loadImage = { load: false }
    page.on('request', request => {


        if (request.resourceType() == 'image') {
            if (loadImage.load)
                request.continue()
            else
                request.abort()
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
                    console.log("error",request.url(), "\n",  request.headers(), "\n",request.postData(), "\n")

                    if(request.postData().includes("CometHovercardQueryRendererQuery")){
                        console.log("error",request.url(), "\n",  request.headers(), "\n",request.postData(), "\n")
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
            if(text.includes('{"data":{"serpResponse":{"results":{"edges":[{"node":{"role":"ENTITY_PAGES","__typename":"SearchRenderable"}')){
                let datajs = JSON.parse(text);
                let edges = datajs.data.serpResponse.results.edges
                for(let e of edges){
                    console.log(c++,e.relay_rendering_strategy.view_model.profile.id,e.relay_rendering_strategy.view_model.profile.name)
                }

            }
            // console.log(response.url(), '\n', text.slice(0, 200));
        }
    });
    await page.setViewport({ width: 1920, height: 2000 });
    await page.goto("https://www.facebook.com/", {
        waitUntil: 'domcontentloaded',
        timeout: 60000
    });
    if (await page.$('#email'))
        await page.type("#email", "trinhvanhung@live.com");
    if (await page.$('#pass'))
        await page.type("#pass", "Htv.@123");
    if (await page.$('#loginbutton'))
        await page.click("#loginbutton");

    const toSaveCookies = await page.cookies();
    console.log(toSaveCookies)
    fs.writeFileSync("./cookies.json", JSON.stringify(toSaveCookies, null, 2));
    // await page.waitForNavigation();
    let searchclass = "input.x1i10hfl.xggy1nq.x1s07b3s.x1kdt53j.x1yc453h.xhb22t3.xb5gni.xcj1dhv.x2s2ed0.xq33zhf.xjyslct.xjbqb8w.xnwf7zb.x40j3uw.x1s7lred.x15gyhx8.x972fbf.xcfux6l.x1qhh985.xm0m39n.x9f619.xzsf02u.xdl72j9.x1iyjqo2.xs83m0k.xjb2p0i.x6prxxf.xeuugli.x1a2a7pz.x1n2onr6.x15h3p50.xm7lytj.x1sxyh0.xdvlbce.xurb0ha.x1vqgdyp.x1xtgk1k.x17hph69.xo6swyp.x1ad04t7.x1glnyev.x1ix68h3.x19gujb8";
    await page.waitForSelector('input[aria-label="Search Facebook"]');
    await page.focus('input[aria-label="Search Facebook"]')
    await page.click('input[aria-label="Search Facebook"]');
    // await page.type('input[aria-label="Search Facebook"]',"Cua hang\n")
    await page.keyboard.type('spa a\n');
    await page.focus('span[class="xhb22t3 xb5gni xcj1dhv x6s0dn4 x78zum5 xuxw1ft x47corl x1ye3gou"]')
    await page.keyboard.press('\n');
    await page.waitForNavigation({ waitUntil: 'networkidle0' })
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
    console.log(page.url());
    console.log("Start move move")
    list = await page.$$('div[role="article"]');
    console.log(list.length)

    
    const rect = await page.evaluate(el => {
      const {x, y} = el.getBoundingClientRect();
      return {x, y};
    }, list[0]);
       
    await page.mouse.move(rect.x +25,rect.y+25)
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


CometHovercardQueryRendererQuery()

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
