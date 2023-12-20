import fs from "fs"
import xlsx from "xlsx"

function writeArrayJson2Xlsx(filename, ...args) {
  let workbook = xlsx.utils.book_new();
  args.forEach(s => {
    let worksheet = xlsx.utils.json_to_sheet(s);
    xlsx.utils.book_append_sheet(workbook, worksheet);
  })
  xlsx.writeFile(workbook, filename);
}

function writeArrayJson2XlsxNew(filename, ...args) {
  let workbook = xlsx.utils.book_new();
  args.forEach(s => {
    let worksheet = xlsx.utils.json_to_sheet(s.data);
    if (s.name)
      xlsx.utils.book_append_sheet(workbook, worksheet, s.name);
    else
      xlsx.utils.book_append_sheet(workbook, worksheet);
  })
  xlsx.writeFile(workbook, filename);
}


(async () => {
  var args = process.argv.slice(2);

  let convert = (f) => {
    let data = fs.readFileSync(f, 'utf-8');
    data = data.split('\n').filter(l => l.length > 0).map(e => e.split(','))
    var head = data[0];
    data = data.slice(1)
    let newData = []
    data.forEach(e => {
      var ne = {}
      head.forEach((k, i) => {
        if (k === '"symbol"' || k === '"date"') {
          ne[k] = e[i]
        } else {
          ne[k] = +e[i]
        }
      })
      newData.push(ne)
    });
    var nf = f.slice(0, f.length - 3) + "xlsx";

    // fs.writeFileSync(nf, JSON.stringify(newData))
    writeArrayJson2XlsxNew(nf, { data: newData })
    console.log(`Done ${nf}`)
  }

  for (let f of args) {
    convert(f)
  }


})()


