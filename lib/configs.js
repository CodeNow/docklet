  var eson = require('eson');
  var os = require('os');
  var path = require('path');
  var uuid = require('node-uuid');
  var env = process.env.NODE_ENV || 'development';

  var readConfigs = function(filename) {
    var configPath = path.join(__dirname, '/../configs/', filename+'.json');
    return eson()
      .use(eson.replace('{tmpdir}', os.tmpdir()))
      .read(configPath);
  };

  var configs = module.exports = readConfigs(env);

  module.exports.readConfigs = readConfigs;
