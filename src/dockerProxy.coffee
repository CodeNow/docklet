configs = require('./configs')
dockerHost = configs.docker_host
dockerPort = configs.docker_port
Docker = require 'dockerode'

module.exports = () ->
  return new Docker({
    host: dockerHost,
    port: dockerPort
  })