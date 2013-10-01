configs = require './configs'
async = require 'async'
docker = require './docker'
redis = require 'redis'
containerCount = require './containerCount'
ip = require './ip'
client = redis.createClient configs.redisPort, configs.redisHost


dockletRequestQueue = module.exports = async.queue (data, cb) ->
  docker.findImage data.repo, (err) ->
    if err then return cb err else
    client.setnx "#{data.servicesToken}:dockletLock", true, (err, lock) ->
      if (err)
        throw err
      if (lock)
        count = containerCount.incCount()
        setTimeout cb, 1500 + count * 100
        # console.log "docklet aquired the lock to run image #{data.repo}"
        client.publish "#{data.servicesToken}:dockletReady", ip
      else
        # console.log "docklet did not win the race to start a container from image #{data.repo}"
        cb()