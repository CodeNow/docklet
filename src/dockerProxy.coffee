configs = require './configs'
Docker = require 'dockerode'

module.exports = () ->
  return new Docker({
    host: 'http://localhost',
    port: 4243
  })