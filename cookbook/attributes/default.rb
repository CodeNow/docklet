default['runnable_docklet']['deploy_path']	= '/opt/docklet'

default['runnable_docklet']['config'] 		= {
  # host of docker service
  'docker_host' 			=> 'http://localhost',
  # port of docker service
  'docker_port' 			=> 4242,
  # port of bouncer
  'bouncer_port' 			=> 4243,
  # port for redis
  'redisPort' 				=> '6379',
  # network interface which connects to outside world. this value is sent to client wanting to know how to contact it
  'networkInterface' 		=> 'eth0',
  # application key for rollbar
  'rollbar' 				=> '34dfc593cf14456985c66ffc12c6acc4'
}

case node.chef_environment
when 'integration', 'staging'
  # auth to connect to docker (not yet implemented on docker service)
  default['runnable_docklet']['config']['authToken'] = 'a9EMw78XTTAS9OeGfqSqVnVZX337jiQT',
  default['runnable_docklet']['config']['auth'] = {
    'user' => 'runnableIntegration',
    'password' => 'calculus'
  }
when 'production'
  # auth to connect to docker (not yet implemented on docker service)
  default['runnable_docklet']['config']['authToken'] = '8EM1dX06788BnRzZ9eaqrCLLmzokmgNe',
  default['runnable_docklet']['config']['auth'] = {
    'user' => 'runnableProduction',
    'password' => 'insertWittyPasswordHere'
  }
end

case node.chef_environment
when 'integration'
  # ip of docker registry server
  default['runnable_docklet']['registry']	= '54.215.162.19'
  # domain name this app is running on
  default['runnable_docklet']['config']['domain'] = 'cloudcosmos.com'
when 'staging'
  # ip of docker registry server
  default['runnable_docklet']['registry']	= '54.241.167.140'
  # domain name this app is running on
  default['runnable_docklet']['config']['domain'] = 'runnable.pw'
when 'production'
  # ip of docker registry server
  default['runnable_docklet']['registry']	= '10.0.0.60'
  # domain name this app is running on
  default['runnable_docklet']['config']['domain'] = 'runnable.com'
else
  throw 'Error: unrecognized chef_environment. Must be one of: integration, staging, production'
end
