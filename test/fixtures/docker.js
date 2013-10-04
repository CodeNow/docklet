var express = require('express');
var app = express();
var images = [];

var pruneCount = 0;
var containers = [
  { Id: '0' }, // whitelist
  { Id: '1' }, // whitelist
  { Id: '2' }, // whitelist
  { Id: '3' }, // whitelist
  { Id: '4' }, // prune
  { Id: '5' }, // prune
  { Id: '6' }, // running (dont prune)
  { Id: '7' }  // prune
];

// prunecount = 3

app.get('/images/json', function (req, res, next) {
  res.json(images);
});

app.get('/containers/json', function (req, res, next) {
  res.json(containers);
});

app.get('/containers/:id/json', function (req, res, next) {
  if (req.params.id !== '6') {
    res.json({
      State: {
        Running: false
      }
    });
  } else {
    res.json({
      State: {
        Running: true
      }
    });
  }
});

app.del('/containers/:id', function (req, res, next) {
  pruneCount++;
  res.json(204, { });
});

app.post('/images/create', function (req, res, next) {
  images.push({
    Repository: req.query.fromImage
  });
  res.json({});
});

app.get('/events', function (req, res, next) {
  setInterval(function () {
    res.write(JSON.stringify({
      status: 'start'
    }));
  }, 100);
  setInterval(function () {
    res.write(JSON.stringify({
      status: 'stop'
    }));
  }, 100);
});

app.get('/images/:image/json', function (req, res, next) {
  var responded = false;
  images.forEach(function (image) {
    if (image.Repository = req.params.image) {
      res.json({
           "id":"b750fe79269d2ec9a3c593ef05b4332b1d1a02a62b4accb2c21d589ff2f5f2dc",
           "parent":"27cf784147099545",
           "created":"2013-03-23T22:24:18.818426-07:00",
           "container":"3d67245a8d72ecf13f33dffac9f79dcdf70f75acb84d308770391510e0c23ad0",
           "container_config":
                   {
                           "Hostname":"",
                           "User":"",
                           "Memory":0,
                           "MemorySwap":0,
                           "AttachStdin":false,
                           "AttachStdout":false,
                           "AttachStderr":false,
                           "PortSpecs":null,
                           "Tty":true,
                           "OpenStdin":true,
                           "StdinOnce":false,
                           "Env":null,
                           "Cmd": ["/bin/bash"]
                           ,"Dns":null,
                           "Image":"base",
                           "Volumes":null,
                           "VolumesFrom":"",
                           "WorkingDir":""
                   },
           "Size": 6824592
      });
      responded = true;
    }
  });
  if (!responded) {
    res.send(404);
  }
});

app.all('*', function (req, res, next) {
  console.log('Docker request:', req.method, req.url);
  next();
});

app.listen(4243);

module.exports.pruneCount = function () {
  return pruneCount;
};