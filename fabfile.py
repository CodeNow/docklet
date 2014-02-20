#!/usr/bin/env python

from fabric.api import *

env.user = "ubuntu"
env.use_ssh_config = True


"""



"""



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
    'docker-2-86', # new
    'docker-2-87', # new
    'docker-2-203', # newer
    'docker-2-152', # newer
    # 'docker-5-66', # temp
    # 'docker-5-72', # temp
    # 'docker-5-73', # temp
    # 'docker-5-74', # temp
    # 'docker-5-76', # temp
    # 'docker-5-77', # temp
    # 'docker-5-78', # temp
    # 'docker-5-79', # temp
    # 'docker-5-83', # temp
    # 'docker-5-86', # temp
    # 'docker-5-92', # temp
    # 'docker-5-93', # temp
    # 'docker-5-94', # temp
    # 'docker-5-95', # temp
  ]

def integration():
  """
  Work on staging environment
  """
  env.settings = 'integration'
  env.registry = '54.215.162.19'
  env.hosts = [
    # 'docker2-int',
    'docker3-int',
    'docker4-int',
    # 'docker5-int',
    # 'docker6-int'
  ]

def staging():
  """
  Work on staging environment
  """
  env.settings = 'integration'
  env.registry = '54.193.83.5'
  env.hosts = [
    'docker-rep_int'
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

  install_github()
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
  run('chmod 700 ~/.ssh/id_rsa')
  run('chmod 700 ~/.ssh/config')
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
    run('git clone https://github.com/CodeNow/docklet.git')

  with cd('docklet'):
    run('git reset --hard')
    run('git fetch')
    run('git checkout %(branch)s;' % env)
    run('git pull origin %(branch)s' % env)

def install_requirements():
  """
  Install the required packages using npm.
  """
  sudo('npm install n -g')
  sudo('n 0.8.26')
  sudo('npm install pm2@0.5.6 -g')
  sudo('rm -rf /home/ubuntu/tmp')
  with cd('docklet'):
    sudo('rm -rf node_modules')
    run('npm install')
    run('npm run build')

def save_startup():
  """
  startup on machine boot
  """
  sudo('env PATH=$PATH:/usr/local/bin pm2 startup')

@parallel
def boot():
  """
  Start process with pm2
  """
  sudo('pm2 kill || echo no pm2')
  sudo('NODE_ENV=%(settings)s pm2 start docklet/lib/index.js -n docklet' % env)
  sudo('NODE_ENV=%(settings)s pm2 start docklet/lib/bouncer.js -n bouncer -i 10' % env)

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

"""
Commands - deploy
"""
@parallel
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
  sudo('docker stop `docker ps -q | xargs echo`')

def killAll():
  require('settings', provided_by=[production, integration, staging])
  sudo('docker kill `docker ps -q | xargs echo`')

def ps():
  require('settings', provided_by=[production, integration, staging])
  sudo('docker ps')

def psa():
  require('settings', provided_by=[production, integration, staging])
  sudo('docker ps -a')

def max_fds():
  require('settings', provided_by=[production, integration, staging])
  sudo('ulimit -n')

def curr_fds():
  require('settings', provided_by=[production, integration, staging])
  sudo('lsof | wc -l')

@parallel
def version():
  require('settings', provided_by=[production, integration, staging])
  sudo('docker version')

def images():
  require('settings', provided_by=[production, integration, staging])
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
