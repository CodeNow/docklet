configs = require './configs'
async = require 'async'
pubsub = require('redis').createClient configs.redisPort, configs.redisHost
dockerClient = require('docker.js')
  host: "http://" + configs.docker_host + ":" + configs.docker_port
  token: configs.authToken

pubsub.on 'message', (key, json) ->
  try
    data = JSON.parse json
    if key is 'dockletPrune'
      whitelist = data
      dockerClient.listContainers 
        queryParams: 
          all: true
      , (err, containers) ->
        if err 
          console.error err 
        else
          pruneContainers whitelist, containers
    else
      throw new Error "Docklet received unknown message: #{key}"
  catch err
    console.error err

pubsub.subscribe 'dockletPrune'

pruneContainers = (whitelist, containers) ->
  async.forEachSeries containers, (container, cb) ->
    pruneContainer whitelist, container, cb
  , (err) -> if err then console.error err

pruneContainer = (whitelist, container, cb) ->
  containerId = container.Id.substring 0, 12
  if containerId in whitelist 
    cb() 
  else
    dockerClient.inspectContainer containerId, (err, res) ->
      if err 
        cb err 
      else if not res.State or res.State.Running 
        cb() 
      else
        dockerClient.removeContainer containerId, cb