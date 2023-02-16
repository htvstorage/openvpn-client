import path from 'path';
let __dirname = "./";
export default  {
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

