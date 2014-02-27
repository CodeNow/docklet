var configs = require('../configs');
var client = require('redis').createClient(configs.redisPort, configs.redisHost);
var frontend = 'frontend:docklet.' + configs.domain;
var ip = require('./ip');
var url = "http://" + ip + ":4244";
var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

client.lrange(frontend, 0, -1, function(err, frontends) {
  if (err) {
    throw err;
  } else if (frontends.length === 0) {
    return client.multi().rpush(frontend, 'docklets').rpush(frontend, url).exec(function(err) {
      if (err) {
        throw err;
      }
    });
  } else if (__indexOf.call(frontends, url) < 0) {
    return client.rpush(frontend, url, function(err) {
      if (err) {
        throw err;
      }
    });
  }
});