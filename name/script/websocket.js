import WebSocket from 'ws';

const ws = new WebSocket('wss://live.tradingeconomics.com/socket.io/?key=20220413&url=%2Fcommodities&EIO=4&transport=websocket&sid=OUwfbGHIX6kagS2_ASyw');

ws.on('open', function() {
  console.log('WebSocket connection established');
  ws.send('Hello, server!');
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