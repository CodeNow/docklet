express = require 'express'
vitals = require './vitals'

app = module.exports = express()

app.post '/flatten', require './flatten'
app.post '/find', express.json(), require './find'
app.get '/health', vitals.express