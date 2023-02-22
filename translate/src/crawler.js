const fetch = (...args) => import('node-fetch').then(({default: fetch}) => fetch(...args));
const jsdom = require("jsdom");
const { JSDOM } = jsdom;
const fs = require("fs");
(async()=>{
    let guideURL = [];
    let extendURL = [];
    let abc="a b c d e f g h i j k l m n o p q r s t u v w x y z".split(" ");
    stat = {req:abc.length,res:0}
    let promise = new Promise(resolve=>{
        for(let c of abc){
            console.log(c)
            let a = fetch("https://dictionary.cambridge.org/browse/english/" + c);
            a.then(res => res.text()).then(text=>{
                stat.res++;
                let domtxt = text;
                // console.log(domtxt)
                const dom = new JSDOM(domtxt);
                let hrefs = dom.window.document.querySelectorAll("a.hlh32.hdb.dil.tcbd");    
                for(let e of hrefs){
                    // console.log(e.getAttribute("href"));
                    guideURL.push(e.getAttribute("href"));
                    fs.appendFileSync("guideURL.txt",e.getAttribute("href")+"\n");
                }
    
                if(stat.res == stat.req){
                    resolve(guideURL);
                }
    
            })
    
        }

    });
    let ret = await promise;

    console.table(guideURL);

    stat = {req:guideURL.length,res:0}
    promise = new Promise(resolve=>{
        for(let url of guideURL){
            // console.log(c)
            let a = fetch(url);
            a.then(res => res.text()).then(text=>{
                stat.res++;
                let domtxt = text;
                // console.log(domtxt)
                const dom = new JSDOM(domtxt);
                let hrefs = dom.window.document.querySelectorAll("a.tc-bd[title]");    
                for(let e of hrefs){
                    // console.log(e.getAttribute("href"));
                    extendURL.push("https://dictionary.cambridge.org"+e.getAttribute("href"));
                    fs.appendFileSync("extendURL.txt","https://dictionary.cambridge.org"+e.getAttribute("href")+"\n");
                }
    
                if(stat.res == stat.req){
                    resolve(extendURL);
                }
    
            })
    
        }

    });

    await promise;


})();