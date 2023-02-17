import path from 'path';
let __dirname = "./";
const main = {
  entry: './src/test5.js',
  output: {
    filename: 'test5.js',
    path: path.resolve(__dirname, 'dist'),
  },
  target: 'node',
  mode: 'production',
};


const backend = {
  entry: './src/test2.js',
  output: {
    filename: 'test4.js',
    path: path.resolve(__dirname, 'dist'),
  },
  target: 'node',
  mode: 'production',
};

const multi = {
  entry: {
    filter: './src/filter.js',
    dudinh: './src/dudinh.js',
    getprices: './src/price.js',
    dumpdaily: './src/dumpdaily.js',
    buysell: './src/muaban.js',
  },
  output: {
    filename: '[name].bundle.js',
    path: path.resolve(__dirname, 'dist'),
  },
  target: 'node',
  mode: 'production',
};
export default [backend, main, multi];
