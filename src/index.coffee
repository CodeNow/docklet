configs = require './configs'
if configs.nodetime
  nodetime = require 'nodetime'
  nodetime.profile configs.nodetime
containerCount = require './containerCount'
containerCount.init (err) ->
  if err then throw err else
  require './app'
  require './pubsub'