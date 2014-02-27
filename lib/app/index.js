var configs = require('./configs');
var rollbar = require('rollbar');
if (configs.rollbar) {
  rollbar.init(configs.rollbar);
}
if (configs.nodetime) {
  var nodetime = require('nodetime');
  nodetime.profile(configs.nodetime);
}
var docker = require('./docker');
var app = require('./app');

docker.cacheImages(function(err) {
  if (err) {
    console.error('failed to cache', err);
    return process.exit(1);
  } else {
    console.log('cached');
    require('./pubsub');
    require('./register');
    return app.listen(4244);
    }
});