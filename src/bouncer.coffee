configs = require './configs'
net = require 'net'
http = require 'http'
express = require 'express'
Docker = require 'dockerode'
app = express()

app.configure 'integration', ->
  app.use express.logger()

socket = configs.socket
docker = if typeof socket == 'string' 
  new Docker socketPath: socket
else
  new Docker host: 'http://localhost', port: socket

startProxy = ->
  app.listen 4243

req = http.request 
  socketPath: socket
  path: '/version'
  method: 'GET'
, startProxy

req.on 'error',  (err) ->
  console.error 'failed to connect', err
  setTimeout process.exit, 5 * 1000, 1

req.end()

app.get '/images/json', (req, res, next) ->
  docker.listImages req.query, (err, images) ->
    if err
      next err
    else
      res.json images

app.get '/containers/json', (req, res, next) ->
  docker.listContainers req.query, (err, containers) ->
    if err
      next err
    else
      res.json containers

app.get '/images/:repo?/:user?/:name/json', (req, res, next) ->
  name = req.params.name
  if req.params.user then name = req.params.user + '/' + name
  if req.params.repo then name = req.params.repo + '/' + name
  image = docker.getImage name
  image.inspect (err, image) ->
    if err
      next err
    else
      res.json image

app.post '/images/create', (req, res, next) ->
  docker.createImage req.query, (err, stream) ->
    if err
      next err
    else
      stream.pipe res

app.get '/containers/:container/json', (req, res, next) ->
  container = docker.getContainer req.params.container
  container.inspect (err, container) ->
    if err
      next err
    else
      res.json container

app.del '/containers/:container', (req, res, next) ->
  container = docker.getContainer req.params.container
  container.remove (err) ->
    if err
      next err
    else
     res.send 204

app.post '/containers/create', express.json(), (req, res, next) ->
  docker.createContainer req.body, (err, container) ->
    if err
      next err
    else
      res.json 201, Id: container.id

app.post '/containers/:container/start', express.json(), (req, res, next) ->
  container = docker.getContainer req.params.container
  container.start req.body, (err) ->
    if err
      next err
    else
      res.send 204

app.post '/containers/:container/stop', express.json(), (req, res, next) ->
  container = docker.getContainer req.params.container
  container.stop req.body, (err) ->
    if err
      next err
    else
      res.send 204

app.post '/commit', (req, res, next) ->
  container = docker.getContainer req.query.container
  container.commit req.query, (err, container) ->
    if err
      next err
    else
      res.json 201, container

app.post '/images/:repo?/:user?/:name/push', express.json(), (req, res, next) ->
  name = req.params.name
  if req.params.user then name = req.params.user + '/' + name
  if req.params.repo then name = req.params.repo + '/' + name
  image = docker.getImage name
  image.push req.body, (err, stream) ->
    if err
      next err
    else
      stream.pipe res

app.post '/build', (req, res, next) ->
  docker.buildImage req, req.query, (err, stream) ->
    if err
      next err
    else
      stream.pipe res

app.use (err, req, res, next) ->
  res.send err.statusCode || 500, err.reason || err.message

app.all '*', (req, res) ->
  console.error 'missing', req.method, req.url
  req.send 500, 'not supported'