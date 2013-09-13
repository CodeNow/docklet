var uuid = require('node-uuid');
var configs = require('../lib/configs');
var etcd = require('node-etcd');
var client = new etcd(configs.etcdHost, configs.etcdPort);

require('./fixtures/etcd');
require('./fixtures/docker');
require('../lib');

describe('harbourmaster interface', function () {
  beforeEach(function (done) {
    var servicesToken = this.servicesToken = 'services-' + uuid();
    var repo = this.repo = 'repo-' + uuid();
    var row = this.row = '/runnables/' + servicesToken;
    var repoKey = row + '/repo';
    client.set(repoKey, repo, function (err) {
      if (err) throw err;
      var docklet = row + '/docklet';
      client.set(docklet, 'undefined', done);
    });
  });
  it('should respond to a request', function (done) {
    var docklet = this.row + '/docklet';
    var state = this.row + '/state';
    setTimeout(function () {
      client.watch(docklet, function dockletReady (err, val) {
        if (err) {
          next(err);
        } else {
          if (val.value == null) {
            throw new Error('no value');
          }
          done();
        }
      });
    }, 100);
    client.set(state, 'request', function () {});
  });
});