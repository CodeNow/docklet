configs = require './configs'
if configs.nodetime
  nodetime = require 'nodetime'
  nodetime.profile configs.nodetime
docker = require './docker'
app = require './app'
app.listen 4244
docker.cacheImages (err) ->
  if err then throw err else
    require './pubsub'
    require './kue'
