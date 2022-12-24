
import { Exchange } from "./Exchange.js";
import fetch from "node-fetch";
import fs from "fs";
import path from "path";
import extract from "pdf-text-extract"
import { PdfReader } from "pdfreader";
import PDFParser from "pdf2json";
import { writeFile } from "fs/promises"
// import { fs } from "fs/promises"
import { PDFDocument } from 'pdf-lib'
import { PDFRawStream, decodePDFRawStream } from 'pdf-lib'
import { Console } from "console";
import pdf from "pdfjs-dist/legacy/build/pdf.js";
import PDFPageProxy from "pdfjs-dist/legacy/build/pdf.js";

//https://static2.vietstock.vn/vietstock/2022/12/1/20221201_20221201___thong_ke_giao_dich_tu_doanh.pdf
//https://static2.vietstock.vn/vietstock/2022/9/8/20220908_20220908___thong_ke_giao_dich_tu_doanh.pdf
function url(date) {
    let t = date.getFullYear() + ""
        + (date.getMonth() + 1 < 10 ? ("0" + (date.getMonth() + 1)) : date.getMonth() + 1) + ""
        + (date.getDate() < 10 ? "0" + date.getDate() : date.getDate())
    let file = t + '_' + t + '___thong_ke_giao_dich_tu_doanh.pdf';
    const url = 'https://static2.vietstock.vn/vietstock/' + date.getFullYear() + '/' + (date.getMonth() + 1) + '/' + date.getDate() + '/' + file;
    return { url, file };
}
(async () => {
    let dir = "./pdf";
    let req = 0;
    let res = 0;
    for (var i = 1; i < 400; i++) {
        let x = url(new Date(Date.now() - i * 24 * 60 * 60 * 1000));
        const response = fetch(x.url);
        req++;
        response.then(rs => rs.buffer()).then(async (buffer) => {
            if (buffer.length > 500) {
                await writeFile(dir + "/" + x.file, buffer);
                console.log(x.file)
                console.log(x.url)
            }
            res++;
        }
        )
        while (req - res > 10) {
            await wait(100);
        }
        // const buffer = await response.buffer();
        // if (buffer.length > 500) {
        //     await writeFile(dir + "/" + x.file, buffer);
        //     console.log(x.file)
        //     console.log(x.url)
        // }
    }
    console.log('Done!');
})
// ();


function wait(ms) {
    return new Promise(resolve => {
        setTimeout(() => {
            resolve(0);
        }, ms);
    });
}

