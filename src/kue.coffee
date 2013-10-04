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
  dockletRequestQueue.push job, (err) ->
  	job.progress 2, 3
  	if err then done err else
  		client.hset 'harbourmasterSession:' + job.servicesToken, 
  		  'docklet', ip, done
