configs = require './configs'
request = require 'request'
queue = require './queue'
redis = require('redis').createClient configs.redisPort, configs.redisHost
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
  queue.push repo, (err) ->
    images[repo] = true  unless err
    cb err

checkCache = (repo) ->
  # console.log 'CHECK', images, repo
  repo of images

findImage = (data, cb) ->
  if checkCache data.repo
    process.nextTick ->
      cb null
  else
    redis.publish 'dockletRequest', JSON.stringify data
    # console.log "not found. pulling image #{repo}"
    pullImage data.repo, cb

module.exports = {
  checkCache
  findImage
  cacheImages
  pullImage
}
