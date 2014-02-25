var redis = require('redis');
var fs = require('fs');
var decode = require('hex64').decode;
var configs = require('./lib/configs');
var ip = require('./lib/ip');
var exec = require('child_process').exec;
var async = require('async');
var client = redis.createClient(configs.redisPort, configs.redisHost);

async.series([
  removeEntry,
  stopDocker,
  editRepositories,
  reboot
], done);


function removeEntry (cb) {
  client.lrem('frontend:docklet.runnable.com', 1, ('http://' + ip + ':4244'), cb);
}

function stopDocker (cb) {
  exec('service docker stop', cb);
}

function editRepositories (cb) {
  var reg = JSON.parse(fs.readFileSync('/var/lib/docker/repositories'));
  Object
    .keys(reg)
    .filter(function (key) {
      return key.length === 47;
    })
    .forEach(function (key) {
      var split = key.split('/');
      var id = split.pop();
      split.push(decode(id));
      reg[split.join('/')] = reg[key];
    });
  fs.writeFile('/var/lib/docker/repositories', JSON.stringify(reg), cb);
}

function reboot (cb) {
  exec('reboot', cb);
}

function done (err) {
  if (err) {
    throw err;
  } else {
    console.log('DONE');
  }
}