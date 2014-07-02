default['runnable_docklet']['deploy_path']	= '/opt/docklet'
default['runnable_docklet']['registry'] = ''
default['runnable_docklet']['config'] 		= {
  'domain'            => '',
  # host of docker service
  'docker_host' 			=> 'http://localhost',
  # port of docker service
  'docker_port' 			=> 4242,
  # port of bouncer
  'bouncer_port' 			=> 4243,
  # port for redis
  'redisPort' 				=> '6379',
  # network interface which connects to outside world. this value is sent to client wanting to know how to contact it
  'networkInterface' 	=> 'eth0',
  # application key for rollbar
  'rollbar' 				  => '34dfc593cf14456985c66ffc12c6acc4',
  'authToken'         => 'a9EMw78XTTAS9OeGfqSqVnVZX337jiQT',
  'auth'              => {
    'user'     => 'runnableIntegration',
    'password' => 'calculus'
  }
}