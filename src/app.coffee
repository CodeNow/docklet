express = require 'express'

app = module.exports = express()

app.post '/flatten', require './flatten'