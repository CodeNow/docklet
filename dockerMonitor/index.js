var fs = require('fs');
var ip = require('../lib/ip');
var vitals = require('../lib/vitals');
var report = require('../lib/report');
var configs = require('../lib/configs');
var Tail = require('tail').Tail;

var tail = module.exports = new Tail(configs.dockerLog);

tail
  .on('line', reportRestarts)
  .on('error', console.error.bind(console));

function reportRestarts (log) {
  if (~log.toString().indexOf('Listening for HTTP on tcp')) {
    var data = vitals.getReport();
    data.ip = ip;
    var err = new Error('Docker restarted!');
    report.reportError(err.message, err, { data: data });
    report.reportEvent(err.message);
  }
}