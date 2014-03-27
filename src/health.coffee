async = require 'async'
cls = require('continuation-local-storage')
uuid = require('uuid')
createNamespace  = cls.createNamespace
getNamespace     = cls.getNamespace
destroyNamespace = cls.destroyNamespace
request = require 'request'
docker = require('./dockerProxy')()
# imageCache = require './imageCache'
cbTimeout = require 'callback-timeout'

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
  client.host = host
  ['get', 'post', 'patch', 'put', 'del'].forEach (method)->
    client[method]   = makeAcceptPath(request[method].bind(request))
  return client

timeIt = (fn, timeout) ->
  session = getNamespace('health')
  return () ->
    start = Date.now()
    args = Array.prototype.slice.call(arguments)
    cb = args.pop()
    newCb = () ->
      timings = session.get('timings')
      timings = timings || {}
      timings[fn._name || fn.name || uuid()] = Date.now() - start
      console.log(fn._name || fn.name || uuid(), timings[fn._name || fn.name || uuid()])
      session.set('timings', timings)
      cb.apply(null, arguments)
    args.push newCb
    fn.apply(null, args)

# [code ,] messageOrErr, step
stepError = (code, messageOrErr, step) ->
  if (typeof code isnt 'number')
    step = messageOrErr
    messageOrErr = code
    code = null
  if (typeof messageOrErr is 'string')
    err = new Error(messageOrErr) #messageOrErr is message
    step = messageOrErr
  else
    err = messageOrErr #messageOrErr is error
    code = 500
  err.step = step
  err.code = code
  return err

dockerVersion = (cb) ->
  docker.version (err, versionInfo) ->
    if (err) then err = stepError(err, 'Checking docker version')
    cb(err)
dockerVersion._name = 'dockerVersion'

getReliableRepo = () ->
  return 'registry.runnable.com/runnable/53114add52f4df0039412fbb'

createContainer = (cb) ->
  session = getNamespace('health')
  self = this
  servicesToken = 'services-'+uuid.v4()
  body =
    Image: getReliableRepo(),
    Volumes: { '/dockworker': {} },
    PortSpecs: [ '80', '15000' ],
    Cmd: [ '/dockworker/bin/node', '/dockworker' ],
    Env: toEnv({
      SERVICES_TOKEN: servicesToken,
      RUNNABLE_START_CMD: 'npm start'
    })
  docker.createContainer body, (err, container) ->
    if (err)
      err.step = 'createContainer'
      cb(err)
    else
      session.set('container', container)
      session.set('servicesToken', servicesToken)
      cb()
createContainer._name = 'createContainer'

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
startContainer._name = 'startContainer' # ...coffeescript is stupid

getDockworker = (cb) ->
  session = getNamespace('health')
  container = session.get('container')
  container.inspect (err, data) ->
    if err
      cb stepError(err, 'Inspecting container')
    else if (!data or
          !data.NetworkSettings or
          !data.NetworkSettings.Ports or
          !data.NetworkSettings.Ports['15000/tcp'] or
          !data.NetworkSettings.Ports['15000/tcp'][0] or
          !data.NetworkSettings.Ports['15000/tcp'][0].HostPort)
      cb stepError('Inspecting container (missing ports)')
    else
      port = data.NetworkSettings.Ports['15000/tcp'][0].HostPort
      dockworker = toHttpClient(localhost, port)
      session.set('dockworker', dockworker)
      cb()
getDockworker._name = 'inspectContainer' # ...coffeescript is stupid

dockworkerGetServiceToken = (cb) ->
  session = getNamespace('health')
  dockworker = session.get('dockworker')
  servicesToken = session.get('servicesToken')
  dockworker.get '/api/servicesToken', (err, res, body) ->
    if err
      if ~err.message.indexOf('ECONNRESET') or ~err.message.indexOf('hang up') # then try again
        setTimeout () ->
          dockworkerGetServiceToken(cb)
        , 200
        return
      cb stepError(err, 'Getting dockworker servicesToken')
    else if res.statusCode != 200
      cb stepError(400, 'Failed to get dockworker servicesToken (statusCode:'+res.statusCode+')')
    else if body != servicesToken
      cb stepError(400, 'Dockworker servicesToken mismatch')
    else
      cb()
dockworkerGetServiceToken._name = 'dockworkerGetServiceToken' # ...coffeescript is stupid

dockworkerTestTerminal = (cb) ->
  session = getNamespace('health')
  dockworker = session.get('dockworker')
  noErrExpectSuccess = (cb) ->
    return (err, res, body) ->
      if err then cb err else
        if res.statusCode != 200 and res.statusCode != 204
          err = new Error('dockworker unexpected status code '+res.statusCode)
          err.stack = body;
          cb(err)
        else
          cb()

  async.parallel [
    (cb) -> dockworker.get '/api/checkTermUp', noErrExpectSuccess(cb)
    (cb) -> dockworker.get '/api/checkWebUp', noErrExpectSuccess(cb)
  ], cb
dockworkerTestTerminal._name = 'dockworkerTestTerminal' # ...coffeescript is stupid

testDockworker = (cb) ->
  async.series [
    timeIt(dockworkerGetServiceToken),
    timeIt(dockworkerTestTerminal)
  ], cb
testDockworker._name = 'testDockworker' # ...coffeescript is stupid

stopContainer = (cb) ->
  session = getNamespace('health')
  container = session.get('container')
  container.stop (err) ->
    if err
      cb stepError(err, 'Stopping container')
    else
      cb()
stopContainer._name = 'stopContainer' # ...coffeescript is stupid

module.exports = (req, res, next) ->
  health = createNamespace('health')
  health.run () ->
    async.series [
      timeIt(dockerVersion),
      timeIt(createContainer),
      timeIt(startContainer),
      timeIt(getDockworker),
      timeIt(testDockworker),
      timeIt(stopContainer)
    ], (err) ->
      timings = health.get('timings')
      if err
        res.json err.code || 500, {
          message: err.message
          step: err.step
          timings: timings
          stack: err.stack
        }
      else
        # console.log((new Error('stack')).stack);
        res.json(200, {
          status: 'healthy'
          timings: timings
        })
      try # cls throws errors occasionally
        destroyNamespace('health')