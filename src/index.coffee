docker = require './docker'
etcd = require 'node-etcd'

c = new etcd()

w = c.watcher '/runnables'

index = 0

w.on 'change', (value) ->

  if value.newKey and value.value is 'request'

    c.get value.key.replace('state', 'repo'), (err, val) ->
      if not err
        repo = val.value
        console.log "finding image #{repo}"
        docker.findImage repo, (err, found) ->
          if err then console.log err else
            response = () ->
              c.setTest value.key.replace('state', 'docklet'), '0', 'undefined', (err, val) ->
                if err then console.log err else
                  if val.value is '0' then console.log "docklet #{index} aquired the lock to run image #{repo}"
            if found
              console.log "found image #{repo}"
              response()
            else
              console.log "not found. pulling image #{repo}"
              docker.pullImage repo, (err) ->
                if err then console.log err else
                  console.log "pulled image #{repo}"
                  response()