request = require 'request'
docker = require('./dockerProxy')()
# imageCache = require './imageCache'
ShoeClient = require './lib/ShoeClient'
MuxDemux = require 'mux-demux'
# cbTimeout = require 'callback-timeout'

localhost = 'http://localhost'

toEnv = (obj) ->
  return Object.keys(obj).reduce (env, key) ->
    env.push(key+'='+obj[key])
    return env
  , []

toHttpClient = (host, port) ->
  if port then host = host+':'+port
  makeAcceptPath = (fn) ->
    return (path, opts, cb) ->
      url = host + path
      console.log(url)
      return fn(url, opts, cb)
  client = makeAcceptPath(request)
  ['get', 'post', 'patch', 'put', 'del'].forEach (method)->
    client[method]   = makeAcceptPath(request[method].bind(request))
  return client

dockerCheckUp = (cb) ->
  docker.version (err, versionInfo) ->
    if (err) then err.stage = 'dockerCheckUp'
    cb(err)

getReliableRepo = () ->
  return 'registry.runnable.com/runnable/53114add52f4df0039412fbb'

createContainer = (cb) ->
  self = this
  body =
    Image: getReliableRepo(),
    Volumes: { '/dockworker': {} },
    PortSpecs: [ '80', '15000' ],
    Cmd: [ '/dockworker/bin/node', '/dockworker' ],
    Env: toEnv({
      SERVICES_TOKEN: serviceToken,
      RUNNABLE_START_CMD: 'npm start'
    })
  docker.createContainer body, cb

startContainer = (container, cb) ->
  container.start {
    Binds: ["/home/ubuntu/dockworker:/dockworker:ro"],
    PortBindings: {
      "80/tcp": [{}],
      "15000/tcp": [{}]
    }
  }, (err) ->
    if err then cb err else
      cb null, container

getDockworker = (container, cb) ->
  container.inspect (err, data) ->
    if err then cb err else
      port = data.NetworkSettings.PortMapping.Tcp[15000]
      dockworker = toHttpClient(localhost, port)
      cb null, dockworker

dockworkerGetServiceToken = (cb) ->
  dockworker.get '/api/serviceToken', (err, res, body) ->
    if err then cb err else
      statusErrMsg = 'failed to get dockworker serviceToken'
      if res.statusCode != 200 then cb(new Error(statusErrMsg)) else
        cb(null, body)

dockworkerTestTerminal = (cb) ->
  onStream = (stream) ->
    if stream.meta is "terminal" then onTerminal stream
  onTerminal = (stream) ->
    count = 0
    stream.on "data", (data) ->
      if /hello\r\n/.test(data) then cb()
    stream.write "echo hello\n"

  socket = "ws://" + dockworkerUrl.split("//")[1]
  stream = new ShoeClient(socket + "/streams/terminal")
  muxDemux = new MuxDemux(onStream)
  stream.pipe(muxDemux).pipe stream

testDockworker = (dockworker, cb) ->
  async.parallel [
    dockworkerGetServiceToken,
    dockworkerTestTerminal
  ], cb

module.exports = (req, res, next) ->
  async.waterfall [
    dockerCheckUp,
    createContainer,
    startContainer,
    getDockworker,
    testDockworker
  ], (err) ->
    if err then next err else
      res.send(200, 'healthy')
