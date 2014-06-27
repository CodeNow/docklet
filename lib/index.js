var path = require('path');
var env = require('./env');
var configs = require('./configs');
var rollbar = require('rollbar');
var path = require('path');

if (configs.rollbar) {
  rollbar.init(configs.rollbar, {
    environment: process.env.NODE_ENV || "development",
    branch: "master",
    root: path.resolve(__dirname, '..')
  });
}

if (configs.nodetime) {
  var nodetime = require('nodetime');
  nodetime.profile(configs.nodetime);
}

var docker = require('./docker');
var app = require('./app');

app.use(rollbar.errorHandler());

docker.cacheImages(function(err) {
  if (err) {
    console.error('failed to cache', err);
    return process.exit(1);
  } else {
    console.log('cached');
    require('./pubsub');
    (require('./register')).register();
    return app.listen(4244);
  }
});