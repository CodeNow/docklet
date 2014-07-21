var rollbar = require('rollbar');
var configs = require('./configs');
var clone = require('clone');

var Datadog = require('dogapi');
var ip = require('./ip');

var datadog = configs.datadog ?
  new Datadog({
    api_key: configs.datadog.appKey,
    app_key: configs.datadog.appKey
  }):
  {};

module.exports.reportError = function (message, err, req) {
  console.error(message);
  console.error(err);
  console.error(req && req.data || {});
  var payload = (req && req.data) ? clone(req.data) : {};
  payload.error = err.toString();
  payload.errorStack = err.stack;
  payload.trace = (new Error('trace')).stack;
  rollbar.reportMessageWithPayloadData(message, payload, req, logIfError);
};

module.exports.reportEvent = function (message) {
  if (!configs.datadog) {
    return;
  }
  datadog.add_event({
    title: message,
    description: message,
    tags: ['node_env:'+process.env.NODE_ENV, 'service:dock'],
    host: ip,
    device_name: 'dock',
    aggregation_key: 'dock'
  }, logIfError);

};

function logIfError(err) {
  if (err) {
    console.error(err.stack);
  }
}