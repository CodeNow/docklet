configs = require './configs'
request = require 'request'
queue = require './queue'
images = {}

cacheImages = (cb) ->
  request
    method: 'GET'
    url: "http://#{configs.docker_host}:#{configs.docker_port}/images/json"
    json: true
    headers:
      token: configs.authToken
  , (err, res) ->
    if err then cb err else
      if res.statusCode isnt 200 then cb new Error "docker error #{res.body}" else
        res.body.forEach (image) ->
          images[image.Repository] = true
        # console.log 'CACHE', images
        cb()

pullImage = (repo, cb) ->
  request
    method: 'POST'
    url: "http://#{configs.docker_host}:#{configs.docker_port}/images/create"
    qs: 
      fromImage: repo
    json: true
    body: { }
    headers:
      token: configs.authToken
  , (err, res) ->
    if err then cb err else
      if res.statusCode isnt 200 then cb new Error "docker error #{res.body}" else
        # image pulled
        images[repo] = true
        

checkCache = (repo) ->
  # console.log 'CHECK', images, repo
  repo of images

findImage = (repo, cb) ->
  if checkCache repo
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
  checkCache
  findImage
  cacheImages
  pullImage
}
