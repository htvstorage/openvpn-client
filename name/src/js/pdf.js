import fs from 'fs';
// import pdfjsLib from 'pdfjs-dist';
import pdfjsLib from "pdfjs-dist/legacy/build/pdf.js";
import path, { resolve } from "path";
import { PDFDocument, PDFName ,PDFArray,rgb,PDFString,PDFPage, PDFObject} from 'pdf-lib';

// const translate = require('@saipulanuar/google-translate-api');
import translate from '@iamtraction/google-translate'
import { join } from "path"
// npm install --save @iamtraction/google-translate
function wait(ms) {
  return new Promise(resolve => {
    setTimeout(() => {
      resolve(0);
    }, ms);
  });
}

let dic = fs.readFileSync("sort.dic")
let dics = new String(dic).split("\n");
let dicm = {}
for (let l of dics) {
  if (l.length == 0) continue;
  let json = JSON.parse(l);
  dicm[json.title.toLowerCase()] = json;
}

// global.structuredClone = (val) => JSON.parse(JSON.stringify(val))
async function readPDF(pdfPath) {
  const rawData = fs.readFileSync(pdfPath);
  const pdfDoc = pdfjsLib.getDocument(rawData);
  //   const doc = await pdfDoc.promise;
  //   console.log(doc.numPages)
  return pdfDoc.promise.then(function (pdf) {
    const numPages = pdf.numPages;
    console.log(numPages)
    const pageInfoPromises = [];

    for (let i = 1; i <= numPages; i++) {
      const pageInfoPromise = pdf.getPage(i).then(async function (page) {
        const viewport = page.getViewport({ scale: 1.0 });
        const pageText = await page.getTextContent();
        let comment = "";
        let items = pageText.items != null ? pageText.items.map(function (item) {
          const transform = viewport.transform;
          const x = item.transform[4] * transform[0] + item.transform[5] * transform[2] + transform[4];
          const y = item.transform[4] * transform[1] + item.transform[5] * transform[3] + transform[5];
          return { x: x, y: y, text: item.str };
        }) : {};

        items.sort((a, b) => {
          let x1 = a.y - b.y;
          let x2 = a.x - b.x;

          return x1 < 0 ? -1 : x1 > 0 ? 1 : x2 < 0 ? -1 : x2 > 0 ? 1 : 0

        })

        items.forEach(e => {
          comment += e + "\n"
        })

        const pageX = pdflibDoc.getPages()[i-1];
        // console.log(pageX)
        const { width, height } = pageX.getSize();
        // Add a text annotation to the page
        const textAnnotation = pdflibDoc.context.obj({
          Type: 'Annot',
          Subtype: 'Text',
          Open: true, 
          Contents: PDFString.of('This is a text annotation'),
          Rect: [50, height - 100, 150, height - 120],
          Color: [0, 0, 1],
        });



      // //   const annotation = pdfDoc.context.obj({
      // //     Type: 'Annot',
      // //     Subtype: 'Text',
      // //     Open: false,    // Is the annotation open by default?
      // //     Name: 'Note',   // Determines the icon to place in the document.
      // //     Rect: [ props.x, props.y, props.x + props.width, props.y + props.height ],  // The position of the annotation

      // //     Contents: PDFString.of(props.text)    // The annotation text
      // // });
        // const annotationRef = pdflibDoc.context.register(textAnnotation);
        // Add the annotation to the page
        // pageX.node.Annots().push(annotationRef);
        const x = 100;
        const y = 100;
        const annotation = pageX.drawText('This is a text annotation', {
          x,
          y,
          size: 12,
          color: rgb(0, 0, 1),
        });
        pageX.node.set('Annots', [11111]);
        // console.log(pageX.node.Annots)
        
        // Add the annotation to the page
        // pageX.addAnnotation(annotation);

        // const annotationRef = pdflibDoc.context.register(textAnnotation);  // Register the annotation in the document.
        // console.log("Annotation added:", annotationRef);
        // Find the Annots dictionary on the current page and add the new annotation to it.
        // const annots = pageX.node.lookup(PDFName.of('Annots'), PDFArray);
        // annots.push(annotationRef);





        // const textField = pageX.addWidget({
        //   type: 'TextField',
        //   x: 50,
        //   y: 700,
        //   width: 200,
        //   height: 20,
        //   fieldFlags: ['ReadOnly'],
        //   font: await pdflibDoc.embedFont('Helvetica'),
        //   fontSize: 12,
        //   borderColor: [0, 1, 0],
        // });

        pageX.drawText('You can modify PDFs too!')
        await pdflibDoc.save()
        // const cmt = pdflibDoc.c
        // pdflibDoc.getPages()[i].addAnnotation(cmt);

        // const textAnnotation = pdflibDoc.createTextAnnotation({
        //   contents: 'This is a text annotation',
        //   color: rgb(0, 0, 1),
        //   size: 12,
        //   x: 50,
        //   y: height - 100,
        //   width: 100,
        //   height: 20,
        // });
        
        // // Add the annotation to the page
        // pageX.addAnnotation(textAnnotation);       
        return items;
      });
      pageInfoPromises.push(pageInfoPromise);
    }

    return Promise.all(pageInfoPromises).then(function (pages) {
      return pages.reduce(function (result, page) {
        return result.concat(page);
      }, []);
    });


  });
}


// let pdfFile='./pdf/20230106_20230106___thong_ke_giao_dich_tu_doanh.pdf'
let pdfFile = './Profile Download and Installation Procedure.pdf'
let pdfFileNew = './New_Profile Download and Installation Procedure.pdf'
const pdfData = fs.readFileSync(pdfFile);
const pdflibDoc = await PDFDocument.load(pdfData);


readPDF(path.join(pdfFile)).then(async function (items) {
  console.log(items);
  const pdfBytes = await pdflibDoc.save();
  fs.writeFileSync(pdfFileNew, pdfBytes)
}).catch(function (err) {
  console.error(err);
});

