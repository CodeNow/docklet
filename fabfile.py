#!/usr/bin/env python

from fabric.api import *

env.user = "ubuntu"
env.use_ssh_config = True

"""
Environments
"""
def production():
  """
  Work on production environment
  """
  env.settings = 'production'
  env.hosts = [
    # 'docker',
    # 'docker2',
    # 'docker3',
    'docker4'
  ]

def integration():
  """
  Work on staging environment
  """
  env.settings = 'integration'
  env.hosts = [
    'docker3-int',
    'docker4-int',
    'docker5-int',
    'docker6-int',
    'docker7-int',
    'docker8-int',
    'docker9-int',
    'docker10-int',
    'docker11-int',
    'docker12-int',
    'docker13-int',
    'docker14-int',
    'docker15-int',
    'docker16-int',
    'docker17-int'
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
def setup():
  """
  Install and start the server.
  """
  require('settings', provided_by=[production, integration])
  require('branch', provided_by=[stable, master, branch])

  install_ssh_key()
  install_docker()
  install_node()
  setup_registry()
  clone_repo()
  install_nginx()
  install_requirements()
  boot()

def install_ssh_key():
  """
  Install github ssh keys
  """
  put('~/.runnable/github_deploy', '~/.ssh/id_rsa')
  run('ssh-add ~/.ssh/id_rsa')

def install_docker():
  """
  Install docker.io stable
  """
  sudo('apt-get install -y linux-image-extra-`uname -r` curl')
  sudo('curl https://get.docker.io/ubuntu/info | sh -x')
  sudo('echo "*                soft    nofile          10000" >> /etc/security/limits.conf')
  sudo('echo "*                hard    nofile          10000" >> /etc/security/limits.conf')

def install_node():
  """
  Install Node.js stable
  """
  sudo('apt-get update')
  sudo('apt-get install -y python-software-properties python g++ make')
  sudo('sudo add-apt-repository ppa:chris-lea/node.js')
  sudo('apt-get update')
  sudo('apt-get install -y nodejs')

def install_nginx():
  """
  Install and configure nginx
  """
  sudo('apt-get install -y nginx')
  sudo('killall nginx || echo no nginx')
  sudo('nginx -c /home/ubuntu/docklet/nginx.conf')

def setup_registry():
  """
  Fix registry dns entry.
  """
  sudo('echo "54.241.154.140 registry.runnable.com" >> /etc/hosts')
  sudo('/etc/init.d/dns-clean start')

def clone_repo():
  """
  Do initial clone of the git repository.
  """
  sudo('apt-get install -y git')
  if run('[ -d docklet ] && echo true || echo false') == 'false':
    run('git clone git@github.com:CodeNow/docklet.git')

  with cd('docklet'):
    run('git checkout %(branch)s; git pull origin %(branch)s' % env)

def install_requirements():
  """
  Install the required packages using npm.
  """
  sudo('npm install pm2 -g')
  sudo('rm -rf /home/ubuntu/tmp')
  with cd('docklet'):
    run('rm -rf node_modules')
    run('npm install')
    run('make')

def boot():
  """
  Start process with pm2
  """
  run('pm2 stopAll')
  run('NODE_ENV=%(settings)s pm2 start docklet/lib/index.js -n docklet' % env)
  # run('NODE_ENV=%(settings)s pm2 start docklet/scripts/lxc-skelly.js -n paladin' % env)

"""
Commands - deploy
"""
def deploy():
  """
  update the server.
  """
  require('settings', provided_by=[production, integration])
  require('branch', provided_by=[stable, master, branch])
  clone_repo()
  install_nginx()
  install_requirements()
  boot()

"""
Commands - docker stuff
"""
def stopAll():
  require('settings', provided_by=[production, integration])
  sudo('docker stop `docker ps -q | xargs echo`')

def killAll():
  require('settings', provided_by=[production, integration])
  sudo('docker kill `docker ps -q | xargs echo`')

def ps():
  require('settings', provided_by=[production, integration])
  sudo('docker ps')

def psa():
  require('settings', provided_by=[production, integration])
  sudo('docker ps -a')

def max_fds():
  require('settings', provided_by=[production, integration])
  sudo('ulimit -n')

def curr_fds():
  require('settings', provided_by=[production, integration])
  sudo('lsof | wc -l')

def version():
  require('settings', provided_by=[production, integration])
  sudo('docker version')

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
