var httpProxy = require('http-proxy');
var net = require('net');
var http = require('http');
var retryCount = 0;

function connectToDocker() {
    var req = http.request({
    hostname: '10.171.7.2',
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

function startProxy(req, res) {
//
// Create a proxy server for websockets
//
  console.log("startProxy");
  httpProxy.createProxyServer({target:'http://10.171.7.2:4242'}).listen(4243);
}
connectToDocker()

