var uuid = require('node-uuid');
var flattenImage = global.test ?
  require('../test/fixtures/flattenDockerImages') : require('flattenDockerImages');
var rollbar = require('rollbar');

function flatten(req, res, next) {
  var oldRepo = req.query.oldRepo;
  var newRepo = req.query.newRepo || ('registry.runnable.com/runnable/' + uuid());
  var layerCount = req.query.layerCount;
  return flattenImage(oldRepo, newRepo, layerCount, rollbar, function(err) {
    if (err) {
      console.error(err);
      return res.send(500, err.message);
    } else {
      return res.send(201);
    }
  });
}

module.exports = flatten;