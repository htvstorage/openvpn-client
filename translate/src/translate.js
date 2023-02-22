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

   let dic= fs.readFileSync("cambridge.dictionary.json")
   let json = JSON.parse(new String(dic));
//    console.table(Object.keys(json))
   console.table(json['love'])
    
    while (files.length > 0) {
        let f = files.pop();
        let src = fs.readFileSync(f)
        src = new String(src);
        // console.log(src)
        let as = src.split("\n");
        let ws = src.replace(/[^\x00-\x7F]/g, "");
        // console.log(ws)
        let map = {};
        stat.length = as.length;
        let promise = new Promise(async resolve => {
            for (let s of as) {
                // console.log(s)
                while (stat.req - stat.res >= 30) {
                    await wait(200);
                }
                stat.req++;
                stat.res++;
                // translate(s, { from: 'en', to: 'vi' }).then(res => {
                //     stat.res++;
                //     map[s] = res.text;
                //     if (stat.res % 10 == 0) {
                //         console.log(stat);
                //     }
                //     // console.log(s, res.text)
                //     if (stat.res == as.length)
                //         resolve(map);
                // }).catch(err => {
                //     console.error(err);
                // });
            }
        })
        await promise;
        let ns = as.map(e => {
            return e + "\n" + map[e];
        });

        console.log(ns.join("\n"));

    }


})();

async function trans(string, src, dst) {

}