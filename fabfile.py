#!/usr/bin/env python

from fabric.api import *

env.user = "ubuntu"
env.use_ssh_config = True
env.note = ""

"""
Environments
"""
def production():
  """
  Work on production environment
  """
  env.settings = 'production'
  env.registry = '10.0.0.60'
  env.hosts = [
    'prod-dock1',
    'prod-dock2',
    'prod-dock3',
    'prod-dock4',
    'prod-dock5',
    'prod-dock6',
    'prod-dock7',
    'prod-dock8',
    'prod-dock9',
    'prod-dock10',
    'prod-dock11',
    'prod-dock12',
  ]

def integration():
  """
  Work on integration environment
  """
  env.settings = 'integration'
  env.registry = '54.215.162.19'
  env.hosts = [
    'int-dock1',
  ]

def staging():
  """
  Work on staging environment
  """
  env.settings = 'staging'
  env.registry = '54.241.167.140'
  env.hosts = [
    'stage-dock1',
    'stage-dock2',
  ]

"""
Branches
"""
def stable():
  """
  Work on stable branch.
  """
  env.branch = 'stable'

def master():
  """
  Work on development branch.
  """
  env.branch = 'master'

def branch(branch_name):
  """
  Work on any specified branch.
  """
  env.branch = branch_name

"""
Commands - setup
"""
@parallel
def setup():
  """
  Install and start the server.
  """
  require('settings', provided_by=[production, integration, staging])
  require('branch', provided_by=[stable, master, branch])

  # install_github()
  install_docker()
  install_node()
  remove_nginx()
  setup_registry()
  clone_repo()
  install_requirements()
  boot()
  save_startup()
  reboot_machine()

@parallel
def reboot_machine():
  """
  Reboot da box
  """
  sudo('reboot')

def install_github():
  """
  Install git & github ssh keys
  """
  sudo('apt-get install -y git')
  put('~/.runnable/github_deploy', '~/.ssh/id_rsa')
  put('~/.runnable/ssh_config', '~/.ssh/config')
  setup_github_ssh_key()

def setup_github_ssh_key():
  run('chmod 700 ~/.ssh/id_rsa')
  run('chmod 700 ~/.ssh/config')
  run('killall ssh-agent')
  with prefix('eval `ssh-agent -s`'):
    run('ssh-add')

def install_docker():
  """
  Install docker.io stable
  """
  sudo('apt-get install -y linux-image-extra-`uname -r` curl')
  sudo('curl https://get.docker.io/ubuntu/info | sh -x')
  sudo('echo "*                soft    nofile          10000" >> /etc/security/limits.conf')
  sudo('echo "*                hard    nofile          10000" >> /etc/security/limits.conf')
  run('wget --output-document=docker https://get.docker.io/builds/Linux/x86_64/docker-0.6.1')
  run('chmod +x docker')
  sudo('mv ./docker /usr/bin/docker')

def install_node():
  """
  Install Node.js stable
  """
  sudo('apt-get update')
  sudo('apt-get install -y python-software-properties python g++ make')
  sudo('FORCE_ADD_APT_REPOSITORY=1 add-apt-repository ppa:chris-lea/node.js')
  sudo('apt-get update')
  sudo('apt-get install -y nodejs')

# def install_nginx():
#   """
#   Install and configure nginx
#   """
#   sudo('apt-get install -y nginx')
#   sudo('killall nginx || echo no nginx')
#   sudo('nginx -c /home/ubuntu/docklet/nginx.conf')

def remove_nginx():
  """
  Install and configure nginx
  """
  sudo('killall nginx || echo no nginx')
  sudo('apt-get remove -y nginx')

def setup_registry():
  """
  Fix registry dns entry.
  """
  require('settings', provided_by=[production, integration, staging])
  sudo('echo "%(registry)s registry.runnable.com" >> /etc/hosts' % env)
  sudo('/etc/init.d/dns-clean start')

