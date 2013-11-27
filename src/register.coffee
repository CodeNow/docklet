client = require './client'
configs = require './configs'
frontend = 'frontend:docklet.' + configs.domain
ip = require './ip'
url = "http://#{ip}:4244"

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
