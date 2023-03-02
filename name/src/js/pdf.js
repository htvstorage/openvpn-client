import fs from 'fs';
// import pdfjsLib from 'pdfjs-dist';
import pdfjsLib from "pdfjs-dist/legacy/build/pdf.js";
import path, { resolve } from "path";
// global.structuredClone = (val) => JSON.parse(JSON.stringify(val))
async function readPDF(pdfPath) {
  const rawData = fs.readFileSync(pdfPath);
  const pdfDoc = pdfjsLib.getDocument(rawData);
//   const doc = await pdfDoc.promise;
//   console.log(doc.numPages)
  return pdfDoc.promise.then(function(pdf) {
    const numPages = pdf.numPages;
    console.log(numPages)
    const pageInfoPromises = [];

    for (let i = 1; i <= numPages; i++) {
      const pageInfoPromise = pdf.getPage(i).then( async function(page) {
        const viewport = page.getViewport({ scale: 1.0 });
        const pageText = await page.getTextContent();        
        return pageText.items != null? pageText.items.map(function(item) {
          const transform = viewport.transform;
          const x = item.transform[4] * transform[0] + item.transform[5] * transform[2] + transform[4];
          const y = item.transform[4] * transform[1] + item.transform[5] * transform[3] + transform[5];
          return { x: x, y: y, text: item.str };
        }) : {};
      });
      pageInfoPromises.push(pageInfoPromise);
    }

    return Promise.all(pageInfoPromises).then(function(pages) {
      return pages.reduce(function(result, page) {
        return result.concat(page);
      }, []);
    });
  });
}

readPDF(path.join('./pdf/20230106_20230106___thong_ke_giao_dich_tu_doanh.pdf')).then(function(items) {
  console.log(items);
}).catch(function(err) {
  console.error(err);
});