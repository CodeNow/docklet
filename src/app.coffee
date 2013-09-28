configs = require './configs'
async = require 'async'
docker = require './docker'
dockerjs = require 'docker.js'
os = require 'os'
redis = require 'redis'
containerCount = require './containerCount'
ip = require './ip'
pubsub = redis.createClient configs.redisPort, configs.redisHost
client = redis.createClient configs.redisPort, configs.redisHost
dockerClient = dockerjs host: "http://#{configs.docker_host}:#{configs.docker_port}"
numCPUs = os.cpus().length

lockCount = 0

pubsub.on 'message', (key, json) ->
  try
    data = JSON.parse json
    if key is 'dockletRequest'
      dockletRequestQueue.push data, (err) ->
        if err then console.error err
    else if key is 'dockletPrune'
      whitelist = data
      dockerClient.listContainers queryParams: all: true, (err, containers) ->
        if err then console.error err else
          async.forEachSeries containers, (container, cb) ->
            containerId = container.Id.substring 0, 12
            if containerId in whitelist then cb() else
              dockerClient.inspectContainer containerId, (err, res) ->
                if err then cb err else
                  if not res.State then cb() else
                    if res.State.Running then cb() else
                      dockerClient.removeContainer containerId, cb
          , (err) -> if err then console.error err
    else
      throw new Error "Docklet received unknown message: #{key}"
  catch err
    console.error err

pubsub.subscribe 'dockletRequest'
pubsub.subscribe 'dockletPrune'

dockletRequestQueue = async.queue (data, cb) ->
  docker.findImage data.repo, (err) ->
    if err then return cb err else
    count = containerCount.getCount()
    delay = lockCount * 1500 + count * 200 + Math.random() * 100
    setTimeout ->
      client.setnx "#{data.servicesToken}:dockletLock", true, (err, lock) ->
        if (err)
          throw err
        if (lock)
          containerCount.incCount()
          lockCount++
          setTimeout ->
            lockCount--
          , 500
          # console.log "docklet aquired the lock to run image #{data.repo}"
          client.publish "#{data.servicesToken}:dockletReady", ip
        else
          # console.log "docklet did not win the race to start a container from image #{data.repo}"
        cb null
    , delay