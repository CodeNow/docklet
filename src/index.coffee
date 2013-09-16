configs = require './configs'
docker = require './docker'
dockerjs = require 'docker.js'
redis = require 'redis'
pubsub = redis.createClient configs.redisPort, configs.redisHost
client = redis.createClient configs.redisPort, configs.redisHost
dockerClient = dockerjs host: "http://#{configs.docker_host}:#{configs.docker_port}"

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
        , lockCount * 100 + Math.random() * 50
    else if key is 'dockletPrune'
      whitelist = data
      dockerClient.listContainers (err, containers) ->
        if err then console.error err else
          containers.forEach (container) ->
            containerId = container.Id
            if not (containerId in whitelist)
              dockerClient.inspectContainer containerId, (err, res) ->
                if err then console.error err else
                  if res.State
                    if not res.State.Running
                      dockerClient.removeContainer containerId, (err) ->
                        if err then console.error err
    else
      throw new Error "Docklet received unknown message: #{key}"
  catch err
    console.error err

pubsub.subscribe 'dockletRequest'
pubsub.subscribe 'dockletPrune'
