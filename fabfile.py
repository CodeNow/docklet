#!/usr/bin/env python

from fabric.api import *

env.user = "ubuntu"
env.use_ssh_config = True


"""

    'docker-5-27',
    'docker-5-28',
    'docker-5-29',
    'docker-5-30',
    'docker-5-31',
    'docker-5-32',
    'docker-5-33',
    'docker-5-34',
    'docker-5-35',
    'docker-5-36',
    'docker-5-37',
    'docker-5-38',
    'docker-5-39',
    'docker-5-40',
    'docker-5-41',
    'docker-5-42',
    'docker-5-43',
    'docker-5-44',
    'docker-5-45',
    'docker-5-46',
    'docker-5-47',
    'docker-5-48',
    'docker-5-49',
    'docker-5-50',
    'docker-5-51',
    'docker-5-52',
    'docker-5-53',
    'docker-5-54',
    'docker-5-55',
    'docker-5-56',
    'docker-5-57',
    'docker-5-58',
    'docker-5-59',
    'docker-5-60',
    'docker-5-61',
    'docker-5-62',
    'docker-5-63',
    'docker-5-64',
    'docker-5-65',
    'docker-5-66',
    'docker-5-67',
    'docker-5-68',
    'docker-5-69',
    'docker-5-70',
    'docker-5-71',
    'docker-5-72',
    'docker-5-73',
    'docker-5-74',
    'docker-5-75',
    'docker-5-76',
    'docker-5-77',
    'docker-5-78',
    'docker-5-79',
    'docker-5-80',
    'docker-5-81',
    'docker-5-82',
    'docker-5-83',
    'docker-5-84',
    'docker-5-85',
    'docker-5-86',
    'docker-5-87',
    'docker-5-88',
    'docker-5-89',
    'docker-5-90',
    'docker-5-91',
    'docker-5-92',
    'docker-5-93',
    'docker-5-94',
    'docker-5-95',
    'docker-5-96',
    'docker-5-97',
    'docker-5-98',
    'docker-5-99',
    'docker-5-100',
    'docker-5-101',
    'docker-5-102',
    'docker-5-103',
    'docker-5-104',
    'docker-5-105',
    'docker-5-106',
    'docker-5-107',
    'docker-5-108',
    'docker-5-109',
    'docker-5-110',
    'docker-5-110',
    'docker-5-112',
    'docker-5-113',
    'docker-5-114',
    'docker-5-115',
    'docker-5-116',
    'docker-5-117',
    'docker-5-118',
    'docker-5-119',
    'docker-5-120',
    'docker-5-121',
    'docker-5-122',
    'docker-5-123',
    'docker-5-124',
    'docker-5-125',
    'docker-5-126',
    'docker-5-127',
    'docker-5-128',
    'docker-5-129',
    'docker-5-130',
    'docker-5-131',
    'docker-5-132',
    'docker-5-133',
    'docker-5-134',
    'docker-5-135',
    'docker-5-136',
    'docker-5-137',
    'docker-5-138',
    'docker-5-139',
    'docker-5-140',
    'docker-5-141',
    'docker-5-142',
    'docker-5-143',
    'docker-5-144',
    'docker-5-145',
    'docker-5-146',
    'docker-5-147',
    'docker-5-148',
    'docker-5-149',
    'docker-5-150',
    'docker-5-151',
    'docker-5-152',
    'docker-5-153',
    'docker-5-154',
    'docker-5-155',
    'docker-5-156',
    'docker-5-157',
    'docker-5-158',
    'docker-5-159',
    'docker-5-160',
    'docker-5-161',
    'docker-5-162',
    'docker-5-163',
    'docker-5-164',
    'docker-5-165',
    'docker-5-166',
    'docker-5-167',
    'docker-5-168',
    'docker-5-169',
    'docker-5-170',
    'docker-5-171',
    'docker-5-172',
    'docker-5-173',
    'docker-5-174',
    'docker-5-175',
    'docker-5-176',
    'docker-5-177',
    'docker-5-178',
    'docker-5-179',
    'docker-5-180',
    'docker-5-181',
    'docker-5-182',
    'docker-5-183',
    'docker-5-184',
    'docker-5-185',
    'docker-5-186',
    'docker-5-187',
    'docker-5-188',
    'docker-5-189',
    'docker-5-190',
    'docker-5-191',
    'docker-5-192',
    'docker-5-193',
    'docker-5-194',
    'docker-5-195',
    'docker-5-196',
    'docker-5-197',
    'docker-5-198',
    'docker-5-199',
    'docker-5-200',
    'docker-5-201',
    'docker-5-202',
    'docker-5-203',
    'docker-5-204',
    'docker-5-205',
    'docker-5-206',
    'docker-5-207',
    'docker-5-208',
    'docker-5-209',
    'docker-5-210',
    'docker-5-211',
    'docker-5-212',
    'docker-5-213',
    'docker-5-214',
    'docker-5-215',
    'docker-5-216',
    'docker-5-217',
    'docker-5-218',
    'docker-5-219',
    'docker-5-220',
    'docker-5-221',
    'docker-5-222',
    'docker-5-223',
    'docker-5-224',
    'docker-5-225',
    'docker-5-226',
    'docker-5-227',
    'docker-5-228',
    'docker-5-229',
    'docker-5-230',
    'docker-5-231',
    'docker-5-232',
    'docker-5-233',
    'docker-5-234',
    'docker-5-235',
    'docker-5-236',
    'docker-5-237',
    'docker-5-238',
    'docker-5-239',
    'docker-5-240',
    'docker-5-241',
    'docker-5-242',
    'docker-5-243',
    'docker-5-244',
    'docker-5-245',
    'docker-5-246',
    'docker-5-247',
    'docker-5-248',
    'docker-5-249',
    'docker-5-251',
    'docker-5-252',
    'docker-5-253',
    'docker-5-254',
    'docker-5-255'


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
    #'docker-5-1',
    #'docker-5-2',
    #'docker-5-3',
    'docker-5-4',
    'docker-5-5',
    'docker-5-6',
    'docker-5-7',
    'docker-5-8',
    'docker-5-9',
    'docker-5-10',
    'docker-5-11',
    'docker-5-12',
    'docker-5-13',
    'docker-5-14',
    'docker-5-15',
    'docker-5-16',
    'docker-5-17',
    'docker-5-18',
    'docker-5-19',
    'docker-5-20',
    'docker-5-21',
    'docker-5-22',
    'docker-5-23',
    'docker-5-24',
    'docker-5-25',
    'docker-5-26',
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
