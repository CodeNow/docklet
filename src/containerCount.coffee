configs = require './configs'
docker = require('docker.js') {}
EventEmitter = require('events').EventEmitter
emitStream = require 'emit-stream'
JSONStream = require 'JSONStream'
shoe = require 'shoe'
http = require 'http'
redis = require 'redis'
count = null
ev = new EventEmitter
ip = require './ip'
server = http.createServer()
client = redis.createClient configs.redisPort, configs.redisHost

events = docker.events({})

events.on 'error', (err) ->
  console.error err

events.on 'data', (buf) ->
  console.log 'EVENT'
  try
    status = JSON.parse(buf).status
    if status is 'start'
      count++
      ev.emit 'count', count
    if status is 'die'
      count--
      ev.emit 'count', count
  catch e
    console.error e

setInterval () ->
  docker.listContainers (err, containers) ->
    if err then console.log err else
    count = containers.length
    ev.emit 'count', count
, 1000 * 60 * 5

sock = shoe (stream) ->
  emitStream(ev)
    .pipe(JSONStream.stringify())
    .pipe(stream)
  ev.emit 'count', count

sock.install server, '/count'

client.multi()
  .del("frontend:#{ip}.docks.#{configs.domain}")
  .rpush("frontend:#{ip}.docks.#{configs.domain}", ip)
  .rpush("frontend:#{ip}.docks.#{configs.domain}", "http://#{ip}:3000")
  .publish("dockup", "#{ip}.docks.#{configs.domain}")
  .exec (err) ->
    if err then throw err
    server.listen 3000
    client.quit()

module.exports.init = (cb) ->
  docker.listContainers (err, containers) ->
    if err then cb err else
    count = containers.length
    ev.emit 'count', count
    cb null

module.exports.getCount = () ->
  count

ev.on 'count', (count) ->
  console.log 'COUNT', count