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


    // var a = await fetch("https://api-finfo.vndirect.com.vn/v4/stock_intraday_latest?q=code:HPG&sort=time&size=100000", {
    //     "headers": {
    //         "accept": "application/json, text/plain, */*",
    //         "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
    //         "sec-ch-ua-mobile": "?0"
    //     },
    //     "referrer": "https://trade.vndirect.com.vn/",
    //     "referrerPolicy": "strict-origin-when-cross-origin",
    //     "body": null,
    //     "method": "GET",
    //     "mode": "cors"
    // });

    // var x = await a.text()

    // console.log(x);
 

    let cop = [];
    let exs = ['hose', 'hnx', 'upcom']
    for (let ex of exs) {
      let a = await fetch("https://wgateway-iboard.ssi.com.vn/graphql", {
        "headers": {
          "accept": "*/*",
          "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
          "content-type": "application/json",
          "g-captcha": "",
          "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
          "sec-ch-ua-mobile": "?0",
          "sec-fetch-dest": "empty",
          "sec-fetch-mode": "cors",
          "sec-fetch-site": "same-site"
        },
        "referrer": "https://iboard.ssi.com.vn/",
        "referrerPolicy": "strict-origin-when-cross-origin",
        "body": "{\"operationName\":\"stockRealtimes\",\"variables\":{\"exchange\":\""+ex+"\"},\"query\":\"query stockRealtimes($exchange: String) {\\n  stockRealtimes(exchange: $exchange) {\\n    stockNo\\n    ceiling\\n    floor\\n    refPrice\\n    stockSymbol\\n    stockType\\n    exchange\\n    matchedPrice\\n    matchedVolume\\n    priceChange\\n    priceChangePercent\\n    highest\\n    avgPrice\\n    lowest\\n    nmTotalTradedQty\\n    best1Bid\\n    best1BidVol\\n    best2Bid\\n    best2BidVol\\n    best3Bid\\n    best3BidVol\\n    best4Bid\\n    best4BidVol\\n    best5Bid\\n    best5BidVol\\n    best6Bid\\n    best6BidVol\\n    best7Bid\\n    best7BidVol\\n    best8Bid\\n    best8BidVol\\n    best9Bid\\n    best9BidVol\\n    best10Bid\\n    best10BidVol\\n    best1Offer\\n    best1OfferVol\\n    best2Offer\\n    best2OfferVol\\n    best3Offer\\n    best3OfferVol\\n    best4Offer\\n    best4OfferVol\\n    best5Offer\\n    best5OfferVol\\n    best6Offer\\n    best6OfferVol\\n    best7Offer\\n    best7OfferVol\\n    best8Offer\\n    best8OfferVol\\n    best9Offer\\n    best9OfferVol\\n    best10Offer\\n    best10OfferVol\\n    buyForeignQtty\\n    buyForeignValue\\n    sellForeignQtty\\n    sellForeignValue\\n    caStatus\\n    tradingStatus\\n    remainForeignQtty\\n    currentBidQty\\n    currentOfferQty\\n    session\\n    __typename\\n  }\\n}\\n\"}",
        "method": "POST",
        "mode": "cors"
      });
      let x = await a.json()
      // console.log(x);
      cop = [...cop,...x.data.stockRealtimes];
    }

    let cop2 = [];
    let fet = await fetch("https://bgapidatafeed.vps.com.vn/getlistallstock", {
      "headers": {
        "accept": "application/json, text/plain, */*",
        "accept-language": "en-US,en;q=0.9,vi-VN;q=0.8,vi;q=0.7",
        "if-none-match": "W/\"5ac92-c+NqjXQ6D2JFKgaxgUoTpIzr5z8\"",
        "sec-ch-ua": "\"Chromium\";v=\"92\", \" Not A;Brand\";v=\"99\", \"Google Chrome\";v=\"92\"",
        "sec-ch-ua-mobile": "?0",
        "sec-fetch-dest": "empty",
        "sec-fetch-mode": "cors",
        "sec-fetch-site": "same-site"
      },
      "referrer": "https://banggia.vps.com.vn/",
      "referrerPolicy": "strict-origin-when-cross-origin",
      "body": null,
      "method": "GET",
      "mode": "cors"
    }, { timeout: 5000 });
    let xx = await fet.json();
    // console.log(xx.length)
    cop2 = [...cop2, ...xx];
    // return cop;
    
    console.log(cop2[0]);
    console.log(cop[0]);

    let ck = new Set();
    let ck2 = new Set();
    for(let e of cop2){  
      if(e.stock_code.length <=3)    
      ck2.add(e.stock_code);
    }

    for(let e of cop){
      if(e.stockSymbol.length <=3)  
      ck.add(e.stockSymbol);
    }
    console.log(ck2.size)
    console.log(ck.size)
    console.log("check 1")
    for(var e of cop){
      if(e.stockSymbol.length <=3) 
      if (!ck2.has(e.stockSymbol)){
        console.log("ssi",e.exchange,e.stockSymbol)
      }
    }

    console.log("check 2")
    for(var e of cop2){
      if(e.stock_code.length <=3)   
      if (!ck.has(e.stock_code)){
        // console.log("vps",e.post_to,e.stock_code)
      }
    }   
    
    

    // for(let e of cop){
    //   console.log(e.stockSymbol.length> 3? "xxxxxxx":"");
    // }
})();