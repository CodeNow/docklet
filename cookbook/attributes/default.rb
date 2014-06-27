default['runnable_docklet']['deploy_path']	= '/opt/docklet'

default['runnable_docklet']['config'] 		= {
  'socket' 					=> '/var/run/docker.sock',
  'docker_host' 			=> 'http://localhost',
  'docker_port' 			=> 4242,
  'bouncer_port' 			=> 4243,
  'checkImageInterval' 		=> '30 seconds',
  'redisPort' 				=> '6379',
  'networkInterface' 		=> 'eth0',
  'bounceWorkerLifeSpan' 	=> 18000000,
  'rollbar' 				=> '34dfc593cf14456985c66ffc12c6acc4',
  'auth' 					=> {},
  'statsd'					=> {}
}

default['runnable_docklet']['config']['statsd'] = {
    'name' => "docklet.#{node.chef_environment}.",
    'host' => 'ec2-54-241-57-94.us-west-1.compute.amazonaws.com'
}

case node.chef_environment
when 'integration', 'staging'
  default['runnable_docklet']['config']['authToken'] = 'a9EMw78XTTAS9OeGfqSqVnVZX337jiQT',
  default['runnable_docklet']['config']['auth'] = {
    'user' => 'runnableIntegration',
    'password' => 'calculus'
  }
when 'production'
  default['runnable_docklet']['config']['authToken'] = '8EM1dX06788BnRzZ9eaqrCLLmzokmgNe',
  default['runnable_docklet']['config']['auth'] = {
    'user' => 'runnableProduction',
    'password' => 'insertWittyPasswordHere'
  }
end

case node.chef_environment
when 'integration'
  default['runnable_docklet']['registry']	= '54.215.162.19'
  default['runnable_docklet']['config']['redisHost'] = '10.0.1.14'
  default['runnable_docklet']['config']['domain'] = 'cloudcosmos.com'
when 'staging'
  default['runnable_docklet']['registry']	= '54.241.167.140'
  default['runnable_docklet']['config']['redisHost'] = '10.0.1.125',
  default['runnable_docklet']['config']['domain'] = 'runnable.pw'
when 'production'
  default['runnable_docklet']['registry']	= '10.0.0.60'
  default['runnable_docklet']['config']['redisHost'] = '10.0.1.20'
  default['runnable_docklet']['config']['domain'] = 'runnable.com'
else
  throw 'Error: unrecognized chef_environment. Must be one of: integration, staging, production'
end
