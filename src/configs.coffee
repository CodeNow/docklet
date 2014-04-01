eson = require 'eson'
os = require 'os'
path = require 'path'
uuid = require 'node-uuid'
env = process.env.NODE_ENV or 'development'

readConfigs = (filename) ->
  eson()
  .read(__dirname + '/../configs/' + filename + '.json')

configs = module.exports = readConfigs env
module.exports.readConfigs = readConfigs