express = require 'express'
vitals = require './vitals'
configs = require './configs'

app = module.exports = express()

app.use app.router
if (configs.nodetime)
  app.use require('nodetime').expressErrorHandler()
if (configs.rollbar)
  app.use require('rollbar').errorHandler()

app.post '/flatten', require './flatten'
app.post '/find', express.json(), require './find'
app.get '/health', require './health'
app.get '/vitals', vitals.express
app.get '/ip', (req, res, next) ->
  res.send require './ip'
