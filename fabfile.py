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
  env.registry = '54.241.154.140'
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
  env.registry = '54.215.162.19'
  env.hosts = [
    # 'docker1-int',
    # 'docker2-int',
    # 'docker3-int',
    # 'docker4-int',
    # 'docker5-int',
    # 'docker6-int',
    # 'docker7-int',
    # 'docker8-int',
    # 'docker9-int',
    # 'docker10-int',
    # 'docker11-int',
    # 'docker12-int',
    # 'docker13-int',
    # 'docker14-int',
    # 'docker15-int',
    # 'docker16-int',
    # 'docker17-int',
    # 'docker18-int',
    # 'docker19-int',
    # 'docker20-int',
    # 'docker21-int',
    # 'docker22-int',
    # 'docker23-int',
    # 'docker24-int',
    # 'docker25-int',
    # 'docker26-int',
    # 'docker27-int',
    # 'docker28-int',
    # 'docker29-int',
    # 'docker30-int',
    # 'docker31-int',
    # 'docker32-int',
    # 'docker33-int',
    # 'docker34-int',
    # 'docker35-int',
    'docker36-int',
    # 'docker37-int',
    # 'docker38-int',
    # 'docker39-int',
    # 'docker40-int',
    # 'docker41-int',
    # 'docker42-int',
    # 'docker43-int',
    # 'docker44-int',
    # 'docker45-int',
    # 'docker46-int',
    # 'docker47-int',
    # 'docker48-int',
    # 'docker49-int',
    # 'docker50-int'
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

  install_github()
  install_docker()
  install_node()
  remove_nginx()
  setup_registry()
  clone_repo()
  install_requirements()
  boot()

def install_github():
  """
  Install git & github ssh keys
  """
  sudo('apt-get install -y git')
  put('~/.runnable/github_deploy', '~/.ssh/id_rsa')
  run('chmod 700 ~/.ssh/id_rsa')
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
  sudo('sudo add-apt-repository ppa:chris-lea/node.js')
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
  require('settings', provided_by=[production, integration])
  sudo('echo "%(registry)s registry.runnable.com" >> /etc/hosts' % env)
  sudo('/etc/init.d/dns-clean start')

def clone_repo():
  """
  Do initial clone of the git repository.
  """
  if run('[ -d docklet ] && echo true || echo false') == 'false':
    run('git clone git@github.com:CodeNow/docklet.git')

  with cd('docklet'):
    run('git fetch')
    run('git reset --hard')
    run('git checkout %(branch)s;' % env)
    run('git pull origin %(branch)s' % env)

def install_requirements():
  """
  Install the required packages using npm.
  """
  sudo('npm install n -g')
  sudo('n 0.10.18')
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
  sudo('pm2 kill')
  sudo('NODE_ENV=%(settings)s pm2 start docklet/lib/index.js -n docklet' % env)
  sudo('NODE_ENV=%(settings)s pm2 start docklet/lib/bouncer.js -n bouncer -i 10' % env)

def reboot():
  """
  Start process with pm2
  """
  with cd('docklet'):
    run('make')
  sudo('pm2 restartAll')

"""
Commands - deploy
"""
@parallel
def deploy():
  """
  update the server.
  """
  require('settings', provided_by=[production, integration])
  require('branch', provided_by=[stable, master, branch])
  clone_repo()
  remove_nginx()
  install_requirements()
  boot()

"""
Commands - delta_deploy
"""
# @parallel
def delta_deploy():
  """
  increment the server.
  """
  require('settings', provided_by=[production, integration])
  require('branch', provided_by=[stable, master, branch])
  clone_repo()
  reboot()

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

@parallel
def version():
  require('settings', provided_by=[production, integration])
  sudo('docker version')

def images():
  require('settings', provided_by=[production, integration])
  sudo('docker images')
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
