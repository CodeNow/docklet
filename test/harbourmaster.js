var uuid = require('node-uuid');
var configs = require('../lib/configs');
var redis = require('redis');
var request = require('request');
var client = redis.createClient(configs.redisPort, configs.redisHost);

var docker = require('./fixtures/docker');
var bouncer = require('../lib/bouncer');

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
  it('should repond to a /containers/create', function (done) {
    request.post({
      url: 'http://localhost:4243/containers/create',
      json: {
        json: true
      }
    }, function (err, res, body) {
      if (err) {
        done(err);
      } else if (res.statusCode !== 201) {
        done(new Error('bad status'));
      } else {
        done();
      }
    });
  });
  it('should repond to a /containers/:id/start', function (done) {
    request.post({
      url: 'http://localhost:4243/containers/e90e34656806/start',
      json: {
        json: true
      }
    }, function (err, res, body) {
      if (err) {
        done(err);
      } else if (res.statusCode !== 200) {
        done(new Error('bad status'));
      } else {
        done();
      }
    });
  });
  it('should repond to a /containers/:id/stop', function (done) {
    request.post({
      url: 'http://localhost:4243/containers/e90e34656806/stop',
      json: {
        json: true
      }
    }, function (err, res, body) {
      if (err) {
        done(err);
      } else if (res.statusCode !== 200) {
        done(new Error('bad status'));
      } else {
        done();
      }
    });
  });
  it('should repond to a /commit', function (done) {
    request.post({
      url: 'http://localhost:4243/commit?container=e90e34656806&m=message&repo=myrepo',
      json: true
    }, function (err, res, body) {
      if (err) {
        done(err);
      } else if (res.statusCode !== 201) {
        done(new Error('bad status'));
      } else {
        done();
      }
    });
  });
  it('should repond to a /images/:repo?/:user?/:name/push', function (done) {
    request.post({
      url: 'http://localhost:4243/images/registry.runnable.com/runnable/myrepo/push',
      json: true
    }, function (err, res, body) {
      if (err) {
        done(err);
      } else if (res.statusCode !== 200) {
        done(new Error('bad status'));
      } else {
        done();
      }
    });
  });
  it('should build', function (done) {
    this.timeout(0);
    var success = false;
    var fstream = require('fstream');
    var tar = require('tar');
    fstream.Reader({
      path: __dirname + '/fixtures/myproject',
      type: "Directory"
    })
      .pipe(tar.Pack({
        fromBase: true
      }))
      .pipe(request.post({
        url: 'http://localhost:4243/build?t=myrepo'
      }))
      .on('data', function (data) {
        if (/Successfully built/.test(data)) {
          success = true;
        }
      })
      .on('error', done)
      .on('end', function () {
        if (success) {
          done();
        } else {
          done(new Error('failed to build'));
        }
      });
  });
});