util = require("util")
ws = require("ws")
DuplexStream = require("stream").Duplex
ShoeClient = module.exports = ShoeClient = (uri) ->
  return new ShoeClient(uri)  unless this instanceof ShoeClient
  DuplexStream.apply this
  @setEncoding "utf8"
  @_connected = false
  @_writeQueue = []
  uri = uri + "/websocket"
  @_ws = new ws(uri)
  self = this
  @_ws.on "open", ->
    self._connected = true
    self.emit "open"
    self._flushQueue()
    return

  @_ws.on "message", (message) ->
    self.push message.toString()
    return

  return

util.inherits ShoeClient, DuplexStream
ShoeClient::_write = (chunk, encoding, callback) ->
  unless @_connected
    @_writeQueue.push chunk.toString()
    return callback()
  @_ws.send chunk.toString()
  callback()
  return

ShoeClient::_flushQueue = ->
  message = @_writeQueue.shift()
  while message
    @_ws.send message
    message = @_writeQueue.shift()
  return

ShoeClient::_read = ->