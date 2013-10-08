configs = require './configs'
module.exports = require('redis').createClient configs.redisPort, configs.redisHost