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
  beforeEach(function (done) {
    setTimeout(done, 1500);
  })
  it('should respond to a queue request to create a container with a miss the first time', function (done) {
    client.blpop('docks', 1, function (err, element) {
      request.post('http://' + element[1] + ':3000/create?fromImage=base', function (err, res, body) {
        if (err) {
          done(err);
        } else if (res.statusCode !== 404) {
          console.log(err, res, body);
          done(new Error('bad statusCode'));
        } else {
          done();
        }
      })
    });
  });
  it('should respond to a broadcast request to create a container', function (done) {
    var servicesToken = 'services-' + uuid();
    var repo = 'base';
    var pubsub = redis.createClient(configs.redisPort, configs.redisHost);
    pubsub.on('subscribe', onSubscribed);
    pubsub.on('message', onMessage);
    pubsub.subscribe(servicesToken + ':dockletReady');

    function onSubscribed (key, count) {
      if (key === servicesToken + ':dockletReady') {
        client.publish('dockletRequest', JSON.stringify({
          repo: repo,
          servicesToken: servicesToken
        }));
      }
    }

    function onMessage (key, docklet) {
      if (key === servicesToken + ':dockletReady') {
        pubsub.unsubscribe(servicesToken + ':dockletReady', done);
      }
    }
  });
  it('should respond to a queue request to create a container', function (done) {
    client.blpop('docks', 1, function (err, element) {
      request.post('http://' + element[1] + ':3000/create?fromImage=base', function (err, res, body) {
        if (err) {
          done(err);
        } else if (res.statusCode !== 204) {
          done(new Error('bad statusCode: ' + res.statusCode));
        } else {
          done();
        }
      })
    });
  });
  it('should respond to a job request to create a container', function (done) {
    var servicesToken = 'services-' + uuid();
    var repo = 'base';
    var pubsub = redis.createClient(configs.redisPort, configs.redisHost);
    pubsub.on('subscribe', onSubscribed);
    pubsub.on('message', onMessage);
    pubsub.subscribe(servicesToken + ':dockletReady');

    function onSubscribed (key, count) {
      if (key === servicesToken + ':dockletReady') {
        client.rpush('dockletJobs', JSON.stringify({
          repo: repo,
          servicesToken: servicesToken
        }));
      }
    }

    function onMessage (key, docklet) {
      if (key === servicesToken + ':dockletReady') {
        pubsub.unsubscribe(servicesToken + ':dockletReady', done);
      }
    }
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
        done(new Error('expected prune count to equal 3'));
      } else {
        done();
      }
    }, 100);
  });

});