kue = require 'kue'
docker = require './docker'
configs = require './configs'
client = require './client'

kue.redis.createClient = ->
  require('redis').createClient configs.kueRedisPort, configs.kueRedisHost

jobs = module.exports = kue.createQueue()

jobs.errorOut = ->
  shuttingDown = true

jobs.process "dockletRequest", (job, done) ->
  if shuttingDown
    job.inactive() #put job back in queue
    #never call done, this prevents worker from accepting new jobs
    return
  job.progress 1, 3
  job.data.job = true
  docker.findImage job.data, (err, ip) ->
    job.progress 2, 3
    if err
      done err
    else
      job.data.docklet = ip
      job.update()
      job.set "docklet", ip, done
