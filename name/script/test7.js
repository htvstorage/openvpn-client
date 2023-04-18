
import { Exchange } from './Exchange.js';


  // Exchange.GStock.stocks()


  let today = new Date();

// Trừ 5 ngày
let fiveDaysAgo = new Date(today);
fiveDaysAgo.setDate(today.getDate() - 17);

console.log("Ngày hiện tại: ", today);
console.log("Trừ 5 ngày: ", fiveDaysAgo);