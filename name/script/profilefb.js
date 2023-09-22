import fs from "fs"
import { Exchange } from './Exchange.js';
import puppeteer from "puppeteer";
import request_client from 'request-promise-native'


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
        // if (response.url().includes("graphql")) {
            let text = await response.text();
            if (text.includes('Tamduc2012')) {
                // let datajs = JSON.parse(text);  
                let i = text.lastIndexOf("Tamduc2012");
                         
                console.log(response.url(), '\n', text.slice(i-10000,i+10000));
            }
            
        // }
    });
    await page.setViewport({ width: 1920, height: 2000 });
    await page.goto("https://www.facebook.com/profile.php?id=100085949237392", {
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
    
    await wait(5000)
    await page.screenshot({ path: "after-move.jpg" });
    
};

run();




function wait(ms) {
    return new Promise(resolve => {
        setTimeout(() => {
            resolve(0);
        }, ms);
    });
}
