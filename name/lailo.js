import { Console } from "console";
import fs from "fs"
let z = null;
if (!fs.existsSync("lailo.json")) {
    let a = await fetch("https://smartone.vps.com.vn/Api/Proxy", {
        "headers": {
            "accept": "application/json, text/javascript, */*; q=0.01",
            "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
            "content-type": "application/json; charset=UTF-8",

            "cookie": "_fbp=fb.2.1669623965921.1893403188; _ga_M9VTXEHK9C=GS1.1.1669958644.2.0.1669958644.0.0.0; listStockSelected=AAA%2C; _ga_QW53DJZL1X=GS1.1.1676003181.15.0.1676003181.0.0.0; _ga_790K9595DC=GS1.1.1676003177.47.1.1676003416.0.0.0; _ga=GA1.1.1812813168.1668398014; listStockId=c5fdffb840c74452b106f1b2505eb9a1; listStockName=hpg; listStock=HPG%2CHSG%2CNKG%2CNVL%2CSHS%2CHAG%2CAPS%2CAPG%2CVIX%2CHPX%2CPDR%2CVGI%2CYEG%2CBCG%2CPOM%2CCSI%2CVIB%2CVIC%2CIBC%2CDNN%2CHQC%2CHT1%2CPLC%2CCEN%2CNED%2CCLX%2CPC1%2CKSB%2CVCG; ASP.NET_SessionId=vfswa314ug1wwnz2aeyd2va5; __RequestVerificationToken=ZCJ6bRUvsFfjLBb6rSGDFJ37i_Cu3c8XRenzSKYiByLBx8krjO7FSI_K6NexH0uJ262HNzv9GwFIRZfRkKZUUM-EdF81; DefaultAccount=4986391; _ga_4WDBKERLGC=GS1.1.1681185614.100.0.1681185614.0.0.0; startPs=06-07-2020; endPs=05-07-2020; startSMOTP=13-10-2020; endSMOTP=12-10-2020"
        },
        "referrer": "https://smartone.vps.com.vn/",
        "referrerPolicy": "strict-origin-when-cross-origin",
        "body": "{\"group\":\"B\",\"user\":\"498639\",\"session\":\"08dcce84-04c1-444c-b68c-c34f7dec1405\",\"data\":{\"type\":\"cursor\",\"cmd\":\"PPL_GetAll\",\"p1\":\"4986391\",\"p2\":\"\",\"p3\":\"01/01/2022\",\"p4\":\"20/04/2023\",\"p5\":\"1\",\"p6\":\"1000\"}}",
        "method": "POST",
        "mode": "cors"
    });
    z = await a.json()

    // let a = await fetch("https://smartone.vps.com.vn/Api/Proxy", {
    //     "headers": {
    //       "accept": "application/json, text/javascript, */*; q=0.01",
    //       "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
    //       "content-type": "application/json; charset=UTF-8",
    //       "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
    //       "sec-ch-ua-mobile": "?0",
    //       "sec-fetch-dest": "empty",
    //       "sec-fetch-mode": "cors",
    //       "sec-fetch-site": "same-origin",
    //       "x-requested-with": "XMLHttpRequest",
    //       "cookie": "_fbp=fb.2.1669623965921.1893403188; _ga_M9VTXEHK9C=GS1.1.1669958644.2.0.1669958644.0.0.0; listStockSelected=AAA%2C; _ga_QW53DJZL1X=GS1.1.1676003181.15.0.1676003181.0.0.0; _ga_790K9595DC=GS1.1.1676003177.47.1.1676003416.0.0.0; _ga=GA1.1.1812813168.1668398014; listStockId=c5fdffb840c74452b106f1b2505eb9a1; listStockName=hpg; listStock=HPG%2CHSG%2CNKG%2CNVL%2CSHS%2CHAG%2CAPS%2CAPG%2CVIX%2CHPX%2CPDR%2CVGI%2CYEG%2CBCG%2CPOM%2CCSI%2CVIB%2CVIC%2CIBC%2CDNN%2CHQC%2CHT1%2CPLC%2CCEN%2CNED%2CCLX%2CPC1%2CKSB%2CVCG%2CAPI; ASP.NET_SessionId=ayreuhhzoyg5hqrnkckmohjh; __RequestVerificationToken=uEh2wtlrxJOqJh7dMaHdundoMuqWfPnDexobqDQNoryPG_89Pghq7iy6fdIkwrxTHYsH01KvvwZMV5xURowNx-Yp6TQ1; DefaultAccount=4986391; startPs=06-07-2020; endPs=05-07-2020; startSMOTP=13-10-2020; endSMOTP=12-10-2020; _ga_4WDBKERLGC=GS1.1.1682067014.106.1.1682067016.0.0.0"
    //     },
    //     "referrer": "https://smartone.vps.com.vn/",
    //     "referrerPolicy": "strict-origin-when-cross-origin",
    //     "body": "{\"group\":\"Q\",\"user\":\"498639\",\"session\":\"08dcce84-04c1-444c-b68c-c34f7dec1405\",\"data\":{\"type\":\"string\",\"cmd\":\"Web.GetProfitLostExecuted\",\"p1\":\"4986391\",\"p2\":\"\",\"p3\":\"1\",\"p4\":\"30\"}}",
    //     "method": "POST",
    //     "mode": "cors"
    //   });

    // let data = await a.json();
    // z.data.push(...data.data)

    // console.table(data.data)

    fs.writeFileSync("lailo.json", JSON.stringify(z))
} else {
    let data = fs.readFileSync("lailo.json", "utf-8")
    z = JSON.parse(data);
}

let profit = z.data.map(e => e.C_PROFIT_LOSS).reduce((a, b) => { return a + b }, 0)

z.data.map(e => { return { code: e.C_SHARE_CODE, val: e.C_PROFIT_LOSS } })

let x1 = z.data.map(e => { return { code: e.C_SHARE_CODE, val: e.C_PROFIT_LOSS } })
let sum = {}
x1.forEach(e => {
    if (sum[e.code] == undefined) sum[e.code] = 0;
    sum[e.code] += e.val;
});

let pa = []
Object.keys(sum).forEach(k => {
    pa.push({ code: k, val: sum[k] })
})
pa.sort((a, b) => { return a.val - b.val })


console.table(pa)
console.table([profit])