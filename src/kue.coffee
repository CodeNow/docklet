kue = require 'kue'
docker = require './docker'
configs = require './configs'
client = require './client'

kue.redis.createClient = ->
  require('redis').createClient configs.kueRedisPort, configs.kueRedisHost

jobs = module.exports = kue.createQueue()

job.errorOut = ->
  jobs.client.end()

jobs.process 'dockletRequest', (job, done) ->
  jobs.errorOut = ->
    done new Error 'shutting down'
    jobs.client.end()
  job.progress 1, 3
  job.data.job = true
  docker.findImage job.data, (err, ip) ->
    job.progress 2, 3
    if err then done err else
      job.data.docklet = ip
      job.update()
      job.set 'docklet', ip, done
      
