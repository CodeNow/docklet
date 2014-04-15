var StatsD = require('node-statsd').StatsD;
var config = require('./configs');
var client = null;

if (config.statsd) {
  client = new StatsD({
    host: config.statsd.host, 
    prefix: config.statsd.name
  });
} else {
  client = new StatsD({
    mock: true
  });
}

function middleware (req, res, next) {
  var start = new Date();
  if (res._responseTime) return next();
  res._responseTime = true;

  res.on('header', function(){
    var duration = new Date() - start;
    var routeName = "";

    if (req.route && req.route.path) {
      routeName = req.route.path;
      if (Object.prototype.toString.call(routeName) === '[object RegExp]') {
        routeName = routeName.source;
      }
      if (routeName === "/") {
        routeName = "root";
      }
      routeName = req.method + '/' + routeName;
    } else if (req.url) { // Required to pickup static routes
      routeName = req.method + '/' + req.url;
    }

    // Get rid of : in route names, remove first and last /,
    // and replace rest with . (meaning dir)
    routeName = routeName.replace(/:/g, "").replace(/^\/|\/$/g, "").replace(/\//g, ".");
    client.timing('requests.' + routeName, duration);
    client.increment("requests." + routeName);
    client.increment('requests.' + routeName + "." + res.statusCode);
  });

  next();
}

function getClient() {
  return client;
}

module.exports.middleware = middleware;
module.exports.getClient = getClient;
