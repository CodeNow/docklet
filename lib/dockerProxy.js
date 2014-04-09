var configs = require('./configs');
var dockerHost = configs.docker_host;
var bouncerPort = configs.bouncer_port;
var Docker = require('dockerode');
var docker = new Docker({
    host: dockerHost,
    port: bouncerPort
  });

module.exports = function() {
  return docker;
};