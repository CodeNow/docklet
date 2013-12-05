configs = require './configs'
async = require 'async'
pubsub = require('redis').createClient configs.redisPort, configs.redisHost
dockerClient = require('docker.js')
  host: "http://" + configs.docker_host + ":" + configs.docker_port
  token: configs.authToken
docker = require './docker'
client = require './client'
ip = require './ip'

pubsub.on 'message', (key, json) ->
  try
    data = JSON.parse json
    if key is 'dockletRequest'
      raceToFind data
    else if key is 'dockletPrune'
      whitelist = data
      dockerClient.listContainers queryParams:all:true, (err, containers) ->
        if err then console.error err else
          whitelistHash = {}
          whitelist.forEach (containerId) -> whitelistHash[containerId] = true
          containersToPrune = containers.filter (container) ->
            containerId = container.Id.substring 0, 12
            return not whitelistHash[containerId]
          pruneContainers containersToPrune
    else
      throw new Error "Docklet received unknown message: #{key}"
  catch err
    console.error err

pubsub.subscribe 'dockletPrune'
pubsub.subscribe 'dockletRequest'

pruneContainers = (containers) ->
  async.forEachSeries containers, pruneContainer, (err) ->
    if err then console.error err

pruneContainer = (container, cb) ->
  containerId = container.Id.substring 0, 12
  dockerClient.inspectContainer containerId, (err, res) ->
    if err then cb err else
      if not res.State or res.State.Running
        cb()
      else
        dockerClient.removeContainer containerId, cb

raceToFind = (data) ->
  docker.findImage data, (err) ->
    if err
      console.error err
    else
      client.setnx "#{data.servicesToken}:dockletLock", true, (err, lock) ->
        if (err)
          throw err
        if (lock)
          client.publish "#{data.servicesToken}:dockletReady", ip