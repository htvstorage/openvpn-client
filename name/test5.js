import { Exchange } from "./Exchange.js";
import fetch from "node-fetch";
import request from 'request'
import puppeteer from "puppeteer";
import http from "node:http";
import https from "node:https";
import { Console } from 'node:console'
import { Transform } from 'node:stream'
import fs from "fs";
import xlsx from "xlsx"

(async () => {
    let p = '1.2'
    console.log(+p,p)

    let Headers = ['ChangeId', 'ChangeDescription', 'ChangeDate', 'Enhancement/Fix', 'ExcutorTeam'];
    let Data = ['INC1234', 'Multiple Cert cleanup', '04/07/2022', 'Enhancement', 'IlevelSupport'];
    
    let workbook = xlsx.utils.book_new();

    
    // xlsx.utils.sheet_add_aoa(worksheet, [Headers], { origin: 'A1' });
    // xlsx.utils.sheet_add_aoa(worksheet, [Data], { origin: 'A2' });


   let a = await Exchange.vndGetAllSymbols();
   console.log(a)
    
    
   let worksheet = xlsx.utils.json_to_sheet(a);
    
   xlsx.utils.book_append_sheet(workbook, worksheet);
    xlsx.writeFile(workbook, "Test.xlsx");
    console.log("written")

})();