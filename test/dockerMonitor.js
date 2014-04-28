var fs = require('fs');
var configs = require('../lib/configs');
var report = require('../lib/report');
var createCount = require('callback-count');

describe('docker restarts', function() {
  before(function () {
    this.writeStream = fs.createWriteStream(configs.dockerLog);
    this.dockerTail = require('../dockerMonitor'); // start monitor
  });
  after(function () {
    this.writeStream.destroy();
    this.dockerTail.unwatch();
    delete this.writeStream;
    delete this.dockerTail;
  });
  it('should report docker restarts to rollbar', function(done) {
    var count = createCount(2, done);
    report.reportError = function (message, err, req) {
      message.should.equal('Docker restarted!');
      count.next();
    };
    report.reportEvent = function (message) {
      message.should.equal('Docker restarted!');
      count.next();
    };
    this.writeStream.write('foo\n');
    this.writeStream.write('bar\n');
    this.writeStream.write('qux\n');
    this.writeStream.write('Listening for HTTP on tcp ...\n');
  });
});