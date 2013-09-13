var express = require('express');
var app = express();
var data = {};
var index = 2;

app.use(express.bodyParser());

app.post('/v1/keys/runnables/:token/:name', set);

app.get('/v1/watch/runnables/:token/docklet', docklet);
app.get('/v1/watch/runnables', watch);
app.post('/v1/watch/runnables', watch);
//app.get('/v1/keys/runnables/:token/docklet', docklet);

app.get('/v1/keys/runnables/:token/:name', get);

//app.del('/v1/keys/runnables/:token/:name', ok);

app.all('*', function (req, res, next) {
  console.log('Etcd request:', req.method, req.url);
  next();
});

app.listen(4001);

function ok (req, res) {
  res.send('ok');
}

function docklet (req, res, next) {
  var key = req.url.replace(/\/v1\/watch/,'')
  app.on('/runnables', checkKey);
  function checkKey (data) {
    if (key === data.key) {
      app.removeListener('/runnables', checkKey);
      res.json(data);
    }
  }
}

function watch (res, res, next) {
  app.once('/runnables', function (data) {
    res.json(data);
  });
}

function set (req, res, next) {
  if (req.body.value == null) {
    console.log(req.params.name);
  }
  data[req.params.token] = data[req.params.token] || {};
  var prevValue = data[req.params.token][req.params.name] || {};
  var resp = {
    action: 'SET',
    newKey: req.body.value !== prevValue.value,
    value: req.body.value,
    prevValue: prevValue.value,
    key: req.url.replace(/\/v1\/keys/,''),
    index: index++
  };
  res.json(resp);
  setTimeout(function () {
    data[req.params.token][req.params.name] = req.body;
    app.emit('/runnables', resp);
  }, 50);
}

function get (req, res, next) {
  res.json(data[req.params.token][req.params.name]);
}