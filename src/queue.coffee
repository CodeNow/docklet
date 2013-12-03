async = require 'async'
configs = require './configs'
request = require 'request'

module.exports = async.queue (repo, cb) ->
  responded = false

  respond = (err) ->
    if not responded
      responded = true
      cb err
    else
      console.error err

  req = request
    method: 'POST'
    url: "http://#{configs.docker_host}:#{configs.docker_port}/images/create"
    qs: 
      fromImage: repo
    headers:
      token: configs.authToken

  req.on 'error', respond

  req.on 'data', (json) ->
    try
      data = JSON.parse json
      if data.error
        console.error 'data:', data
        console.error 'repo:', repo
        respond new Error data.error
    catch err
      console.log json.toString()
      respond err
  
  req.on 'end', respond