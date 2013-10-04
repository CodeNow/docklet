configs = require './configs'
docker = require './docker'
if configs.nodetime
  nodetime = require 'nodetime'
  nodetime.profile configs.nodetime
containerCount = require './containerCount'
docker.cacheImages (err) ->
  if err then throw err else
    containerCount.init (err) ->
      if err then throw err else
      require './app'
      require './pubsub'
      require './jobs'
      require './kue'