def clone_repo():
  """
  Do initial clone of the git repository.
  """
  if run('[ -d docklet ] && echo true || echo false') == 'false':
    run('git clone git@github.com:CodeNow/docklet.git')

  with cd('docklet'):
    run('git reset --hard')
    run('git fetch --all')
    run('git checkout -f %(branch)s;' % env)
    run('git pull origin %(branch)s' % env)

def install_requirements():
  """
  Install the required packages using npm.
  """
  sudo('npm install n -g')
  sudo('n 0.10.22')
  sudo('npm install pm2@0.7.7 -g')
  sudo('rm -rf /home/ubuntu/tmp')
  with cd('docklet'):
    sudo('rm -rf node_modules')
    run('npm install')

def save_startup():
  """
  startup on machine boot
  """
  sudo('env PATH=$PATH:/usr/local/bin pm2 startup ubuntu')

@parallel
def boot():
  """
  Start process with pm2
  """
  sudo('pm2 kill || echo no pm2')
  sudo('NODE_ENV=%(settings)s pm2 start docklet/lib/index.js -n docklet' % env)
  sudo('NODE_ENV=%(settings)s pm2 start docklet/bouncer/index.js -n bouncer -i 10' % env)
  sudo('NODE_ENV=%(settings)s pm2 start docklet/containerGauge/index.js -n containerGauge' % env)

def reboot():
  """
  Start process with pm2
  """
  with cd('docklet'):
    run('make')
  sudo('pm2 restartAll')

def pm2_restartAll():
  """
  pm2 restartAll
  """
  sudo('pm2 restartAll')

def test_deployment():
  with cd('docklet'):
    run("npm run testInt")

"""
Commands - deploy
"""
def deploy():
  """
  update the server.
  """
  require('settings', provided_by=[production, integration, staging])
  require('branch', provided_by=[stable, master, branch])

  clone_repo()
  install_requirements()
  boot()
  save_startup()
#  test_deployment()

"""
Commands - delta_deploy
"""
@parallel
def delta_deploy():
  """
  increment the server.
  """
  require('settings', provided_by=[production, integration, staging])
  require('branch', provided_by=[stable, master, branch])
  clone_repo()
  reboot()

"""
Commands - delta_deploy_no_make
"""
@parallel
def delta_deploy_no_make():
  """
  increment the server.
  """
  require('settings', provided_by=[production, integration, staging])
  require('branch', provided_by=[stable, master, branch])
  clone_repo()
  pm2_restartAll()

"""
Commands - docker stuff
"""
def stopAll():
  require('settings', provided_by=[production, integration, staging])
  run('docker stop `docker ps -q | xargs echo`')

def killAll():
  require('settings', provided_by=[production, integration, staging])
  run('docker kill `docker ps -q | xargs echo`')

def ps():
  require('settings', provided_by=[production, integration, staging])
  run('docker -H=127.0.0.1:4242 ps')

def psa():
  require('settings', provided_by=[production, integration, staging])
  run('ifconfig | grep veth | wc -l')

def max_fds():
  require('settings', provided_by=[production, integration, staging])
  run('ulimit -n')

def curr_fds():
  require('settings', provided_by=[production, integration, staging])
  run('lsof | wc -l')

@parallel
def version():
  require('settings', provided_by=[production, integration, staging])
  run('docker version')

def images():
  require('settings', provided_by=[production, integration, staging])
  run('docker images')

@parallel
def info():
  require('settings', provided_by=[production, integration, staging])
  run('docker -D -H=127.0.0.1:4242 info')

@parallel
def uptime():
  require('settings', provided_by=[production, integration, staging])
  run('uptime')

def add_network_limiter():
  require('settings', provided_by=[production, integration, staging])
  with cd('docklet'):
    run("git pull && sudo ./scripts/setupContainerNetworkLimiting.sh")
######################### BASE IMAGE ENDS HERE ##############################

# git clone https://github.com/CodeNow/docklet
# <github credentials? should we install ssh keys somehow? make docklet public?>
# cd docklet
# npm install
# make
# tmux new -s docklet
# node ./lib/index.js

# sudo sh -c 'echo "54.241.154.140 registry.runnable.com" >> /etc/hosts'
# sudo /etc/init.d/dns-clean start
