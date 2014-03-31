var httpProxy = require('http-proxy');
var net = require('net');
var http = require('http');
var retryCount = 0;

// sends command to docker to ensure it is alive and start proxy if its alive
function connectToDocker() {
    var req = http.request({
    hostname: 'localhost',
    port: 4242,
    path: '/version',
    method: 'GET'
  }, startProxy);

  req.on('error', function(err) {
    retryCount++;
    console.log('failed to connect to docker, retryCount = '+retryCount+' err:', err);
    setTimeout(connectToDocker, 100);
  });

  req.end();
}

// start proxying to docker
function startProxy(req, res) {
  console.log("startProxy");
  httpProxy.createProxyServer({target:'http://localhost:4242'}).listen(4243);
}
connectToDocker()

