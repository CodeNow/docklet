configs = require './configs'
docker = require './docker'
etcd = require 'node-etcd'

c = new etcd configs.etcd_host, configs.etcd_port

w = c.watcher '/runnables'

index = Number process.argv[2]

w.on 'change', (value) ->

  if value.newKey and value.value is 'request'

    c.get value.key.replace('state', 'repo'), (err, val) ->
      if not err
        repo = val.value
        console.log "finding image #{repo}"
        docker.findImage repo, (err) ->
          if err then console.log err else
            c.setTest value.key.replace('state', 'docklet'), index.toString(), 'undefined', (err, val) ->
              if err then console.log err else
                if val?.value is index.toString() then console.log "docklet #{index} aquired the lock to run image #{repo}" else
                  console.log "docklet #{index} did not win the race to start a container from image #{repo}"
