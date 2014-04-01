configs = require('./configs')
dockerHost = configs.docker_host
bouncerPort = configs.bouncer_port
Docker = require 'dockerode'

module.exports = () ->
  return new Docker({
    host: dockerHost,
    port: bouncerPort
  })