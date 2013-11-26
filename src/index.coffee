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
app.listen 4244
docker.cacheImages (err) ->
  if err
  	console.error 'failed to cache', err
  	process.exit 1
  else
    console.log 'cached'
    require './pubsub'
    require './kue'

if !env('development')
  setTimeout ->
    require('./kue').shutdown ->
      setTimeout ->
        require('child_process').exec 'reboot'
      , configs.doomTime / 10
    , configs.doomTime / 10
  , configs.doomTime + (Math.random() * configs.doomTime / 2)
