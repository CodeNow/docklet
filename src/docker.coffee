configs = require './configs'
request = require 'request'

pullImage = (repo, cb) ->
  request
    method: 'POST'
    url: "http://#{configs.docker_host}:#{configs.docker_port}/images/create"
    qs:
      fromImage: repo
    json: true
    body: { }
  , (err, res) ->
    if err then cb err else
      if res.statusCode isnt 200 then cb new Error "docker error #{res.body}" else
        cb()

findImage = (repo, cb) ->
  request
    method: 'GET'
    url: "http://#{configs.docker_host}:#{configs.docker_port}/images/json"
    json: true
  , (err, res) ->
    if err then cb err else
      if res.statusCode isnt 200 then cb new Error "docker error #{res.body}" else
        found = false
        for item in res.body
          if item.Repository is repo then found = true
        cb null, found

module.exports =
  pullImage: pullImage
  findImage: findImage