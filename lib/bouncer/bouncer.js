var configs = require('./configs');
var net = require('net');
var http = require('http');
var express = require('express');
var Docker = require('dockerode');
var app = express();
var socket = configs.socket;

app.configure('integration', function() {
  return app.use(express.logger());
});

var docker = typeof socket === 'string' ? new Docker({
  socketPath: socket
}) : new Docker({
  host: 'http://localhost',
  port: socket
});

var startProxy = function() {
  return app.listen(4243);
};

var req = http.request({
  socketPath: socket,
  path: '/version',
  method: 'GET'
}, startProxy);

req.on('error', function(err) {
  console.error('failed to connect', err);
  return setTimeout(process.exit, 5 * 1000, 1);
});

req.end();

app.get('/images/json', function(req, res, next) {
  return docker.listImages(req.query, function(err, images) {
    if (err) {
      return next(err);
    } else {
      return res.json(images);
    }
  });
});

app.get('/containers/json', function(req, res, next) {
  return docker.listContainers(req.query, function(err, containers) {
    if (err) {
      return next(err);
    } else {
      return res.json(containers);
    }
  });
});

app.get('/images/:repo?/:user?/:name/json', function(req, res, next) {
  var image, name;
  name = req.params.name;
  if (req.params.user) {
    name = req.params.user + '/' + name;
  }
  if (req.params.repo) {
    name = req.params.repo + '/' + name;
  }
  image = docker.getImage(name);
  return image.inspect(function(err, image) {
    if (err) {
      return next(err);
    } else {
      return res.json(image);
    }
  });
});

app.get('/images/:repo?/:user?/:name/history', function(req, res, next) {
  var image, name;
  name = req.params.name;
  if (req.params.user) {
    name = req.params.user + '/' + name;
  }
  if (req.params.repo) {
    name = req.params.repo + '/' + name;
  }
  image = docker.getImage(name);
  return image.history(function(err, image) {
    if (err) {
      return next(err);
    } else {
      return res.json(image);
    }
  });
});

app.post('/images/create', function(req, res, next) {
  return docker.createImage(req.query, function(err, stream) {
    if (err) {
      return next(err);
    } else {
      return stream.pipe(res);
    }
  });
});

app.get('/containers/:container/json', function(req, res, next) {
  var container;
  container = docker.getContainer(req.params.container);
  return container.inspect(function(err, container) {
    if (err) {
      return next(err);
    } else {
      return res.json(container);
    }
  });
});

app.del('/containers/:container', function(req, res, next) {
  var container;
  container = docker.getContainer(req.params.container);
  return container.remove(function(err) {
    if (err) {
      return next(err);
    } else {
      return res.send(204);
    }
  });
});

app.post('/containers/create', express.json(), function(req, res, next) {
  return docker.createContainer(req.body, function(err, container) {
    if (err) {
      return next(err);
    } else {
      return res.json(201, {
        Id: container.id
      });
    }
  });
});

app.post('/containers/:container/start', express.json(), function(req, res, next) {
  var container;
  container = docker.getContainer(req.params.container);
  return container.start(req.body, function(err) {
    if (err) {
      return next(err);
    } else {
      return res.send(204);
    }
  });
});

app.post('/containers/:container/stop', express.json(), function(req, res, next) {
  var container;
  container = docker.getContainer(req.params.container);
  return container.stop(req.body, function(err) {
    if (err) {
      return next(err);
    } else {
      return res.send(204);
    }
  });
});

app.post('/commit', function(req, res, next) {
  var container;
  container = docker.getContainer(req.query.container);
  return container.commit(req.query, function(err, container) {
    if (err) {
      return next(err);
    } else {
      return res.json(201, container);
    }
  });
});

app.post('/images/:repo?/:user?/:name/push', express.json(), function(req, res, next) {
  var image, name;
  name = req.params.name;
  if (req.params.user) {
    name = req.params.user + '/' + name;
  }
  if (req.params.repo) {
    name = req.params.repo + '/' + name;
  }
  image = docker.getImage(name);
  return image.push(req.body, function(err, stream) {
    if (err) {
      return next(err);
    } else {
      return stream.pipe(res);
    }
  });
});

app.post('/build', function(req, res, next) {
  return docker.buildImage(req, req.query, function(err, stream) {
    if (err) {
      return next(err);
    } else {
      return stream.pipe(res);
    }
  });
});

app.use(function(err, req, res, next) {
  return res.send(err.statusCode || 500, err.json || err.reason || err.message);
});

app.all('*', function(req, res) {
  console.error('missing', req.method, req.url);
  return req.send(500, 'not supported');
});