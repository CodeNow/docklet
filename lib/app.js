var express = require('express');
var vitals = require('./vitals');
var configs = require('./configs');
var Dogstatsyware = require('dogstatsyware');
var app = module.exports = express();

app.use(Dogstatsyware({
  service: 'docklet'
}));

app.use(app.router);

if (configs.nodetime) {
  app.use(require('nodetime').expressErrorHandler());
}

if (configs.rollbar) {
  app.use(require('rollbar').errorHandler());
}

app.post('/flatten', require('./flatten'));
app.post('/find', express.json(), require('./find'));
app.get('/health', require('./health'));
app.get('/vitals', vitals.express);
app.get('/ip', function(req, res, next) {
  return res.send(require('./ip'));
});
