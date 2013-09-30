configs = require './configs'
express = require 'express'
server = require './server'
ip = require './ip'
containerCount = require './containerCount'
docker = require './docker'
queue = require('redis').createClient configs.redisPort, configs.redisHost
app = express()

app.post '/create', (req, res, next) ->
  if docker.checkCache req.query.fromImage
    res.send 204
    setTimeout addSelf, 200 + 50 * containerCount.incCount()
  else
    res.send 404
    addSelf()

addSelf = ->
  queue.rpush 'docks', ip

server.on 'request', (req, res) ->
  if not /^\/count\//.test req.url
    app req, res

addSelf()

# setInterval addSelf, 1000 * 60 * 5
