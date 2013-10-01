bouncy = require("bouncy")
configs = require("./configs")
net = require("net")

server = bouncy((req, res, bounce) ->
  if req.headers.token is configs.authToken
    console.log "routed"
    bounce net.connect("/var/run/docker.sock")
  else
    console.err "auth error"
    res.writeHead 401
    res.end()
    return
)
server.listen 4243
