var uuid = require('node-uuid');
var configs = require('../lib/configs');
var redis = require('redis');
var request = require('request');
var client = redis.createClient(configs.redisPort, configs.redisHost);

var docker = require('./fixtures/docker');

describe('harbourmaster interface', function () {
  before(function (done) {
    client.del('docks');
    setTimeout(function () {
      require('../lib');
    }, 10);
    setTimeout(done, 500);
  });
  it('should respond to a kue request to create a container', function (done) {
    var servicesToken = 'services-' + uuid();
    var repo = 'base';
    var kue = require('kue');
    var jobs = kue.createQueue();
    var job = jobs.create('dockletRequest', {
      title: servicesToken,
      repo: repo,
      servicesToken: servicesToken
    }).save();

    job.on('complete', done);
  });
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

});