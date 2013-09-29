configs = require './configs'
ip = module.exports = if configs.networkInterface == 'lo0'
   'localhost'
else
  require("os")
    .networkInterfaces()[configs.networkInterface]
    .filter((iface) ->
      iface.family is "IPv4"
    )[0].address