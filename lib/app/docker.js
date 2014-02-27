var configs = require('./configs');
var request = require('request');
var queue = require('./queue');
var redis = require('redis').createClient(configs.redisPort, configs.redisHost);
var ip = require('./ip');
var images = {};

var cacheImages = function(cb) {
  return request({
    method: 'GET',
    url: "http://" + configs.docker_host + ":" + configs.docker_port + "/images/json",
    json: true,
    headers: {
      token: configs.authToken
    }
  }, function(err, res) {
    if (err) {
      return cb(err);
    } else {
      if (res.statusCode !== 200) {
        return cb(new Error("docker error " + res.body));
      } else {
        images = {};
        res.body.forEach(function(image) {
          images[image.Repository] = true;
        });
        return cb();
      }
    }
  });
};

var pullImage = function(repo, cb) {
  return queue.push(repo, function(err) {
    if (err === null) {
      images[repo] = true;
    }
    return cb(err);
  });
};

var checkCache = function(repo) {
  return repo in images;
};

var checkImage = function(repo, cb) {
  return request({
    method: 'GET',
    url: "http://" + configs.docker_host + ":" + configs.docker_port + "/images/" + repo + "/json",
    json: true,
    headers: {
      token: configs.authToken
    }
  }, function(err, res) {
    if (err) {
      return cb(err);
    } else {
      if (res.statusCode !== 200) {
        return cb(new Error("docker error " + res.body));
      } else {
        images[repo] = true;
        return cb(null);
      }
    }
  });
};

var findImage = function(data, cb) {
  if (checkCache(data.repo)) {
    return process.nextTick(function() {
      return cb(null, ip);
    });
  } else {
    return checkImage(data.repo, function(err) {
      var pubsub;
      if (err) {
        if (data.job) {
          data.job = false;
          pubsub = require('redis').createClient(configs.redisPort, configs.redisHost);
          pubsub.subscribe("" + data.servicesToken + ":dockletReady");
          pubsub.on('message', function(key, ip) {
            cb(null, ip);
            return pubsub.quit(null);
          });
          pubsub.on('ready', function() {
            return redis.publish('dockletRequest', JSON.stringify(data));
          });
          return setTimeout(function() {
            pubsub.quit(null);
            err = new Error('timed out searching for image');
            err.code = 404;
            return cb(err);
          }, 1000 * 5);
        } else {
          return pullImage(data.repo, cb);
        }
      } else {
        return cb(null, ip);
      }
    });
  }
};

module.exports = {
  checkCache: checkCache,
  findImage: findImage,
  cacheImages: cacheImages,
  pullImage: pullImage
};