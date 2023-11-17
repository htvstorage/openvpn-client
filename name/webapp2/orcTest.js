const fs = require('fs');
const arrow = require('apache-arrow');



const table = arrow.tableFromIPC([
    'latlong/schema.arrow',
    'latlong/records.arrow'
].map((file) => fs.readFileSync(file)));

console.table([...table]);