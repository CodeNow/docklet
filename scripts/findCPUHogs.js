var exec = require('child_process').exec;
var async = require('async');
var threshhold = 10;

console.log('STARTING');
exec('docker ps -q', function (err, stdout, stderr) {
  if (err) {
    throw err;
  }
  async.each(getContainersIds(stdout), function (containerId, cb) {
    exec('docker top ' + containerId, function (err, stdout, stderr) {
      if (err) {
        cb(err);
      } else {
        async.each(getPids(stdout), function (pid, cb) {
          exec('ps -p ' + pid + ' -o pcpu', function (err, stdout, stderr) {
            if (err) {
              cb(err);
            } else {
              if (getPcpu(stdout) > threshhold) {
                console.log({
                  containerId: containerId,
                  pid: pid,
                  pcpu: getPcpu(stdout)
                });
              }
              cb();
            }
          });
        }, cb);
      }
    });
  }, function (err) {
    if (err) {
      throw err;
    }
    console.log('DONE');
  });
});

function getContainersIds (dockerPS) {
  var containerIds = dockerPS.split('\n');
  containerIds.pop();
  return containerIds;
}

function getPids (dockerTop) {
  var lines = dockerTop.split('\n');
  lines.shift();
  lines.pop();
  var pids = lines.map(function (line) {
    return line.split(' ').shift();
  });
  return pids;
}

function getPcpu (ps) {
  var lines = ps.split('\n');
  var pcpu = parseFloat(lines[1]);
  return pcpu;
}
