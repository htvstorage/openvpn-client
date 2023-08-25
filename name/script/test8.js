
import { Exchange } from './Exchange.js';

(async () => {
    // let listSymbol = await Exchange.getlistallsymbol()
    // listSymbol = listSymbol.filter(e => e.length == 3);
    // let stockdata = {}
    // let z = await Exchange.getliststockdata(listSymbol, stockdata);

    // console.table(stockdata['SHS'])
    // console.table(stockdata['NVL'])
    // console.table(stockdata['VGI'])


    // console.log(Date.now())
    console.log("Data")
    let data = await Exchange.TCBS.intraday("NVL")
    console.log("End")
    console.table(data.data)

})();


