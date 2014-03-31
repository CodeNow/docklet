configs = require './configs'
bouncy = require 'bouncy'
net = require 'net'
http = require 'http'

socket = configs.socket

startProxy = ->
  server = bouncy socketBounce
  server.listen 4243
  setTimeout ->
    server.close()
    setTimeout ->
      process.exit()
    , 1000 * 60
  , configs.bounceWorkerLifeSpan + configs.bounceWorkerLifeSpan * Math.random()

req = http.request
  socketPath: socket
  path: '/version'
  method: 'GET'
, startProxy

req.on 'error',  (err) ->
  console.error 'failed to connect', err

req.end()

socketBounce = (req, res, bounce) ->
  console.log('req.url', req.url);
  console.log('req.url', req.url);
  console.log('req.url', req.url);
  bounce net.connect socket
