var require = ('newrelic');
var httpProxy = require('http-proxy');
var net = require('net');
var http = require('http');
var configs = require('../lib/configs');
var dockerHost = configs.docker_host;
var dockerPort = configs.docker_port;
var bouncerPort = configs.bouncer_port;
var Docker = require('dockerode');
var docker = new Docker({
    host: dockerHost,
    port: dockerPort
  });

var retryCount = 0;

// sends command to docker to ensure it is alive and start proxy if its alive
function connectToDocker() {
  docker.version(function(err, versionInfo) {
    if (err) {
      retryCount++;
      console.log('failed to connect to docker, retryCount = '+retryCount+' err:', err);
      setTimeout(connectToDocker, 500);
      return err;
    }
    startProxy();
  });
}

// start proxying to docker
function startProxy(req, res) {
  console.log("connected to docker. listening on port: "+bouncerPort);
  httpProxy.createProxyServer({
    target: dockerHost+':'+dockerPort
  }).listen(bouncerPort);
}

connectToDocker();