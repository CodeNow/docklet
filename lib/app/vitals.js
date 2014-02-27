var VitalSigns = require('vitalsigns');
var configs = require('../configs');

var vitals = new VitalSigns({
  autoCheck: 5000,
  httpHealthy: 200,
  httpUnhealthy: 503
});

vitals.monitor('cpu');

vitals.monitor('mem', {
  units: 'MB'
});

vitals.unhealthyWhen('cpu', 'usage').greaterThan(80);
vitals.unhealthyWhen('mem', 'free').lessThan(500);

setInterval(function() {
  return console.log('vitals', vitals.getReport());
}, configs.healthCheckInterval);

module.exports = vitals;