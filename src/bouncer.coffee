bouncy = require 'bouncy'
net = require 'net'
http = require 'http'
socket = '/var/run/docker.sock'

startProxy = ->
  server = bouncy (req, res, bounce) ->
    console.log(req.url, req.method)
    bounce net.connect socket
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
  
