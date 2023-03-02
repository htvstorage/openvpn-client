// const express = require('express');
// const bodyParser = require('body-parser');
// const Chart = require('chart.js');

// const app = express();
import express from 'express';
import bodyParser from 'body-parser';
import * as Chart from 'chart.js';

const app = express();
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// Dữ liệu giá chứng khoán
const data = [
  { date: '01/01/2022', open: 100, high: 120, low: 80, close: 110 },
  { date: '02/01/2022', open: 110, high: 130, low: 90, close: 120 },
  { date: '03/01/2022', open: 120, high: 140, low: 100, close: 130 },
  { date: '04/01/2022', open: 130, high: 150, low: 110, close: 140 },
  { date: '05/01/2022', open: 140, high: 160, low: 120, close: 150 }
];

// Tạo đồ thị
const canvas = `<canvas id="myChart" width="400" height="400"></canvas>`;
app.get('/', (req, res) => {
  res.send(canvas);
  const ctx = document.getElementById('myChart').getContext('2d');
  const chart = new Chart(ctx, {
    type: 'candlestick',
    data: {
      datasets: [{
        label: 'Stock Price',
        data: data.map(d => ({
          t: new Date(d.date),
          o: d.open,
          h: d.high,
          l: d.low,
          c: d.close
        }))
      }]
    },
    options: {
      scales: {
        xAxes: [{
          type: 'time'
        }]
      }
    }
  });
});

const port = 3000;
app.listen(port, () => console.log(`Server is running on port ${port}`));

