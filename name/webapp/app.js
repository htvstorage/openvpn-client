const express = require('express');
const http = require('http');
const socketIo = require('socket.io', { rememberTransport: false, transports: ['WebSocket', 'Flash Socket', 'AJAX long-polling'] })
const app = express();
const server = http.createServer(app);
const io = socketIo(server);
const numeral = require('numeral');

// async function wpaf() {
//     const wpa = require('./watchPendingApp.js');
//     console.log("WPA",wpa)
// }



const port = 3000;

app.use(express.static('public'));

// Serve the master page (index.html)
app.get('/', (req, res) => {
  res.sendFile(__dirname + '/public/index.html');
});

// Serve each chart HTML page
for (let i = 1; i <= 10; i++) {
  app.get(`/chart${i}`, (req, res) => {
    res.sendFile(__dirname + `/public/chart${i}.html`);
  });
}

// Emit dynamic data to connected clients via WebSocket
setInterval(() => {
  const dynamicData = {
    labels: ['Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange'],
    data: Array(6).fill().map(() => Math.floor(Math.random() * 20)),
  };  
    io.emit('updateData', dynamicData);
}, 2000);

io.on('connection', (socket) => {
  const clientIP = socket.handshake.address;
  console.log(`Client connected with IP: ${clientIP}`);
  // console.log('A user connected', JSON.stringify(socket));
  if (lastData)
    socket.emit('updateData', lastData);
});



app.get('/api/data', (req, res) => {
  // Simulated dynamic data
  const dynamicData = {
    labels: ['Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange'],
    data: Array(6).fill().map(() => Math.floor(Math.random() * 20)),
  };
  dynamicData.data[0] = priceModel.BIDASK["VNINDEX"]
  res.json(dynamicData);
});

async function serverX() {

  server.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
  });

}

serverX()

const { Worker } = require("worker_threads");

const worker = new Worker("./worker.js");
let lastData = null;
worker.on("message", (data) => {
  // res.status(200).send(`result is ${data}`);
  // const dynamicData = {
  //   labels: ['Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange'],
  //   data: Array(6).fill().map(() => Math.floor(Math.random() * 20)),
  // };
  // for (let i = 0; i < 1000; i++) {
  // dynamicData.data[0] = priceModel.BIDASK["VNINDEX"]
  // dynamicData.data[1] = i
  // console.table(dynamicData)
  lastData = data;
  io.emit('updateData', data);
});
worker.on("error", (msg) => {
  // res.status(404).send(`An error occurred: ${msg}`);
});