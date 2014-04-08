var async = require('async');
var configs = require('./configs');
var request = require('request');

module.exports = async.queue(function(repo, cb) {
  var req, respond, responded;
  responded = false;
  respond = function(err) {
    if (!responded) {
      responded = true;
      return cb(err);
    } else {
      return console.error(err);
    }
  };
  req = request({
    method: 'POST',
    url: configs.docker_host + ":" + configs.bouncer_port + "/images/create",
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