configs = require './configs'
request = require 'request'
queue = require './queue'
images = {}

cacheImages = (cb) ->
  request
    method: 'GET'
    url: "http://#{configs.docker_host}:#{configs.docker_port}/images/json"
    json: true
    auth: configs.auth
  , (err, res) ->
    if err then cb err else
      if res.statusCode isnt 200 then cb new Error "docker error #{res.body}" else
        res.body.forEach (image) ->
          images[image.Repository] = image
        cb()

pullImage = (repo, cb) ->
  queue.push repo, cb

findImage = (repo, cb) ->
  if repo of images
    process.nextTick ->
      cb null
  else 
    cacheImages (err) ->
      if err then cb err else
        if repo of images
          # console.log "found image #{repo}"
          cb null
        else
          # console.log "not found. pulling image #{repo}"
          pullImage repo, cb

module.exports = {
  cacheImages
  pullImage
  findImage
}