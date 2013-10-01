configs = require './configs'
dockletRequestQueue = require './dockletRequestQueue'
queue = require('redis').createClient configs.redisPort, configs.redisHost

handleJob = (err) ->
  if err
    console.error err
  queue.blpop 'dockletJobs', 0, (err, job) ->
    if err 
      console.error err 
    else
      try
        data = JSON.parse job[1]
        data.job = true
        dockletRequestQueue.push data, handleJob
      catch err
        console.error err

handleJob()