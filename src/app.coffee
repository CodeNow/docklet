express = require 'express'

app = module.exports = express()

app.post '/flatten', require './flatten'
app.post '/find', express.json(), require './find'