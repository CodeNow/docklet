require 'newrelic'
path = require 'path'
env = require './env'
configs = require './configs'
rollbar = require 'rollbar'
path = require 'path'
rollbar.init(configs.rollbar, {
    environment process.env.NODE_ENV || "development",
    branch "master",
    root path.resolve(__dirname, '..')
  });

var path = require('path');

  environment: process.env.NODE_ENV || "development"
  branch: "master"
  root: path.resolve __dirname, '..'
if configs.nodetime
  nodetime = require 'nodetime'
  nodetime.profile configs.nodetime
docker = require './docker'
app = require './app'
app.use rollbar.errorHandler
docker.cacheImages (err) ->
  if err
    console.error 'failed to cache', err
    process.exit 1
  else
    console.log 'cached'
    require './pubsub'
    (require './register').register()
    app.listen 4244
    setInterval docker.checkUp, 1000 * 60
