var async = require('async');
var configs = require('./configs');
var request = require('request');
var Docker = require('dockerode');

var docker = new Docker({
  host: configs.docker_host,
  port: configs.docker_port
});

module.exports = async.queue(function(repo, cb) {
  var errored;
  console.log('repo', repo);
  docker.pull(repo, {
    registry: 'http://registry.runnable.com'
  }, function (err, stream) {
    if (err) {
      cb(err);
    }
    else {
      stream.on('error', onError);
      stream.on('data', onData);
      stream.on('end', onEnd);
    }
    function onError (err) {
      errored = err;
      cb(err);
    }
    function onData (data) {
      if (errored) { return; }
      try {
        JSON.parse(data);
        if (data.error) {
          var errorDetail = data.errorDetail;
          onError(new Error(errorDetail.code+': '+errorDetail.message+' '+data.error));
        }
      }
      catch (err) {
        onError(err);
      }
    }
    function onEnd () {
      if (errored) { return; }
      cb();
    }
  });
});