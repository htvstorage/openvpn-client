import WebSocket from 'ws';

const ws = new WebSocket('wss://pricestream-iboard.ssi.com.vn/realtime');

ws.on('open', function() {
  console.log('WebSocket connection established');
  ws.send('{"type":"sub","topic":"serverName"}');
});

ws.on('message', function(message) {
  console.log(`Received message: ${message}`);
});

ws.on('close', function() {
  console.log('WebSocket connection closed');
});

ws.on('error', function(error) {
  console.log(`WebSocket error: ${error}`);
});