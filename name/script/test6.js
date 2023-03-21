import { Exchange } from "./Exchange.js";
// process.env['NODE_TLS_REJECT_UNAUTHORIZED'] = '0';
(async ()=>{
  Exchange.getlistallstock();

  let x = [0,1,2,3,4,5,6]

  let x2 = [...x];

  console.log(x.reverse())
  console.log(x)
  console.log(x2)
})();