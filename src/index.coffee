configs = require './configs'
rollbar = require 'rollbar'
if configs.rollbar
  rollbar.init configs.rollbar
docker = require './docker'
if configs.nodetime
  nodetime = require 'nodetime'
  nodetime.profile configs.nodetime
docker.cacheImages (err) ->
  if err then throw err else
    require './pubsub'
    require './kue'
