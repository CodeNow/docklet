var configs = require('./configs');
var dockerHost = configs.docker_host;
var bouncerPort = configs.bouncer_port;
var Docker = require('dockerode');
var dogerode = require('dogerode');

var docker = new Docker({
  host: dockerHost,
  port: bouncerPort
});

docker = dogerode(docker, {
  service: 'docklet'
});

module.exports = function() {
  return docker;
};