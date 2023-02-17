import plotly from "plotly";
var y = [];

for (var i = 0; i <= 500000; i ++) {
	y[i] = Math.random();
}

const plot = plotly("trinhvanhung", "sA4eZJ1ZDhxO8uHe1bA1");

var data = [
  {
    x: y,
    type: "histogram"
  }
];
var graphOptions = {filename: "horizontal-histogram", fileopt: "overwrite"};
plot.plot(data, graphOptions, function (err, msg) {
    console.log(msg);
});