var configs = require('./configs');
var ip;
if (configs.networkInterface === 'lo0') {
  var ip = 'localhost';
} else {
  ip = require("os")
    .networkInterfaces()[configs.networkInterface]
    .filter(function(iface) {
      return iface.family === "IPv4";
    })[0].address;
}

module.exports = ip;