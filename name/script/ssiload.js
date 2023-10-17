import fs from "fs"
import { Exchange } from './Exchange.js';
import puppeteer from "puppeteer";
import request_client from 'request-promise-native'


const run = async () => {
    
    const browser = await puppeteer.launch({
        headless: true, args: ['--user-data-dir=./ssidata']
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
    await page.goto("https://iboard.ssi.com.vn/", {
        waitUntil: 'domcontentloaded',
        timeout: 60000
    });
    await wait(10000)
    await page.screenshot({ path: "ssiiboard.jpg" });    
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
