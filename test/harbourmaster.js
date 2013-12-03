var uuid = require('node-uuid');
var configs = require('../lib/configs');
var redis = require('redis');
var request = require('request');
var client = redis.createClient(configs.redisPort, configs.redisHost);

var docker = require('./fixtures/docker');

global.test = true;

describe('harbourmaster interface', function () {
  before(function (done) {
    client.del('docks');
    setTimeout(function () {
      require('../lib');
    }, 10);
    setTimeout(done, 500);
  });
  it('should respond to a http request to find a dock', function (done) {
    var servicesToken = 'services-' + uuid();
    var repo = 'base';
    request.post({
      url: 'http://localhost:4244/find',
      json: {
        servicesToken: servicesToken,
        repo: repo
      }
    }, function (err, res, body) {
      if (err) {
        done(err);
      } else if (res.statusCode !== 200) {
        done(new Error('bad statusCode: ' + res.statusCode));
      } else {
        done();
      }
    });
  });
  // it('should respond to a kue request to create a container', function (done) {
  //   var servicesToken = 'services-' + uuid();
  //   var repo = 'base';
  //   var kue = require('kue');
  //   var jobs = kue.createQueue();
  //   var job = jobs.create('dockletRequest', {
  //     title: servicesToken,
  //     repo: repo,
  //     servicesToken: servicesToken
  //   }).save();

  //   job.on('complete', done);
  // });
  it('should respond to a request to prune unused containers', function (done) {
    var containerIds = [
      '0',
      '1',
      '2',
      '3'
    ];
    client.publish('dockletPrune', JSON.stringify(containerIds));
    setTimeout(function () {
      if (docker.pruneCount() !== 3) {
        console.error('count', docker.pruneCount())
        done(new Error('expected prune count to equal 3'));
      } else {
        done();
      }
    }, 100);
  });
  it('should respond to a flatten request', function (done) {
    request.post({
      url: 'http://localhost:4244/flatten',
      qs: {
        oldRepo: 'registry.runnable.com/runnable/old-repo-name',
        newRepo: 'registry.runnable.com/runnable/new-repo-name',
        layers: 5
      }
    }, function (err, res, body) {
      if (err) {
        done(err);
      } else if (res.statusCode !== 201) {
        done(new Error('bad statusCode: ' + res.statusCode));
      } else {
        done();
      }
    });
  });
});