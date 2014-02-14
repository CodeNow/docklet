var uuid = require('node-uuid');
var configs = require('../lib/configs');
var redis = require('redis');
var request = require('request');
var Docker = require('dockerode');
var harbourmaster = new Docker({
  host: 'http://localhost',
  port: 4243
});
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
    harbourmaster.createContainer({}, done);
  });
  it('should repond to a /containers/:id/start', function (done) {
    harbourmaster.getContainer('e90e34656806').start(done);
  });
  it('should repond to a /containers/:id/stop', function (done) {
    harbourmaster.getContainer('e90e34656806').stop(done);
  });
  it('should repond to a /commit', function (done) {
    harbourmaster.getContainer('e90e34656806').commit({
      repo: 'myrepo',
      m: 'message'
    }, done);
  });
  it('should repond to a /images/:repo?/:user?/:name/json', function (done) {
    var image = harbourmaster.getImage('base');
    image.inspect(done);
  });
  it('should repond to a /images/:repo?/:user?/:name/history', function (done) {
    var image = harbourmaster.getImage('registry.runnable.com/runnable/myrepo');
    image.history(done);
  });
  it('should repond to a /images/:repo?/:user?/:name/push', function (done) {
    var image = harbourmaster.getImage('registry.runnable.com/runnable/myrepo');
    image.push({}, function (err, stream) {
      if (err) {
        done(err);
      } else {
        stream.on('error', done);
        stream.on('end', done);
        stream.resume();
      }
    });
  });
  it('should build', function (done) {
    var success = false;
    var fstream = require('fstream');
    var pack = require('tar-stream').pack();
    var concat = require('concat-stream');
    var path = __dirname + '/fixtures/myproject/';
    fstream.Reader({
      path: path,
      type: "Directory"
    })
      .on('entry', packEntry)
      .on('end', function () {
        pack.finalize();
      });
    function packEntry (entry) {
      var props = entry.props
      if (props.type === 'File') {
        entry.pipe(concat(function (contents) {
          pack.entry({
            name: props.path.replace(path, ''),
            type: props.type
          }, contents);
        }));
      } else if (props.type === 'Directory') {
        entry.on('entry', packEntry);
      }
    }

    harbourmaster.buildImage(pack, {
      t: 'my repo' 
    }, function (err, stream) {
      if (err) {
        done(err);
      } else {
        stream
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
      }
    });
      
  });
});