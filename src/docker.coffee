configs = require './configs'
request = require 'request'
queue = require './queue'
redis = require './client'
ip = require './ip'
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
        images = {}
        res.body.forEach (image) ->
          images[image.Repository] = true
        # console.log 'CACHE', images
        cb()

pullImage = (repo, cb) ->
  queue.push repo, (err) ->
    images[repo] = true unless err?
    cb err

checkCache = (repo) ->
  # console.log 'CHECK', images, repo
  repo of images

checkImage = (repo, cb) ->
  request
    method: 'GET'
    url: "http://#{configs.docker_host}:#{configs.docker_port}/images/#{repo}/json"
    json: true
    headers:
      token: configs.authToken
  , (err, res) ->
    if err then cb err else
      if res.statusCode isnt 200 then cb new Error "docker error #{res.body}" else
        images[repo] = true
        cb null

findImage = (data, cb) ->
  if checkCache data.repo
    process.nextTick ->
      cb null, ip
  else
    checkImage data.repo, (err) ->
      if (err)
        if data.job
          data.job = false
          pubsub = require('redis').createClient configs.redisPort, configs.redisHost
          pubsub.subscribe "#{data.servicesToken}:dockletReady"
          pubsub.on 'message', (key, ip) ->
            cb null, ip
            pubsub.quit null
          redis.publish 'dockletRequest', JSON.stringify data
        else 
          pullImage data.repo, cb
      else
        cb null, ip

module.exports = {
  checkCache
  findImage
  cacheImages
  pullImage
}


setInterval cacheImages, 1000 * 60 * 4 + 1000 * 60 * 2 * Math.random(), ->