
var indexOf = [].indexOf;

module.exports = function(arr, obj){
  if (indexOf) return arr.indexOf(obj);
  for (var i = 0; i < arr.length; ++i) {
    if (arr[i] === obj) return i;
  }
  return -1;
};


//////////////////
// WEBPACK FOOTER
// ./~/indexof/index.js
// module id = 42
// module chunks = 0