configs = require './configs'
if configs.nodetime
  nodetime = require 'nodetime'
  nodetime.profile configs.nodetime
async = require 'async'
docker = require './docker'
dockerjs = require 'docker.js'
os = require 'os'
redis = require 'redis'
pubsub = redis.createClient configs.redisPort, configs.redisHost
client = redis.createClient configs.redisPort, configs.redisHost
dockerClient = dockerjs host: "http://#{configs.docker_host}:#{configs.docker_port}"
numCPUs = os.cpus().length

ip = if configs.networkInterface == 'lo0'
   'localhost'
else
  require("os")
    .networkInterfaces()[configs.networkInterface]
    .filter((iface) ->
      iface.family is "IPv4"
    )[0].address

lockCount = 0

pubsub.on 'message', (key, json) ->
  try
    data = JSON.parse json
    if key is 'dockletRequest'
      docker.findImage data.repo, (err) ->
        loaded = os.loadavg()[0] > (0.7 * numCPUs) ? 1.0 : 0
        setTimeout ->
          client.setnx "#{data.servicesToken}:dockletLock", true, (err, lock) ->
            if (err)
              throw err
            if (lock)
              lockCount++
              setTimeout ->
                lockCount--
              , 100
              # console.log "docklet aquired the lock to run image #{data.repo}"
              client.publish "#{data.servicesToken}:dockletReady", ip
            else
              # console.log "docklet did not win the race to start a container from image #{data.repo}"
        , lockCount * 100 + Math.random() * 50 + loaded * 1000 * 10
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
