flattenImage = if global.test 
  require '../test/fixtures/flattenDockerImages'
else
  require 'flattenDockerImages'

flatten = module.exports = (req, res, next) ->
  oldRepo = req.query.oldRepo
  newRepo = req.query.newRepo || ('registry.runnable.com/runnable/' + uuid());
  layerCount = req.query.layerCount
  flattenImage oldRepo, newRepo, layerCount, (err) ->
    if (err) 
      console.error err
      res.send 500, err.message
    else
      res.send 201
