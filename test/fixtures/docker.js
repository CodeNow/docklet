var express = require('express');
var app = express();
var images = [];

app.get('/images/json', function (req, res, next) {
  res.json(images);
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