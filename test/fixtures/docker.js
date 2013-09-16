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
  res.send('ok');
});

app.all('*', function (req, res, next) {
  console.log('Docker request:', req.method, req.url);
  next();
});

app.listen(4243);

module.exports.pruneCount = function () {
  return pruneCount;
};