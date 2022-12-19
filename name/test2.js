
import { Exchange } from "./Exchange.js";
(async () =>{
    console.log("ABC")
    let z = await Exchange.ratios("HPG");
    let x = [1,2,3,4,5,6,7,8,9]
    console.log(await z.text())
    console.log(x.slice(-3))
    console.log(x)

    let zzzz = "123456789";

    console.log(zzzz.substring(-3,3));

    let ex = (path)=>{
        return path.includes("HOSE")?"HOSE":path.includes("HNX")?"HNX":"UPCOM";
    }

    console.log(ex("ABCUPCOMXXXX"));
})();