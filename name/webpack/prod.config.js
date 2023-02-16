import path from 'path';
let __dirname = "./";
const main = {
  entry: './src/test5.js',
  output: {
    filename: 'main.js',
    path: path.resolve(__dirname, 'dist'),
  },
  target: 'node',
  mode: 'production',
  module: {
    rules: [
      { test: /\.xlsx$/, loader: "webpack-xlsx-loader" }
    ]
  }
};


const backend = {
  entry: './src/test2.js',
  output: {
    filename: 'test4.js',
    path: path.resolve(__dirname, 'dist'),
  },
  target: 'node',
  mode: 'production',
  module: {
    rules: [
      { test: /\.xlsx$/, loader: "webpack-xlsx-loader" }
    ]
  }
};

export default [backend,main];
