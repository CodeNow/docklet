configs = require './configs'
bouncy = require 'bouncy'
net = require 'net'
http = require 'http'
socket = typeof configs.socket == 'string' && configs.socket || undefined
port = typeof configs.socket == 'number' && configs.socket || undefined
hostname =  typeof configs.socket == 'number' && 'localhost' || undefined

startProxy = ->
  server = bouncy socket && socketBounce || portBounce
  server.listen 4243

req = http.request 
  socketPath: socket
  port: port
  hostname: hostname
  path: '/version'
  method: 'GET'
, startProxy

req.on 'error',  (err) ->
  console.error 'failed to connect', err
  setTimeout process.exit, 5 * 1000, 1

req.end()


socketBounce = (req, res, bounce) ->
  bounce net.connect socket

portBounce = (req, res, bounce) ->
  bounce port
