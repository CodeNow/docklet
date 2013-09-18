var async = require('async');
var configs = require('../lib/configs');
var docker = require('docker.js')({
  host: 'http://' + configs.docker_host + ':' + configs.docker_port
});


findSkeletons();



function findSkeletons () {
  docker.listContainers(filter);
}

function filter (err, containers) {
  if (err) {
    throw err;
  }
  console.log('LIST', containers.map(id));
  async.filterSeries(containers, top, applyHolyWater)
}

function id (container) {
  return container.Id;
}

function top (container, cb) {
  docker.listProcesses(container.Id, check);

  function check (err, processes) {
    if (err) {
      throw err;
    } 
    console.log('PROCESSESS', container.Id, processes.Processes === null);
    cb(processes.Processes === null);
  }
}

function applyHolyWater (containers) {
  console.log('SKELETONS', containers.map(id));
  async.eachSeries(containers, stop, celebrate);
}

function stop (container, cb) {
  docker.stopContainer(container.Id, dead);
  function dead (err) {
    console.log('DEAD', container.Id);
    cb(err);
  }
}

function celebrate (err) {
  if (err) {
    throw err;
  }
  console.log('cleaned dem skeletons');
  setTimeout(findSkeletons, 5000);
}

