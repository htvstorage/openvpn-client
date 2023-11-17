const fs = require('fs');
const arrow = require('apache-arrow');

// Sample data to write to the Parquet file
const dataToWrite = [
  { column1: 123, column2: 123, column3: 123 },
  { column1: 123, column2: 456, column3: 123 },
  // Add more rows as needed
];

// Define schema for the Parquet file

console.log(JSON.stringify(arrow))
const schema = new arrow.Schema([
  { name: 'column1', type: new arrow.Int},
  { name: 'column2', type: new arrow.Int },
  { name: 'column3', type: new arrow.Int },
  // Add more fields as needed
]);

// Create an Arrow Table from the data and schema
const table = new arrow.Table({ columns: dataToWrite, schema });

// Write the Arrow Table to a Parquet file
arrow.writeParquet(table, 'output.parquet')
  .then(() => console.log('Parquet file written successfully'))
  .catch((error) => console.error(`Error writing Parquet file: ${error.message}`));