(async () => {

    let d = new Date();

    console.log(Date.now())
    console.log(d.getFullYear(), d.getDate(), d.getMonth())

    let items = [];


    const pdfParser = new PDFParser();
    let promise = new Promise((resolve, reject) => {
        pdfParser.on("pdfParser_dataError", errData => console.error(errData.parserError));
        pdfParser.on("pdfParser_dataReady", pdfData => {            
            pdfData.Pages.forEach((p, i) => {

                p.Texts.forEach((t, ti) => {
                    t["P"] = i; items.push(t); t["text"] = decodeURIComponent(t.R[0].T)
                    t["pw"] = p.Width
                });
            });
            resolve(items);
        });
        // pdfParser.on("data",  data => this.emit("data", data));
        // data => this.emit("data", data));
        pdfParser.loadPDF("./pdf/20221222_20221222___thong_ke_giao_dich_tu_doanh.pdf");
    });

    items = await promise;
    items.sort((a, b) => {
        return a.P > b.P ? 1 : a.P < b.P ? -1 : (a.y > b.y ? 1 : a.y < b.y ? -1 : (a.x > b.x ? 1 : a.x < b.x ? -1 : 0));
    });


    let z = 0;

    const SGD = "SỞ GIAO DỊCH CHỨNG KHOÁN TP. HỒ CHÍ MINH";
    let M1, B1, M2, B2, M3, B3, M4, B4, MA, END, E5, STT;
    let next = M1;
    let idx = 0;
    for (let i of items) {
        // console.log(i.text, i.P)
        if (i.text == "Mua" || i.text == "Bán") {
            switch (idx) {
                case 0:
                    M1 = i;
                    break;
                case 1:
                    B1 = i;
                    break;
                case 2:
                    M2 = i;
                    break;
                case 3:
                    B2 = i;
                    break;
                case 4:
                    M3 = i;
                    break;
                case 5:
                    B3 = i;
                    break;
                case 6:
                    M4 = i;
                    break;
                case 7:
                    B4 = i;
                    break;
            }
            idx++;
        }

        if (i.text == "Mã CK") {
            MA = i;
        }
        if (i.text == "Stt") {
            STT = i;
        }
        if (i.text == SGD && idx > 0) {
            END = i;
            break;
        }
    }


    E5 = Object.assign({}, B4);
    E5.x = B4.x + B4.w / B4.pw + B4.sw;

    var l = items.filter((e, i) => {
        return e.P < END.P;
    })

    // console.log(M1, B1)
    // console.log(M2, B2)
    // console.log(M3, B3)
    // console.log(M4, B4)
    // console.log(END)

    // let sum = {

    //     TT: { KL: [], TT: [] }
    // }

    let tc;
    let symbol;
    let record = [, , , , , , , , ,];
    let begin = false;

    let decode = (record, idx, val, e1, e2) => {
        if (val.x >= (e1.x + e1.w / e1.pw) && (val.x + val.w / val.pw) < e2.x) {
            // console.log(val.text);       
            record[idx] = val.text;
        }
    }
    let decode2 = (record, idx, val, e1, e2) => {
        if (val.x >= (e1.x + e1.w / e1.pw) && (val.x + val.w / val.pw) < e2.x) {
            record[idx] = val.text;
        }
    }

    let sum = [];
    l.forEach((val, idx) => {
        if (val.y <= M1.y && val.P <= M1.P) {
            return;
        }

        // if(val.text == "7,149,500"){
        //    console.log(val.x, M1.x , (val.x + val.w / val.pw) , B1.x) 
        //    console.log(val,M1, B1) 
        // }

        if (val.x >= MA.x && (val.x + val.w / val.pw) < M1.x) {
            // console.log(val.text);
            begin = true;
            symbol = val.text;
            sum.push(record);
            record = [, , , , , , , , ,];
        }
        decode(record, 0, val, STT, M1); //Sy
        decode2(record, 1, val, MA, B1); //M1
        decode2(record, 2, val, M1, M2); //B1
        decode2(record, 3, val, B1, B2); //M2
        decode2(record, 4, val, M2, M3); //B2
        decode2(record, 5, val, B2, B3); //M3
        decode2(record, 6, val, M3, M4); //B3
        decode2(record, 7, val, M4, B4); //B4
        decode2(record, 8, val, B4, E5);

        // decode(record, 0, val, MA1, M1); //Sy
        // decode2(record, 1, val, MA, B1); //M1
        // decode2(record, 2, val, M1, M2); //B1
        // decode2(record, 3, val, B1, B2); //M2
        // decode2(record, 4, val, M2, M3); //B2
        // decode2(record, 5, val, B2, B3); //M3
        // decode2(record, 6, val, M3, M4); //B3
        // decode2(record, 7, val, M4, B4); //B4
        // decode2(record, 8, val, B4, E5);        
    });

    sum.push(record) //last

    for (let e of sum) {
        // console.log(e);
    }

    // let zz = sum.filter((e)=>{return e[1] != undefined}).map(e=>+(e[1].replace(/,/g, '')));
    let head = sum[0];


    console.log(head);

    head.forEach((v, i) => {
        if (v == undefined) {
            return;
        }
        let zz = sum.filter((e) => { return e[i] != undefined }).map(e => +(e[i].replace(/,/g, '')));
        let v1 = zz.slice(1);
        let v2 = v1.reduce((a, b) => a + b, 0)
        if (v2 != +(v.replace(/,/g, ''))) {
            // console.log("Co sai du lieu ", i, v,v2)
            // console.log(zz);
        } else {
            // console.log("Ok  ", i, v,v2)
        }
    })



    //  console.log(v2,zz[0]);    
    const pdfData = fs.readFileSync("./pdf/20221222_20221222___thong_ke_giao_dich_tu_doanh.pdf");

    const loadingTask = pdf.getDocument("./pdf/20221222_20221222___thong_ke_giao_dich_tu_doanh.pdf");
        const doc = await loadingTask.promise;

    // console.log(doc.getPage(1).then(p=>{console.log(p)}))

(await doc.getPage(1)).getTextContent().then(function (ops) {
    console.log(JSON.stringify(ops))

    // for (var i=0; i < ops.fnArray.length; i++) {
    //     // if (ops.fnArray[i] == pdf.OPS.paintJpegXObject) {
    //         // window.objs.push(ops.argsArray[i][0])
    //         console.log(ops.argsArray[i])
    //     // }
    // }
})


// (await doc.getPage(1)).getTextContent().then( ct=>{console.log(ct)});


    // const pdfDoc = await PDFDocument.load(pdfData);
    // const pages = pdfDoc.getPages()

    // const form = pdfDoc.getForm()

    // const zzz = pages[0].getMediaBox()
    // console.log("pdf",pages[0]);


    // pdfDoc.context.indirectObjects.forEach((v,k)=>{
    //     // const {decodePDFRawStream, PDFRawStream} =require('pdf-lib');
    //     if(v instanceof PDFRawStream){
    //         // console.log(dengXian.encodeText(v.contents.toString()));
    //         let stream = decodePDFRawStream(v);
    //         console.log(stream.getBytes());
    //         // console.log(iconv.decode(Buffer.from(bytes), "cp936"));
    //     }
    // });

    // const enumeratedIndirectObjects = pdfDoc.context.enumerateIndirectObjects()
    // enumeratedIndirectObjects.forEach(async (x, objIdx) => {
    //     const pdfRef = x[0]
    //     const pdfObject = x[1]

    //     if (!(pdfObject instanceof PDFRawStream)) return

    //     //const { dict } = pdfObject
    //     console.log('objIdx', objIdx, 'pdfObject', pdfObject)
    //     var buffer = Buffer.from(pdfObject.contents)
    //     try {
    //         const img = await Jimp.read(buffer)
    //         console.log(`${objIdx.toString()}.jpg`)
    //         // img.writeAsync(`images/${objIdx.toString()}.jpg`, Jimp.MIME_JPEG)
    //     } catch (e) {
    //         // console.log(buffer);
    //         console.log([objIdx, e.message])
    //     }
    // })

}) ();