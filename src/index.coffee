configs = require './configs'
docker = require './docker'
redis = require 'redis'
pubsub = redis.createClient configs.redisPort, configs.redisHost
client = redis.createClient configs.redisPort, configs.redisHost

ip = if configs.networkInterface == 'lo0'
   'localhost'
else
  require("os")
    .networkInterfaces()[configs.networkInterface]
    .filter((iface) ->
      iface.family is "IPv4"
    )[0].address

pubsub.on 'message', (key, json) ->
  try
    data = JSON.parse json
    docker.findImage data.repo, (err) ->
      client.setnx "#{data.servicesToken}:dockletLock", true, (err, lock) ->
        if (err) 
          throw err
        if (lock)
          # console.log "docklet aquired the lock to run image #{data.repo}"
          client.publish "#{data.servicesToken}:dockletReady", ip
        else
          # console.log "docklet did not win the race to start a container from image #{data.repo}"
  catch err
    console.error err

pubsub.subscribe 'dockletRequest'

