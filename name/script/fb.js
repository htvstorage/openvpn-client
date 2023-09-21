import fs from "fs"
import { Exchange } from './Exchange.js';
import puppeteer from "puppeteer";
import request_client from 'request-promise-native'


const run = async () => {
    //"Hà Nội", "Hà Giang", "Cao Bằng", "Bắc Kạn", "Tuyên Quang",
    let provinces = [ "Hà Nội", "Hà Giang", "Cao Bằng", "Bắc Kạn", "Tuyên Quang","Lào Cai", "Điện Biên", "Lai Châu", "Sơn La", "Yên Bái", "Hoà Bình", "Thái Nguyên", "Lạng Sơn", "Quảng Ninh", "Bắc Giang", "Phú Thọ", "Vĩnh Phúc", "Bắc Ninh", "Hải Dương", "Hải Phòng", "Hưng Yên", "Thái Bình", "Hà Nam", "Nam Định", "Ninh Bình", "Thanh Hóa", "Nghệ An", "Hà Tĩnh", "Quảng Bình", "Quảng Trị", "Thừa Thiên Huế", "Đà Nẵng", "Quảng Nam", "Quảng Ngãi", "Bình Định", "Phú Yên", "Khánh Hòa", "Ninh Thuận", "Bình Thuận", "Kon Tum", "Gia Lai", "Đắk Lắk", "Đắk Nông", "Lâm Đồng", "Bình Phước", "Tây Ninh", "Bình Dương", "Đồng Nai", "Bà Rịa - Vũng Tàu", "Hồ Chí Minh", "Long An", "Tiền Giang", "Bến Tre", "Trà Vinh", "Vĩnh Long", "Đồng Tháp", "An Giang", "Kiên Giang", "Cần Thơ", "Hậu Giang", "Sóc Trăng", "Bạc Liêu", "Cà Mau"]
    const browser = await puppeteer.launch({
        headless: true, args: ['--user-data-dir=./userdata']
    });
    const page = await browser.newPage();
    await page.setRequestInterception(true);
    page.on('request', request => {


        if (request.resourceType() == 'image') {
            request.continue()
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
                    // console.log("error",request.url(), "\n",  request.headers(), "\n",request.postData(), "\n")
                    request.continue();
                    // request.abort();
                });
            } else {
                request.continue();
            }
        }
    });

    page.on('response', async (response) => {
        if (response.url().includes("graphql")) {
            let text = await response.text();
            // console.log(response.url(), '\n', text.slice(0, 200));
        }
    });
    await page.setViewport({ width: 1920, height: 1368 });
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
    await page.keyboard.type('Cua hang\n');
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
    let map = []
    for (let province of provinces) {
        await page.screenshot({ path: "after-combobox.jpg" });
        try {
            await page.waitForSelector('input[aria-label="Location"][role="combobox"]')
        } catch (error) {
            
        }
        
        await page.$('input[aria-label="Location"][role="combobox"]')
        await page.focus('input[aria-label="Location"][role="combobox"]')
        await page.click('input[aria-label="Location"][role="combobox"]');
        await page.keyboard.type(province, { delay: 2000 });        
        console.log(page.url());        
        // await page.waitForSelector('ul[aria-label="5 suggested searches"][role="listbox"]')
        await page.waitForSelector('ul[role="listbox"]')
        list = await page.$('ul[role="listbox"]');
        let option = await list.$('li[role="option"]')
        await option.click()
        await wait(5000)
        // await page.waitForSelector('div.x1i10hfl.xjbqb8w.x6umtig.x1b1mbwd.xaqea5y.xav7gou.x9f619.x1ypdohk.xt0psk2.xe8uvvx.xdj266r.x11i5rnm.xat24cr.x1mh8g0r.xexx8yu.x4uap5.x18d9i69.xkhd6sd.x16tdsg8.x1hl2dhg.xggy1nq.x1o1ewxj.x3x9cwd.x1e5q0jg.x13rtm0m.x1n2onr6.x87ps6o.x1lku1pv.x1a2a7pz[role="button"]')
        console.table({province:province,filter:page.url()});
        map.push({province:province,filter:page.url()}) 
         fs.appendFileSync("map.json",JSON.stringify({province:province,filter:page.url()})+"\n")
        await page.screenshot({ path: "after-login.jpg" });
        let clear = await page.$('div.x1i10hfl.xjbqb8w.x6umtig.x1b1mbwd.xaqea5y.xav7gou.x9f619.x1ypdohk.xt0psk2.xe8uvvx.xdj266r.x11i5rnm.xat24cr.x1mh8g0r.xexx8yu.x4uap5.x18d9i69.xkhd6sd.x16tdsg8.x1hl2dhg.xggy1nq.x1o1ewxj.x3x9cwd.x1e5q0jg.x13rtm0m.x1n2onr6.x87ps6o.x1lku1pv.x1a2a7pz[role="button"]')
        await clear.click()
        await wait(5000)
        // await page.reload()
        // await page.waitForNavigation({ waitUntil: 'networkidle0' })
        console.log(page.url());
    }

    console.table(map)
   


    // await page.evaluate('window.scrollTo(0, document.body.scrollHeight)')
    // await page.waitForNavigation({ waitUntil: 'networkidle0' })
    // await page.click('a[aria-current="page"]')
    // await page.waitForNavigation({ waitUntil: 'networkidle0' })
    await page.screenshot({ path: "after-click-clear.jpg" });


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
    await page2.screenshot({ path: "login-using-cookies.jpg" });
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
