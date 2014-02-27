var async = require('async');
var configs = require('./configs');
var request = require('request');

var queue = async.queue(function(repo, cb) {
  var responded = false;
  var respond = function(err) {
    if (!responded) {
      responded = true;
      return cb(err);
    } else {
      return console.error(err);
    }
  };
  var req = request({
    method: 'POST',
    url: "http://" + configs.docker_host + ":" + configs.docker_port + "/images/create",
    qs: {
      fromImage: repo
    },
    headers: {
      token: configs.authToken
    }
  });
  req.on('error', respond);
  req.on('data', function(json) {
    var data, err;
    try {
      data = JSON.parse(json);
      if (data.error) {
        console.error('data:', data);
        console.error('repo:', repo);
        return respond(new Error(data.error));
      }
    } catch (_error) {
      err = _error;
      console.log(json.toString());
      return respond(err);
    }
  });
  return req.on('end', respond);
});

module.exports = queue;