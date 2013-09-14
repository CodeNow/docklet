var uuid = require('node-uuid');
var configs = require('../lib/configs');
var redis = require('redis');
var pubsub = redis.createClient(configs.redisPort, configs.redisHost);
var client = redis.createClient(configs.redisPort, configs.redisHost);

require('./fixtures/docker');
require('../lib');

describe('harbourmaster interface', function () {
  it('should respond to a request', function (done) {
    var servicesToken = 'services-' + uuid();
    var repo = 'base';
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
});