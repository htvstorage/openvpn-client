import { Exchange } from "./Exchange.js";

(async ()=>{
    console.log("Aysnc")
    let z = Exchange.transaction('HPG',10);
    console.log(await z)
})()