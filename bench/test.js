const MetricsBenchmark = require('./index.js');

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

// Simulate processing messages
for (let i = 0; i < 10000000000; i++) {
  processMessage();
}

const incomingTime = process.hrtime.bigint()
console.log(incomingTime)