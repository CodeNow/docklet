configs = require './configs'
async = require 'async'
pubsub = require('redis').createClient configs.redisPort, configs.redisHost
dockerClient = require('docker.js')
  host: "http://" + configs.docker_host + ":" + configs.docker_port
  token: configs.authToken
dockletRequestQueue = require './dockletRequestQueue'

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