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
    #'docker1',
    #'docker2',
    #'docker3',
    #'docker4',
    #'docker5',
    #'docker6',
    #'docker7',
    #'docker8',
    #'docker9',
    #'docker10',
    #'docker11',
    #'docker12',
    #'docker13',
    #'docker14',
    #'docker15',
    #'docker16',
    #'docker17',
    #'docker18',
    #'docker19',
    #'docker20',
    #'docker21',
    #'docker22',
    #'docker23',
    #'docker24',
    #'docker25',
    #'docker26',
    #'docker27',
    #'docker28',
    #'docker29',
    #'docker30',
    #'docker31',
    #'docker32',
    #'docker33',
    #'docker34',
    #'docker35',
    'docker36',
    'docker37',
    'docker38',
    #'docker39',
    'docker40',
    'docker41',
    #'docker42',
    'docker43',
    'docker44',
    'docker45',
    'docker46',
    'docker47',
    #'docker48',
    'docker49',
    'docker50',
    'docker51',
    'docker52',
    'docker53',
    'docker54',
    'docker55',
    'docker56',
    'docker57',
    'docker58',
    'docker59',
    #'docker60',
    'docker61',
    'docker62',
    'docker63',
    'docker64',
    'docker65',
    'docker66',
    'docker67',
    'docker68',
    'docker69',
    'docker70',
    'docker71',
    'docker72',
    'docker73',
    'docker74',
    'docker75',
    'docker76',
    #'docker77',
    #'docker78',
    'docker79',
    'docker80',
    #'docker81',
    'docker82',
    'docker83',
    'docker84',
    'docker85',
    'docker86',
    'docker87',
    'docker88',
    'docker89',
    'docker90',
    'docker91',
    'docker92'
    #'docker93',
    #'docker94',
    #'docker95',
    #'docker96',
    #'docker97',
    #'docker98',
    #'docker99',
    #'docker100',
    #'docker101',
    #'docker102',
    #'docker103',
    #'docker104',
    #'docker105',
    #'docker106',
    #'docker107',
    #'docker108',
    #'docker109',
    #'docker110',
    #'docker110',
    #'docker112',
    #'docker113',
    #'docker114',
    #'docker115',
    #'docker116',
    #'docker117',
    #'docker118',
    #'docker119',
    #'docker120',
    #'docker121',
    #'docker122',
    #'docker123',
    #'docker124',
    #'docker125',
    #'docker126',
    #'docker127',
    #'docker128',
    #'docker129',
    #'docker130',
    #'docker131',
    #'docker132',
    #'docker133',
    #'docker134',
    #'docker135',
    #'docker136',
    #'docker137',
    #'docker138',
    #'docker139',
    #'docker140',
    #'docker141',
    #'docker142',
    #'docker143',
    #'docker144',
    #'docker145',
    #'docker146',
    #'docker147',
    #'docker148',
    #'docker149',
    #'docker150',
    #'docker151',
    #'docker152',
    #'docker153',
    #'docker154',
    #'docker155',
    #'docker156',
    #'docker157',
    #'docker158',
    #'docker159',
    #'docker160',
    #'docker161',
    #'docker162',
    #'docker163',
    #'docker164',
    #'docker165',
    #'docker166',
    #'docker167',
    #'docker168',
    #'docker169',
    #'docker170',
    #'docker171',
    #'docker172',
    #'docker173',
    #'docker174',
    #'docker175',
    #'docker176',
    #'docker177',
    #'docker178',
    #'docker179',
    #'docker180',
    #'docker181',
    #'docker182',
    #'docker183',
    #'docker184',
    #'docker185',
    #'docker186',
    #'docker187',
    #'docker188',
    #'docker189',
    #'docker190',
    #'docker191',
    #'docker192',
    #'docker193',
    #'docker194',
    #'docker195',
    #'docker196',
    #'docker197',
    #'docker198',
    #'docker199',
    #'docker200',
    #'docker201',
    #'docker202',
    #'docker203',
    #'docker204',
    #'docker205',
    #'docker206',
    #'docker207',
    #'docker208',
    #'docker209',
    #'docker210',
    #'docker211',
    #'docker212',
    #'docker213',
    #'docker214',
    #'docker215',
    #'docker216',
    #'docker217',
    #'docker218',
    #'docker219',
    #'docker220',
    #'docker221',
    #'docker222',
    #'docker223',
    #'docker224',
    #'docker225',
    #'docker226',
    #'docker227',
    #'docker228',
    #'docker229',
    #'docker230',
    #'docker231',
    #'docker232',
    #'docker233',
    #'docker234',
    #'docker235',
    #'docker236',
    #'docker237',
    #'docker238',
    #'docker239',
    #'docker240',
    #'docker241',
    #'docker242',
    #'docker243',
    #'docker244',
    #'docker245',
    #'docker246',
    #'docker247',
    #'docker248',
    #'docker249',
    #'docker250'
  ]

def integration():
  """
  Work on staging environment
  """
  env.settings = 'integration'
  env.registry = '54.215.162.19'
  env.hosts = [
    'docker1-int',
    'docker2-int',
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
    'docker17-int',
    'docker18-int',
    'docker19-int',
    'docker20-int',
    'docker21-int',
    'docker22-int',
    'docker23-int',
    'docker24-int',
    'docker25-int',
    'docker26-int',
    'docker27-int',
    'docker28-int',
    'docker29-int',
    'docker30-int',
    'docker31-int',
    'docker32-int',
    'docker33-int',
    'docker34-int',
    'docker35-int',
    'docker36-int',
    'docker37-int',
    'docker38-int',
    'docker39-int',
    'docker40-int',
    'docker41-int',
    'docker42-int',
    'docker43-int',
    'docker44-int',
    'docker45-int',
    'docker46-int',
    'docker47-int',
    'docker48-int',
    'docker49-int',
    'docker50-int'
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
  require('settings', provided_by=[production, integration])
  require('branch', provided_by=[stable, master, branch])

  install_github()
  install_docker()
  install_node()
  remove_nginx()
  setup_registry()
  clone_repo()
  install_requirements()
  reboot_machine()

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
  require('settings', provided_by=[production, integration])
  sudo('echo "%(registry)s registry.runnable.com" >> /etc/hosts' % env)
  sudo('/etc/init.d/dns-clean start')

def clone_repo():
  """
  Do initial clone of the git repository.
  """
  run('rm -rf docklet')
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
