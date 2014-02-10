configs = require './configs'
bouncy = require 'bouncy'
net = require 'net'
http = require 'http'

socket = configs.socket

startProxy = ->
  server = bouncy socketBounce
  server.listen 4243

req = http.request 
  socketPath: socket
  path: '/version'
  method: 'GET'
, startProxy

req.on 'error',  (err) ->
  console.error 'failed to connect', err
  setTimeout process.exit, 5 * 1000, 1

req.end()

socketBounce = (req, res, bounce) ->
  bounce net.connect socket
