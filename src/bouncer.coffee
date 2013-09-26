bouncy = require 'bouncy'
net = require 'net'

server = bouncy (req, res, bounce) ->
  bounce net.connect '/var/run/docker.sock')
server.listen 4243