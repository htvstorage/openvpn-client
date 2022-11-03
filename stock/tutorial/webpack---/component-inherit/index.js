
module.exports = function(a, b){
  var fn = function(){};
  fn.prototype = b.prototype;
  a.prototype = new fn;
  a.prototype.constructor = a;
};


//////////////////
// WEBPACK FOOTER
// ./~/component-inherit/index.js
// module id = 37
// module chunks = 0