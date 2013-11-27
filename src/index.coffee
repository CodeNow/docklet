env = require './env'
configs = require './configs'
rollbar = require 'rollbar'
if configs.rollbar
  rollbar.init configs.rollbar
if configs.nodetime
  nodetime = require 'nodetime'
  nodetime.profile configs.nodetime
docker = require './docker'
app = require './app'
docker.cacheImages (err) ->
  if err
  	console.error 'failed to cache', err
  	process.exit 1
  else
    console.log 'cached'
    require './pubsub'
    app.listen 4244

if !env('development')
  setTimeout ->
    app.server.close ->
      setTimeout ->
        require('child_process').exec 'reboot'
      , configs.doomTime / 10
    , configs.doomTime / 10
  , configs.doomTime + (Math.random() * configs.doomTime / 2)
