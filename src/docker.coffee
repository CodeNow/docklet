configs = require './configs'
request = require 'request'
queue = require './queue'

images = [ ]

cacheImages = (cb) ->
  request
    method: 'GET'
    url: "http://#{configs.docker_host}:#{configs.docker_port}/images/json"
    json: true
  , (err, res) ->
    if err then cb err else
      if res.statusCode isnt 200 then cb new Error "docker error #{res.body}" else
        images = res.body
        cb()

pullImage = (repo, cb) ->
  queue.push repo, cb

findImage = (repo, cb) ->
  found = false
  for item in images
    if item.Repository is repo then found = true
  if found
    process.nextTick ->
      cb null, found
  else 
    cacheImages (err) ->
      if err then cb err else
        for item in images
          if item.Repository is repo then found = true
        cb null, found

module.exports =
  pullImage: pullImage
  findImage: findImage