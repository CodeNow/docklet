kue = require 'kue'
dockletRequestQueue = require './dockletRequestQueue'
ip = require './ip'
configs = require './configs'
client = require './client'

kue.redis.createClient = ->
  require('redis').createClient configs.redisPort, configs.redisHost

jobs = kue.createQueue()

jobs.process 'dockletRequest', (job, done) ->
  job.progress 1, 3
  dockletRequestQueue.push job.data, (err) ->
    job.progress 2, 3
    if err then done err else
      job.data.docklet = ip
      job.update()
      job.set 'docklet', ip, done
