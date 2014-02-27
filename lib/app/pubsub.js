var configs = require('../configs');
var async = require('async');
var pubsub = require('redis').createClient(configs.redisPort, configs.redisHost);
var dockerClient = require('docker.js')({
  host: "http://" + configs.docker_host + ":" + configs.docker_port,
  token: configs.authToken
});
var docker = require('./docker');
var client = require('./client');
var ip = require('./ip');

pubsub.on('message', function(key, json) {
  try {
    var data = JSON.parse(json);
    if (key === 'dockletRequest') {
      return raceToFind(data);
    } else if (key === 'dockletPrune') {
      var whitelist = data;
      return dockerClient.listContainers({
        queryParams: {
          all: true
        }
      }, function(err, containers) {
        var containersToPrune, whitelistHash;
        if (err) {
          return console.error(err);
        } else {
          whitelistHash = {};
          whitelist.forEach(function(containerId) {
            whitelistHash[containerId] = true;
          });
          containersToPrune = containers.filter(function(container) {
            var containerId = container.Id.substring(0, 12);
            return !whitelistHash[containerId];
          });
          return pruneContainers(containersToPrune);
        }
      });
    } else {
      throw new Error("Docklet received unknown message: " + key);
    }
  } catch (_error) {
    var err = _error;
    return console.error(err);
  }
});

pubsub.subscribe('dockletPrune');
pubsub.subscribe('dockletRequest');

var pruneContainers = function(containers) {
  return async.forEachSeries(containers, pruneContainer, function(err) {
    if (err) {
      return console.error(err);
    }
  });
};

var pruneContainer = function(container, cb) {
  var containerId;
  containerId = container.Id.substring(0, 12);
  return dockerClient.inspectContainer(containerId, function(err, res) {
    if (err) {
      return cb(err);
    } else {
      if (!res.State || res.State.Running) {
        return cb();
      } else {
        return dockerClient.removeContainer(containerId, cb);
      }
    }
  });
};

var raceToFind = function(data) {
  return docker.findImage(data, function(err) {
    if (err) {
      return console.error(err);
    } else {
      return client.setnx("" + data.servicesToken + ":dockletLock", true, function(err, lock) {
        if (err) {
          throw err;
        }
        if (lock) {
          return client.publish("" + data.servicesToken + ":dockletReady", ip);
        }
      });
    }
  });
};