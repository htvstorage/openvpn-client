// const express = require('express');
// const bodyParser = require('body-parser');
// const Chart = require('chart.js');

// const app = express();
import express from 'express';
import bodyParser from 'body-parser';
import * as Chart from 'chart.js';
import { createCanvas, loadImage } from 'canvas';
import fs from 'fs';
const app = express();
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// const express = require('express');
// const { createCanvas, loadImage } = require('canvas');
// const fs = require('fs');

// const app = express();
const port = 3000;

// Dữ liệu chứng khoán nến
const data = [
  { open: 10, close: 15, high: 20, low: 5 },
  { open: 15, close: 20, high: 25, low: 10 },
  { open: 20, close: 10, high: 22, low: 8 },
  { open: 10, close: 5, high: 15, low: 3 },
  { open: 5, close: 10, high: 12, low: 2 },
  { open: 10, close: 8, high: 12, low: 6 },
  { open: 8, close: 12, high: 15, low: 5 },
];

app.get('/', (req, res) => {
  // Kích thước canvas
  const width = 800;
  const height = 600;

  // Tạo canvas mới
  const canvas = createCanvas(width, height);
  const ctx = canvas.getContext('2d');

  // Vẽ đồ thị chứng khoán nến
  const margin = 20;
  const candleWidth = (width - margin * 2) / data.length;
  const maxPrice = Math.max(...data.map(d => d.high));
  const minPrice = Math.min(...data.map(d => d.low));
  const priceRange = maxPrice - minPrice;
  const candleHeight = (height - margin * 2) / priceRange;

  ctx.fillStyle = 'white';
  ctx.fillRect(0, 0, width, height);

  data.forEach((d, i) => {
    const x = margin + i * candleWidth;
    const openY = height - margin - (d.open - minPrice) * candleHeight;
    const closeY = height - margin - (d.close - minPrice) * candleHeight;
    const highY = height - margin - (d.high - minPrice) * candleHeight;
    const lowY = height - margin - (d.low - minPrice) * candleHeight;
    const color = d.open > d.close ? 'red' : 'green';

    ctx.fillStyle = color;
    ctx.fillRect(x, openY, candleWidth, closeY - openY);
    ctx.strokeStyle = color;
    ctx.beginPath();
    ctx.moveTo(x + candleWidth / 2, highY);
    ctx.lineTo(x + candleWidth / 2, lowY);
    ctx.stroke();
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

