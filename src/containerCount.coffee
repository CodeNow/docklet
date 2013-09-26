docker = require('docker.js') {}
count = null

docker.events({}).on 'data', (buf) ->
  try
    status = JSON.parse(buf).status
    if status is 'start'
      count++
    if status is 'stop'
      count--
  catch e
    console.error e
  

module.exports.init = (cb) ->
  docker.listContainers (err, containers) ->
    if err then cb err else
    count = containers.length
    cb null

module.exports.getCount = () ->
  count


setInterval () ->
  docker.listContainers (err, containers) ->
    if err then console.log err else
    count = containers.length
, 1000 * 60 * 5