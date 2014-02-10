configs = require './configs'
bouncy = require 'bouncy'
net = require 'net'
http = require 'http'
request = require 'request'
url = require 'url'
socket = typeof configs.socket == 'string' && configs.socket || undefined
port = typeof configs.socket == 'number' && configs.socket || undefined
hostname =  typeof configs.socket == 'number' && 'localhost' || undefined
proxy = typeof configs.socket == 'string' && 'unix:/' + configs.socket || 'http://localhost:' + configs.socket

startProxy = ->
  server = http.createServer (req, res) ->
    urlObj = url.parse req.url
    urlObj.protocol = urlObj.protocol || 'http:'
    urlObj.hostname = urlObj.hostname || 'localhost'
    forward = request
      url: url.format urlObj
      proxy: proxy
      method: req.method
      headers: req.headers
    req.pipe forward
    forward.pipe res
    

  #server = bouncy socket && socketBounce || portBounce
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
