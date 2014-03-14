client = require './client'
configs = require './configs'
frontend = 'frontend:docklet.' + configs.domain
ip = require './ip'
url = "http://#{ip}:4244"
rollbar = require 'rollbar'

module.exports.register = ->
  client.lrange frontend, 0, -1, (err, frontends) ->
    if err
      throw err
    else if frontends.length is 0
      client.multi()
        .rpush(frontend, 'docklets')
        .rpush(frontend, url)
        .exec (err) ->
          if err then throw err
    else if url not in frontends
      client.rpush frontend, url, (err) ->
        if err then throw err

module.exports.deregister = ->
  client.lrem frontend, 0, url, (err) ->
    if err
      rollbar.reportMessage "Failed to deregister. message: #{err.message}" +
        "ip: #{ip}", 
        'critical', 
        ->
          process.exit 1
    else 
      setTimeout ->
        process.exit 0
      , 1000 * 5
