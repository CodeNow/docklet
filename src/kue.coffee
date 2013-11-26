kue = require 'kue'
docker = require './docker'
configs = require './configs'
client = require './client'
shuttingDown = false

kue.redis.createClient = ->
  require('redis').createClient configs.kueRedisPort, configs.kueRedisHost

jobs = module.exports = kue.createQueue()

jobs.process "dockletRequest", (job, done) ->
  job.progress 1, 3
  job.data.job = true
  docker.findImage job.data, (err, ip) ->
    job.progress 2, 3
    if err
      done err
    else
      job.data.docklet = ip
      job.update()
      job.set "docklet", ip, (err) ->
        if (err) 
          done err
        else
          done()
