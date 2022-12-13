import fetch from "node-fetch";
(async () => {
    console.log("ok")
    var x = [];
    for (var i = 1; i < 1000; i++) {
        x.push(1000 * Math.random());
    }


    x.forEach((element, index) => {
        // console.log(element, index)
    });

    const getHi = val => { console.log(val); var t = Math.max(...x.slice(0)); console.log(t); return t; };

    console.log(getHi(x))
    // console.log(x.slice(1.3))


    let fd = new Date();
    const fs = fd.getFullYear() + "-" + (fd.getMonth() + 1) + "-" + fd.getDate()
    console.log(fs);


    var a = await fetch("https://api-finfo.vndirect.com.vn/v4/stock_intraday_latest?q=code:AAA&sort=time&size=10000000", {
        "headers": {
            "accept": "application/json, text/plain, */*",
            "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
            "sec-ch-ua-mobile": "?0"
        },
        "referrer": "https://trade.vndirect.com.vn/",
        "referrerPolicy": "strict-origin-when-cross-origin",
        "body": null,
        "method": "GET",
        "mode": "cors"
    });

    var x = await a.json()

    console.log(x);
    for(var e of x.data){
        console.log(e);
    }
})();