// const express = require('express');
// const bodyParser = require('body-parser');
// const Chart = require('chart.js');

// const app = express();
import express from 'express';
import bodyParser from 'body-parser';
// import {Chart} from 'chart.js';
import { createCanvas, loadImage } from 'canvas';
import fs from 'fs';

import pkg2 from 'chart.js';
const {Chart} = pkg2;

import pkg from 'chartjs-chart-financial';
const { OhlcElement, OhlcController, CandlestickElement, CandlestickController } = pkg;
// import { OhlcElement, OhlcController, CandlestickElement, CandlestickController } from 'chartjs-chart-financial'
// import Chart from 'chart.js/auto' // Easy way of importing everything

Chart.register(OhlcElement, OhlcController, CandlestickElement, CandlestickController)

const app = express();
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// const express = require('express');
// const { createCanvas, loadImage } = require('canvas');
// const Chart = require('chart.js');
// const fs = require('fs');

const port = 3000;

// Dữ liệu chứng khoán nến
const data = [
  { t: 1, o: 10, c: 15, h: 20, l: 5 },
  { t: 2, o: 15, c: 20, h: 25, l: 10 },
  { t: 3, o: 20, c: 10, h: 22, l: 8 },
  { t: 4, o: 10, c: 5, h: 15, l: 3 },
  { t: 5, o: 5, c: 10, h: 12, l: 2 },
  { t: 6, o: 10, c: 8, h: 12, l: 6 },
  { t: 7, o: 8, c: 12, h: 15, l: 5 },
];

app.get('/', (req, res) => {
  // Tạo canvas mới
  const canvas = createCanvas(800, 600);
  const ctx = canvas.getContext('2d');

  // Tạo biểu đồ
  const chart =  new Chart(ctx, {
    type: 'candlestick',
    data: {
      datasets: [{
        label: 'Data',
        data: data.map(d => ({
          x: d.t,
          y: [d.o, d.h, d.l, d.c],
        })),
        borderColor: 'black',
        risingFillColor: 'green',
        fallingFillColor: 'red',
        pointWidth: 10,
      }],
    },
    options: {
      responsive: false,
      scales: {
        xAxes: [{
          type: 'linear',
          position: 'bottom',
          ticks: {
            stepSize: 1,
          },
        }],
        yAxes: [{
          ticks: {
            beginAtZero: false,
          },
        }],
      },
    },
  });

  // Lưu ảnh thành file và gửi phản hồi về trình duyệt
  const buffer = canvas.toBuffer('image/png');
  res.writeHead(200, {
    'Content-Type': 'image/png',
    'Content-Length': buffer.length,
  });
  res.end(buffer);
});

app.listen(port, () => console.log(`Server is listening on port ${port}.`));