import { readFileSync } from 'fs';
import { tableFromIPC } from 'apache-arrow';

const arrow = readFileSync('simple.arrow');
const table = tableFromIPC(arrow);

console.table(table.toArray());