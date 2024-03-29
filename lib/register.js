// Generated by CoffeeScript 1.6.3
(function() {
  var client, configs, frontend, ip, rollbar, url,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  client = require('./client');

  configs = require('./configs');

  frontend = 'frontend:docklet.' + configs.domain;

  ip = require('./ip');

  url = "http://" + ip + ":4244";

  rollbar = require('rollbar');

  module.exports.register = function() {
    return client.lrange(frontend, 0, -1, function(err, frontends) {
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
  };

  module.exports.deregister = function() {
    console.error('DEGREGISTERING');
    return client.lrem(frontend, 0, url, function(err) {
      if (err) {
        return rollbar.reportMessage(("Failed to deregister. message: " + err.message) + ("ip: " + ip), 'critical', function() {
          return process.exit(1);
        });
      } else {
        return setTimeout(function() {
          return process.exit(0);
        }, 1000 * 5);
      }
    });
  };

}).call(this);

/*
//@ sourceMappingURL=register.map
*/
