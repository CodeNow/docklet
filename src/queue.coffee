async = require 'async'
configs = require './configs'
request = require 'request'

module.exports = async.queue (repo, cb) ->
  request
    method: 'POST'
    url: "http://#{configs.docker_host}:#{configs.docker_port}/images/create"
    qs: fromImage: repo
    json: true
    body: { }
  , (err, res) ->
    if err then cb err else
      if res.statusCode isnt 200 then cb new Error "docker error #{res.body}" else
        cb()