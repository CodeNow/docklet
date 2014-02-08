docker = require './docker'

module.exports = (req, res, next) ->
  req.body.job = true
  docker.findImage req.body, (err, ip) ->
    if err
      res.send err.code or 500, err.message
    else
      res.json ip