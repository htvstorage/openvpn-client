const express = require('express');
const http = require('http');
//, 'Flash Socket', 'AJAX long-polling'
const socketIo = require('socket.io', {
  maxHttpBufferSize: 1e11, rememberTransport: false,
  // transports: ['WebSocket', 'Flash Socket', 'AJAX long-polling'] 
})
const app = express();
const server = http.createServer(app);
const io = socketIo(server);
const numeral = require('numeral');
const { map } = require('./symbols.js')

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

enpoint = ['symbol', 'history', 'detail', 'chart2Row', 'timeline', 'timelinemulti']
enpoint.forEach(ep => {
  app.get(`/${ep}`, (req, res) => {
    res.sendFile(__dirname + `/public/${ep}.html`);
  });
})

// Emit dynamic data to connected clients via WebSocket
setInterval(() => {
  const dynamicData = {
    labels: ['Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange'],
    data: Array(6).fill().map(() => Math.floor(Math.random() * 20)),
  };
  io.emit('updateData', dynamicData);
}, 2000);

let client = null;
let mapTopicClient = {}
let mapClient = {}
io.on('connection', (socket) => {
  const clientIP = socket.handshake.address;
  console.log(`Client connected with IP: ${clientIP}`, socket.id);
  // console.log('A user connected', JSON.stringify(socket));


  socket.on('subscriber', (message) => {
    mapClient[socket.id] = socket;
    console.log('Message from client: ', message);
    if (message.topic) {
      if (!mapTopicClient[message.topic]) mapTopicClient[message.topic] = {}
      mapTopicClient[message.topic][socket.id] = socket;
    }

    if (message.topic = 'updateDataSymbol') {
      if (lastSymbolData) {
        console.log('Emit lastSymbolData', Object.keys(lastSymbolData).length)
        socket.emit('updateDataSymbolAll', lastSymbolData)
      }

    }
    // io.emit('message-from-server', 'Server received: ' + message);
  });

  socket.on('disconnect', () => {
    console.log('A user disconnected', socket.id);
    delete mapClient[socket.id]
    Object.keys(mapTopicClient).forEach(k => {
      if (mapTopicClient[k][socket.id]) delete mapTopicClient[k][socket.id]
    })
  });

  if (lastData)
    socket.emit('updateData', lastData);

  client = socket;
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

app.get('/api/getsymbolsdata', (req, res) => {
  console.log(`Req url`, req.url)
  res.json(lastSymbolData);
});

app.get('/api/getsymbols', (req, res) => {
  res.json(map);
});


app.get('/api/getcountsymbols', (req, res) => {
  res.json(countSymbol);
});


app.get('/api/getsymbolsdata2', (req, res) => {
  console.log(`Req url`, req.url)
  let jsdata = Object.values(lastSymbolData).map(e => {
    return e.data.data;
  })
  res.json({
    data: jsdata,
    recordsTotal: jsdata.length,
    recordsFiltered: jsdata.length
  });
});

app.get('/api/symboldetail', (req, res) => {
  console.log(`Req url`, req.url)

  const url = new URL('http://local.com/' + req.url);

  // Lấy tất cả các tham số truy vấn dưới dạng một đối tượng URLSearchParams
  const queryParams = url.searchParams;
  var symbols = queryParams.get('symbols');
  if (!symbols) {
    return []
  }
  console.log('Symbol', symbols)

  if (symbols) {
    symbols = symbols.split(',')
  }


  let out = symbols.map(s => {
    let jsdata = []
    let dataacum = []
    if (symbolDataSeries[s]) {
      jsdata = Object.keys(symbolDataSeries[s]).filter(k => k != 'dataacum').map(e=>symbolDataSeries[s][e])
      dataacum = symbolDataSeries[s].dataacum
    }
    return {
      symbol: s,
      data: jsdata,
      dataacum: dataacum,
      recordsTotal: jsdata.length,
      recordsFiltered: jsdata.length
    }
  })
  res.json(out);
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
let countSymbol = 0;
let countUpdate = 0;
let lastSymbolData = {}
let symbolDataSeries = {}

worker.on("message", (data) => {
  emitData(data)
});

let mapLastData = {}

function emitData(data) {
  if (data.type == '0') {
    lastData = data
    io.volatile.emit('updateData', data);
    countUpdate++;
    if (countUpdate % 1000 == 0) { console.log("Count Update", countUpdate, countSymbol) }

  } else if (data.type == '1') {
    countSymbol++;
    lastSymbolData[data.data.data[0]] = data
    if (countSymbol % 1000 == 0) { console.log("Count symbols", countSymbol) }
    io.volatile.emit('updateDataSymbol', data);
  } else if (data.type == '2') {
    // countSymbol++;
    if (!symbolDataSeries[data.data.symbol]) symbolDataSeries[data.data.symbol] = {}
    symbolDataSeries[data.data.symbol][data.data.time] = data.data
    symbolDataSeries[data.data.symbol].dataacum = data.dataacum
  }
}

let workerQueue = []

let start = 0;
let count = 0
let running = false;
async function emit() {
  if (running) return;
  running = true;
  if (workerQueue.length > 0 && start == 0) start = Date.now() - 1;
  while (workerQueue.length > 0) {
    let data = workerQueue.shift();
    emitData(data)
    count++;
    if (count * 1000 / (Date.now() - start) > 800) {
      break;
    }
    if (count % 1000 == 0) {
      console.log("count", count, "tps", count * 1000 / (Date.now() - start))
    }

  }
  running = false;
}

setInterval(() => {
  emit()
}, 10000)
worker.on("error", (msg) => {
  console.log('Worker thread error', msg)
});


function wait(ms) {
  return new Promise(resolve => {
    setTimeout(() => {
      resolve(0);
    }, ms);
  });
}


const query = new Worker("./query_worker.js");

query.postMessage({ 'hello': 'hello' })

