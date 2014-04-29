var docker = require('../lib/dockerProxy')();
var Dogstatsy = require('dogstatsy');
var stats = new Dogstatsy({
  service: 'containerGauge'
});

setInterval(gaugePs, 1000 * 60);
setInterval(gaugePsa, 1000 * 60 * 10);
setInterval(gaugeInfo, 1000 * 60);

function gaugePs () {
  docker.listContainers(reportContainers);
  function reportContainers (err, containers) {
    if (err) {
      console.error(err);
    } else {
      stats.gauge('docker.containers.running', containers.length);
    }
  }
}

function gaugePsa () {
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

function gaugeInfo () {
  docker.info(reportInfo);
  function reportInfo (err, info) {
    if (err) {
      console.error(err);
    } else {
      var tags = {
        driver: info.Driver,
        executiondriver: info.ExecutionDriver
      };
      stats.gauge('docker.info.containers', info.Containers, tags);
      stats.gauge('docker.info.images', info.Images, tags);
      stats.gauge('docker.info.neventslistener', info.NEventsListener, tags);
      stats.gauge('docker.info.nfd', info.NFd, tags);
      stats.gauge('docker.info.ngoroutines', info.NGoRoutines, tags);
    }
  }
}