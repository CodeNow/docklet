VitalSigns = require 'vitalsigns'
vitals = module.exports = new VitalSigns
  autoCheck: 5000
  httpHealthy: 200
  httpUnhealthy: 503

vitals.monitor 'cpu'
vitals.monitor 'mem', units: 'MB'

vitals
  .unhealthyWhen('cpu', 'usage')
  .greaterThan(80)

vitals
  .unhealthyWhen('mem', 'free')
  .lessThan(500)

setInterval ->
  console.log 'vitals', vitals.getReport()
, 6000