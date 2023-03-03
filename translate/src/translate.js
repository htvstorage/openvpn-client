const fs = require("fs");
// const translate = require('@saipulanuar/google-translate-api');
const translate = require('@iamtraction/google-translate');
const { join } = require("path");
// npm install --save @iamtraction/google-translate
function wait(ms) {
    return new Promise(resolve => {
        setTimeout(() => {
            resolve(0);
        }, ms);
    });
}

(async () => {
    //Load file
    var args = process.argv.slice(2);
    let files = args.filter(f => fs.existsSync(f));
    stat = { req: 0, res: 0 }

    let dic = fs.readFileSync("sort.dic")
    let dics = new String(dic).split("\n");
    let dicm = {}
    for (let l of dics) {
        if (l.length == 0) continue;
        let json = JSON.parse(l);
        dicm[json.title.toLowerCase()] = json;
    }
    //    console.table(Object.keys(json))
    console.table(dicm['love'])

    while (files.length > 0) {
        let f = files.pop();
        let src = fs.readFileSync(f)
        src = new String(src);
        src = src.replace(/[^\x00-\x7F]/g, "");
        // console.log(src)
        let as = src.split("\n");
        // let ws = src.replace(/[^\x00-\x7F]/g, "");
        // console.log(as)
        let map = {};
        stat.length = as.length;
        let promise = new Promise(async resolve => {
            for (let s of as) {
                // console.log(s)
                while (stat.req - stat.res >= 50) {
                    await wait(200);
                }
                stat.req++;
         
                if(s == null || s == undefined|| s =='' ) {      
                    stat.res++;              
                    if (stat.res == as.length)
                    resolve(map);
                    continue;
                }

                translate(s, { from: 'en', to: 'vi' }).then(res => {
                    stat.res++;
                    map[s] = res.text;
                    if (stat.res % 10 == 0) {
                        console.log(stat);
                    }
                    // console.log(s, res.text)
                    if (stat.res == as.length)
                        resolve(map);
                }).catch(err => {
                    console.error(err);
                });
            }
        })
        await promise;
        console.log("-----------------------",as.length)
        let ns = as.map(e => {
            
            let ws = e.split(" ").map(t => {t=t.replaceAll(".", ""); t=t.replaceAll(",", ""); return t});
            let pro = "";
            for (let w of ws) {
                if (dicm[w.toLowerCase()] != null){
                    let us = dicm[w.toLowerCase()].ukp;
                    if (us == "" || us == undefined ) us = dicm[w.toLowerCase()].usp;
                    pro += us  + "|"
                }
                else pro += w + "|"
            }
            return e + "\n" + pro +"\n" + map[e];
        });

        console.log(ns.join("\n"));

    }


})();

async function trans(string, src, dst) {

}