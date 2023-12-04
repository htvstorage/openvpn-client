const { parentPort } = require("worker_threads");
const WebSocket = require('ws');
const fs = require('fs')
const moment = require('moment')
const xlsx = require("xlsx")
const numeral = require('numeral');


parentPort.on("message", (msg) => {
    console.log('=================================================================================================',msg);
});