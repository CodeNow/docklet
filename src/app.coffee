configs = require './configs'
express = require 'express'
server = require './server'
ip = require './ip'
containerCount = require './containerCount'
docker = require './docker'
queue = require('redis').createClient configs.redisPort, configs.redisHost
app = express()

app.post '/create/:repo', (req, res, next) ->
  if docker.checkCache req.params.repo
    res.send 201
    setTimeout addSelf, 1000 + 100 * containerCount.incCount()
  else
    res.send 404
    addSelf()

addSelf = ->
  queue.rpush 'docks', ip

server.on 'request', (req, res) ->
  if not /^\/count\//.test req.url
    app req, res

server.on 'listening', addSelf