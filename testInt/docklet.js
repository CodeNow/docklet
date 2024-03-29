var request = require('supertest');
var Docker = require('dockerode');
var host = 'http://localhost';
var docklet = request(host+':4244');
var configs = require('configs');
var dockerHost = configs.docker_host;
var dockerPort = configs.docker_port;
var dockworker, dockworkerUrl;
var docker = new Docker({
  host: dockerHost,
  port: dockerPort
});
var uuid = require('uuid');
var ShoeClient = require('./libs/ShoeClient');
var MuxDemux = require('mux-demux');

var container;
function toEnv (obj) {
  return Object.keys(obj).reduce(function (env, key) {
    env.push(key+'='+obj[key]);
    return env;
  }, []);
}

var serviceToken = 'services-' + uuid.v4();
describe('docklet', function () {
  this.timeout(0);
  before(function () {
    this.repo = 'registry.runnable.com/runnable/5320c7e2be28fdcc6917cb82'; // node hello world, hope all boxes have this.
  });

  it('should find a container', function (done) {
    docklet.post('/find')
      .send({ repo: this.repo })
      .expect(200)
      .end(function (err, res) {
        if (err) return done(err);
        res.body.should.equal("localhost");
        done();
      });
  });
  it('should create a container', function (done) {
    var self = this;
    var body =  {
      Image: this.repo,
      Volumes: { '/dockworker': {} },
      ExposedPorts: {
        "80/tcp": {},
        "15000/tcp": {}
      },
      Cmd: [ '/dockworker/bin/node', '/dockworker' ],
      Env: toEnv({
        SERVICES_TOKEN: serviceToken,
        RUNNABLE_START_CMD: 'npm start'
      })
    };
    docker.createContainer(body, function (err, body) {
      if (err) return done(err);
      container = body;
      done();
    });
  });
  describe('running container', function () {
    it('should start', function (done) {
      container.start({
        Binds: ["/home/ubuntu/dockworker:/dockworker:ro"],
        PortBindings: {
          "80/tcp": [{}],
          "15000/tcp": [{}]
        }
      }, done);
    });
    it('should find its ports', function (done) {
      container.inspect(function (err, data) {
        if (err) return done(err);
        var port = data.NetworkSettings.Ports['15000/tcp'][0].HostPort;
        port.should.be.type('string');
        dockworkerUrl = host+':'+port;
        dockworker = request(dockworkerUrl);
        done();
      });
    });

    // dockworker
    describe('dockworker', function () {
      it('should get the containers service token', function (done) {
        setTimeout(function() {
          done(new Error("timeout"));
        }, 6000);
        var self = this;
        console.log(dockworkerUrl);
        var retryCnt = 0;
        doit();
        function doit () {
          retryCnt++;
          var dockworkerGetToken = dockworker.get('/api/servicesToken');
          dockworkerGetToken.expect(200)
            .end(function (err, res) {
              if (err) {
                if (err.message.indexOf('ECONNRESET') && (retryCnt < 10)) {
                  setTimeout(function () {
                    doit();
                  }, 500);
                } else {
                  done(err);
                }
              } else {
                res.text.should.equal(serviceToken);
                done();
              }
            });
        }
      });
      it('should run echo', function (done) {
        setTimeout(function() {
          done(new Error("timeout"));
        }, 6000);
        var socket = 'ws://'+dockworkerUrl.split('//')[1];
        var stream = new ShoeClient(socket+'/streams/terminal');
        var muxDemux = new MuxDemux(onStream);
        stream.pipe(muxDemux).pipe(stream);
        function onStream(stream) {
          if (stream.meta === 'terminal') {
            onTerminal(stream);
          }
        }
        function onTerminal(stream) {
          var count = 0;
          stream.on('data', function (data) {
            var output = data.split("\r\n")[1];
            if ("TEST" === output) {
              done();
            }
          });
          stream.write('echo TEST\n');
        }
      });
    });
  });
});
