var docker = require('../lib/dockerProxy')();
var Dogstatsy = require('dogstatsy');
var stats = new Dogstatsy({
  service: 'containerGauge'
});

setInterval(gaugePS, 1000 * 60);
setInterval(gaugePSA, 1000 * 60 * 10);

function gaugePS () {
  docker.listContainers(reportContainers);
  function reportContainers (err, containers) {
    if (err) {
      console.error(err);
    } else {
      stats.gauge('docker.containers.running', containers.length);
    }
  }
}

function gaugePSA () {
  docker.listContainers({
    all: true
  }, reportContainers);
  function reportContainers (err, containers) {
    if (err) {
      console.error(err);
    } else {
      stats.gauge('docker.containers.total', containers.length);
    }
  }
}
