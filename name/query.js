
import { Exchange } from "./Exchange.js";
import fetch from "node-fetch";
import fs from "fs";


(async () => {
  

    let data = fs.readFileSync('symbol.json');
    let stockData = JSON.parse(data);

    // console.log(stockData)
    let list = [];
    for(let key of Object.keys(stockData)){
        list.push([key,...stockData[key]]);
    }


    list.sort((a,b)=>{
        let x1 = a[1] / (a[2] == 0?1:a[2]);
        let x2 = b[1] / (b[2] == 0?1:b[2]);
        return (x2 > x1?1: x2 < x1 ?-1:0)
    });

    // console.log(list)

    for(let e of list){
        console.log(e)
    }

})();