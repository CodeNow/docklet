async = require 'async'
cls = require('continuation-local-storage')
createNamespace = cls.createNamespace
getNamespace    = cls.getNamespace
request = require 'request'
docker = require('./dockerProxy')()
ShoeClient = require './ShoeClient'
MuxDemux = require 'mux-demux'
# imageCache = require './imageCache'
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

# [code ,] step, messageOrErr
stepError = (code, messageOrErr, step) ->
  if (typeof code isnt 'number')
    step = messageOrErr
    messageOrErr = code
    code = null
  if (typeof messageOrErr is 'string')
    err = new Error(messageOrErr) #messageOrErr is message
    step = message
  else
    err = messageOrErr #messageOrErr is error
    code = 500
  err.step = step
  err.code = code

dockerCheckUp = (cb) ->
  docker.version (err, versionInfo) ->
    if (err) then err = stepError(err, 'Checking docker version')
    cb(err)

getReliableRepo = () ->
  return 'registry.runnable.com/runnable/53114add52f4df0039412fbb'

createContainer = (cb) ->
  session = getNamespace('health')
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
  docker.createContainer body, (err, container) ->
    if (err)
      err.step = 'createContainer'
      cb(err)
    else
      session.set('container', container)
      cb()

startContainer = (cb) ->
  session = getNamespace('health')
  container = session.get('container')
  container.start {
    Binds: ["/home/ubuntu/dockworker:/dockworker:ro"],
    PortBindings: {
      "80/tcp": [{}],
      "15000/tcp": [{}]
    }
  }, (err) ->
    if err then err = stepError(err, 'Starting container')
    cb(err)

getDockworker = (cb) ->
  session = getNamespace('health')
  container = session.get('container')
  container.inspect (err, data) ->
    if err
      cb stepError(err, 'Inspecting container')
    else
      if (!data or
          !data.NetworkSettings or
          !data.NetworkSettings.PortMapping or
          !data.NetworkSettings.PortMapping.Tcp or
          !data.NetworkSettings.PortMapping.Tcp[15000])
        cb stepError('Inspecting container (missing ports)')
      else
        port = data.NetworkSettings.PortMapping.Tcp[15000]
        dockworker = toHttpClient(localhost, port)
        dockworker.url = (localhost +':'+ port)
        session.set 'dockworker', dockworker
        cb null, dockworker

dockworkerGetServiceToken = (cb) ->
  session = getNamespace('health')
  dockworker = session.get('dockworker')
  servicesToken = session.get('servicesToken')
  dockworker.get '/api/serviceToken', (err, res, body) ->
    if err
      cb stepError('Getting dockworker servicesToken', err)
    else if res.statusCode != 200
      cb stepError(400, 'Failed to get dockworker servicesToken (statusCode:'+res.statusCode+')')
    else if body !== servicesToken
      cb stepError(400, 'Dockworker servicesToken mismatch')
    else
      cb(null, body)

dockworkerTestTerminal = (cb) ->
  session = getNamespace('health')
  dockworkerUrl = session.get('dockworker').url
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

testDockworker = (cb) ->
  async.parallel [
    dockworkerGetServiceToken,
    dockworkerTestTerminal
  ], cb

module.exports = (req, res, next) ->
  createNamespace('health')
  async.series [
    dockerCheckUp,
    createContainer,
    startContainer,
    getDockworker,
    testDockworker
  ], (err) ->
    if err
      res.json err.code || 500, {
        message: err.message,
        step: err.step
      }
    else
      res.send(200, 'healthy')

req = {
  send: console.log.bind(console, 'SEND')
}
res = {}
next = console.log.bind(console, 'NEXT')
module.exports(req ,res, next)