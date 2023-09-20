import fs from "fs"
import { Exchange } from './Exchange.js';
import puppeteer from "puppeteer";
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
    const browser = await puppeteer.launch({
        headless: true, args: ['--user-data-dir=./userdata']
    });
    const page = await browser.newPage();
    await page.setViewport({ width: 1920, height: 5200 });
    await page.goto("https://www.facebook.com/search/pages/?q=cua%20hang", {
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

    await page.evaluate('window.scrollTo(0, document.body.scrollHeight)') 
    // await page.waitForNavigation({ waitUntil: 'networkidle0' })
    await page.screenshot({ path: "after-login.jpg" });

    let source = await page.content({"waitUntil": "domcontentloaded"});

    fs.writeFileSync("source.txt",source)

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


const scrollPage = async(page, scrollContainer, itemTargetCount) => {
    let items = [];
    let previousHeight = await page.evaluate(`document.querySelector("${scrollContainer}").scrollHeight`);
    let lastLength = 0;
    let c = 0;
    while ((c <= 8) && (itemTargetCount > items.length)) {
        // items = await extractItems(page);
        await page.evaluate(`document.querySelector("${scrollContainer}").scrollTo(0, document.querySelector("${scrollContainer}").scrollHeight)`);
        await page.evaluate(`document.querySelector("${scrollContainer}").scrollHeight > ${previousHeight}`);
        await page.waitForTimeout(500);
        console.log(items.length,c)
        if(lastLength < items.length){
          lastLength = items.length
          c = 0;
        }else{
          c++;
        }            
        
    }
    return items;
    }