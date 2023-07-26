const MetricsBenchmark = require('./index.js');
const { promisify } = require('util');
const sleepNanos = promisify(setImmediate);

// Initialize the MetricsBenchmark instance
const metrics = MetricsBenchmark.getInstance();

// Assuming you have a function to process messages and measure performance
function processMessage() {
  const incomingTime = Number(process.hrtime.bigint()); // Get the current time in nanoseconds
  // Process your message here
  const messageSize = 100; // Replace with the actual size of the message
  // console.log(incomingTime)
  // Call the statisticMetris method to measure performance
  
  metrics.statisticMetris(incomingTime, messageSize, 'My Object');
}


let maxtps = 10000;
const start = Date.now();
// Simulate processing messages
(async () =>{
for (let i = 0; i < 10000000000; i++) {
  let end = Date.now();
  while(i*1000/(end - start) >= maxtps){
    await sleepNanos(10)
    end = Date.now();
  }
  processMessage();
}
})()
const incomingTime = process.hrtime.bigint()
console.log(incomingTime)