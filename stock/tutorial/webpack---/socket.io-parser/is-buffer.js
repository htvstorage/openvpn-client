
module.exports = isBuf;

/**
 * Returns true if obj is a buffer or an arraybuffer.
 *
 * @api private
 */

function isBuf(obj) {
  return (global.Buffer && global.Buffer.isBuffer(obj)) ||
         (global.ArrayBuffer && obj instanceof ArrayBuffer);
}



//////////////////
// WEBPACK FOOTER
// ./~/socket.io-parser/is-buffer.js
// module id = 16
// module chunks = 0