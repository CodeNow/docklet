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
    # 'docker-4-5',
    # 'docker-4-6',
    # 'docker-4-7',
    # 'docker-4-8',
    # 'docker-4-9',
    # 'docker-4-10',
    # 'docker-4-11',
    # 'docker-4-12',
    # 'docker-4-13',
    # 'docker-4-14',
    # 'docker-4-15',
    # 'docker-4-16',
    # 'docker-4-17',
    # 'docker-4-18',
    # 'docker-4-19',
    # 'docker-4-20',
    # 'docker-4-21',
    # 'docker-4-22',
    # 'docker-4-23',
    # 'docker-4-24',
    # 'docker-4-25',
    # 'docker-4-26',
    # 'docker-4-27',
    # 'docker-4-28',
    # 'docker-4-29',
    # 'docker-4-30',
    # 'docker-4-31',
    # 'docker-4-32',
    # 'docker-4-33',
    # 'docker-4-34',
    # 'docker-4-35',
    # 'docker-4-36',
    # 'docker-4-37',
    # 'docker-4-38',
    # 'docker-4-39',
    # 'docker-4-40',
    # 'docker-4-41',
    # 'docker-4-42',
    # 'docker-4-43',
    # 'docker-4-44',
    # 'docker-4-45',
    # 'docker-4-46',
    # 'docker-4-47',
    # 'docker-4-48',
    # 'docker-4-49',
    # 'docker-4-50',
    # 'docker-4-51',
    # 'docker-4-52',
    # 'docker-4-53',
    # 'docker-4-54',
    # 'docker-4-55',
    # 'docker-4-56',
    # 'docker-4-57',
    # 'docker-4-58',
    # 'docker-4-59',
    # 'docker-4-60',
    # 'docker-4-61',
    # 'docker-4-62',
    # 'docker-4-63',
    # 'docker-4-64',
    # 'docker-4-65',
    # 'docker-4-66',
    # 'docker-4-67',
    # 'docker-4-68',
    # 'docker-4-69',
    # 'docker-4-70',
    # 'docker-4-71',
    # 'docker-4-72',
    # 'docker-4-73',
    # 'docker-4-74',
    # 'docker-4-75',
    # 'docker-4-76',
    # 'docker-4-77',
    # 'docker-4-78',
    # 'docker-4-79',
    # 'docker-4-80',
    # 'docker-4-81',
    # 'docker-4-82',
    # 'docker-4-83',
    # 'docker-4-84',
    # 'docker-4-85',
    # 'docker-4-86',
    # 'docker-4-87',
    # 'docker-4-88',
    # 'docker-4-89',
    # 'docker-4-90',
    # 'docker-4-91',
    # 'docker-4-92',
    # 'docker-4-93',
    # 'docker-4-94',
    # 'docker-4-95',
    # 'docker-4-96',
    # 'docker-4-97',
    # 'docker-4-98',
    # 'docker-4-99',
    # 'docker-4-100',
    # 'docker-4-101',
    # 'docker-4-102',
    # 'docker-4-103',
    # 'docker-4-104',
    # 'docker-4-105',
    # 'docker-4-106',
    # 'docker-4-107',
    # 'docker-4-108',
    # 'docker-4-109',
    # 'docker-4-110',
    # 'docker-4-110',
    # 'docker-4-112',
    # 'docker-4-113',
    # 'docker-4-114',
    # 'docker-4-115',
    # 'docker-4-116',
    # 'docker-4-117',
    # 'docker-4-118',
    # 'docker-4-119',
    # 'docker-4-120',
    # 'docker-4-121',
    # 'docker-4-122',
    # 'docker-4-123',
    # 'docker-4-124',
    # 'docker-4-125',
    # 'docker-4-126',
    # 'docker-4-127',
    # 'docker-4-128',
    # 'docker-4-129',
    # 'docker-4-130',
    # 'docker-4-131',
    # 'docker-4-132',
    # 'docker-4-133',
    # 'docker-4-134',
    # 'docker-4-135',
    # 'docker-4-136',
    # 'docker-4-137',
    # 'docker-4-138',
    # 'docker-4-139',
    # 'docker-4-140',
    # 'docker-4-141',
    # 'docker-4-142',
    # 'docker-4-143',
    # 'docker-4-144',
    # 'docker-4-145',
    # 'docker-4-146',
    # 'docker-4-147',
    # 'docker-4-148',
    # 'docker-4-149',
    # 'docker-4-150',
    # 'docker-4-151',
    # 'docker-4-152',
    # 'docker-4-153',
    # 'docker-4-154',
    # 'docker-4-155',
    # 'docker-4-156',
    # 'docker-4-157',
    # 'docker-4-158',
    # 'docker-4-159',
    # 'docker-4-160',
    # 'docker-4-161',
    # 'docker-4-162',
    # 'docker-4-163',
    # 'docker-4-164',
    # 'docker-4-165',
    # 'docker-4-166',
    # 'docker-4-167',
    # 'docker-4-168',
    # 'docker-4-169',
    # 'docker-4-170',
    # 'docker-4-171',
    # 'docker-4-172',
    # 'docker-4-173',
    # 'docker-4-174',
    # 'docker-4-175',
    # 'docker-4-176',
    # 'docker-4-177',
    # 'docker-4-178',
    # 'docker-4-179',
    # 'docker-4-180',
    # 'docker-4-181',
    # 'docker-4-182',
    # 'docker-4-183',
    # 'docker-4-184',
    # 'docker-4-185',
    # 'docker-4-186',
    # 'docker-4-187',
    # 'docker-4-188',
    # 'docker-4-189',
    # 'docker-4-190',
    # 'docker-4-191',
    # 'docker-4-192',
    # 'docker-4-193',
    # 'docker-4-194',
    # 'docker-4-195',
    # 'docker-4-196',
    # 'docker-4-197',
    # 'docker-4-198',
    # 'docker-4-199',
    # 'docker-4-200',
    # 'docker-4-201',
    # 'docker-4-202',
    # 'docker-4-203',
    # 'docker-4-204',
    # 'docker-4-205',
    # 'docker-4-206',
    # 'docker-4-207',
    # 'docker-4-208',
    # 'docker-4-209',
    # 'docker-4-210',
    # 'docker-4-211',
    # 'docker-4-212',
    # 'docker-4-213',
    # 'docker-4-214',
    # 'docker-4-215',
    # 'docker-4-216',
    # 'docker-4-217',
    # 'docker-4-218',
    # 'docker-4-219',
    # 'docker-4-220',
    # 'docker-4-221',
    # 'docker-4-222',
    # 'docker-4-223',
    # 'docker-4-224',
    # 'docker-4-225',
    # 'docker-4-226',
    # 'docker-4-227',
    # 'docker-4-228',
    # 'docker-4-229',
    # 'docker-4-230',
    # 'docker-4-231',
    # 'docker-4-232',
    # 'docker-4-233',
    # 'docker-4-234',
    # 'docker-4-235',
    # 'docker-4-236',
    # 'docker-4-237',
    # 'docker-4-238',
    # 'docker-4-239',
    # 'docker-4-240',
    # 'docker-4-241',
    # 'docker-4-242',
    # 'docker-4-243',
    # 'docker-4-244',
    # 'docker-4-245',
    # 'docker-4-246',
    # 'docker-4-247',
    # 'docker-4-248',
    # 'docker-4-249',
    # 'docker-4-251',
    # 'docker-4-252',
    # 'docker-4-253',
    # 'docker-4-254',
    # 'docker-5-6',
    # 'docker-5-7',
    # 'docker-5-8',
    # 'docker-5-9',
    # 'docker-5-10',
    # 'docker-5-11',
    # 'docker-5-12',
    # 'docker-5-13',
    # 'docker-5-14',
    # 'docker-5-15',
    # 'docker-5-16',
    # 'docker-5-17',
    # 'docker-5-18',
    # 'docker-5-19',
    # 'docker-5-20',
    # 'docker-5-21',
    # 'docker-5-22',
    # 'docker-5-23',
    # 'docker-5-24',
    # 'docker-5-25',
    # 'docker-5-26',
    # 'docker-5-27',
    # 'docker-5-28',
    # 'docker-5-29',
    # 'docker-5-30', # down
    # 'docker-5-31',
    # 'docker-5-32',
    # 'docker-5-33',
    # 'docker-5-34',
    # 'docker-5-35',
    # 'docker-5-36',
    # 'docker-5-37',
    # 'docker-5-38',
    # 'docker-5-39',
    # 'docker-5-40',
    # 'docker-5-41',
    # 'docker-5-42',
    # 'docker-5-43',
    # 'docker-5-44',
    # 'docker-5-45',
    # 'docker-5-46',
    # 'docker-5-47',
    # 'docker-5-48',
    # 'docker-5-49', # down
    # 'docker-5-50',
    # 'docker-5-51',
    # 'docker-5-52',
    # 'docker-5-53',
    # 'docker-5-54',
    # 'docker-5-55',
    # 'docker-5-56',
    # 'docker-5-57',
    # 'docker-5-58',
    # 'docker-5-59',
    # 'docker-5-60',
    # 'docker-5-61',
    # 'docker-5-62',
    # 'docker-5-63',
    # 'docker-5-64',
    # 'docker-5-65',
    'docker-5-66', # temp
    # 'docker-5-67',
    # 'docker-5-68',
    # 'docker-5-69',
    # 'docker-5-70',
    # 'docker-5-71',
    'docker-5-72', # temp
    'docker-5-73', # temp
    'docker-5-74', # temp
    # 'docker-5-75',
    'docker-5-76', # temp
    'docker-5-77', # temp
    'docker-5-78', # temp
    'docker-5-79', # temp
    # 'docker-5-80',
    # 'docker-5-81',
    # 'docker-5-82',
    'docker-5-83', # temp
    # 'docker-5-84',
    # 'docker-5-85',
    # 'docker-5-86',
    # 'docker-5-87',
    # 'docker-5-88',
    # 'docker-5-89',
    # 'docker-5-90',
    # 'docker-5-91',
    'docker-5-92',  # temp
    'docker-5-93', # temp
    'docker-5-94', # temp
    'docker-5-95', # down
    # 'docker-5-96',
    # 'docker-5-97',
    # 'docker-5-98',
    # 'docker-5-99',
    # 'docker-5-100',
    # 'docker-5-101',
    # 'docker-5-102',
    # 'docker-5-103',
    # 'docker-5-104',
    # 'docker-5-105',
    # 'docker-5-106',
    # 'docker-5-107',
    # 'docker-5-108',
    # 'docker-5-109',
    # 'docker-5-110',
    # 'docker-5-110',
    # 'docker-5-112',
    # 'docker-5-113',
    # 'docker-5-114',
    # 'docker-5-115',
    # 'docker-5-116',
    # 'docker-5-117',
    # 'docker-5-118',
    # 'docker-5-119',
    # 'docker-5-120',
    # 'docker-5-121',
    # 'docker-5-122',
    # 'docker-5-123',
    # 'docker-5-124',
    # 'docker-5-125',
    # 'docker-5-126',
    # 'docker-5-127',
    # 'docker-5-128',
    # 'docker-5-129',
    # 'docker-5-130',
    # 'docker-5-131', # down
    # 'docker-5-132',
    # 'docker-5-133',
    # 'docker-5-134',
    # 'docker-5-135',
    # 'docker-5-136',
    # 'docker-5-137',
    # 'docker-5-138',
    # 'docker-5-139',
    # 'docker-5-140',
    # 'docker-5-141',
    # 'docker-5-142',
    # 'docker-5-143',
    # 'docker-5-144',
    # 'docker-5-145',
    # 'docker-5-146',
    # 'docker-5-147',
    # 'docker-5-148',
    # 'docker-5-149',
    # 'docker-5-150',
    # 'docker-5-151',
    # 'docker-5-152',
    # 'docker-5-153', # down
    # 'docker-5-154',
    # 'docker-5-155',
    # 'docker-5-156',
    # 'docker-5-157',
    # 'docker-5-158',
    # 'docker-5-159',
    # 'docker-5-160',
    # 'docker-5-161',
    # 'docker-5-162',
    # 'docker-5-163',
    # 'docker-5-164',
    # 'docker-5-165',
    # 'docker-5-166',
    # 'docker-5-167',
    # 'docker-5-168',
    # 'docker-5-169',
    # 'docker-5-170',
    # 'docker-5-171',
    # 'docker-5-172',
    # 'docker-5-173',
    # 'docker-5-174',
    # 'docker-5-175', # down
    # 'docker-5-176',
    # 'docker-5-177',
    # 'docker-5-178',
    # 'docker-5-179',
    # 'docker-5-180',
    # 'docker-5-181',
    # 'docker-5-182',
    # 'docker-5-183',
    # 'docker-5-184',
    # 'docker-5-185',
    # 'docker-5-186',
    # 'docker-5-187',
    # 'docker-5-188',
    # 'docker-5-189',
    # 'docker-5-190',
    # 'docker-5-191',
    # 'docker-5-192',
    # 'docker-5-193',
    # 'docker-5-194', # down
    # 'docker-5-195',
    # 'docker-5-196',
    # 'docker-5-197',
    # 'docker-5-198',
    # 'docker-5-199',
    # 'docker-5-200',
    # 'docker-5-201',
    # 'docker-5-202',
    # 'docker-5-203',
    # 'docker-5-204',
    # 'docker-5-205',
    # 'docker-5-206',
    # 'docker-5-207',
    # 'docker-5-208',
    # 'docker-5-209',
    # 'docker-5-210',
    # 'docker-5-211',
    # 'docker-5-212',
    # 'docker-5-213',
    # 'docker-5-214',
    # 'docker-5-215',
    # 'docker-5-216',
    # 'docker-5-217',
    # 'docker-5-218',
    # 'docker-5-219',
    # 'docker-5-220', # down
    # 'docker-5-221',
    # 'docker-5-222',
    # 'docker-5-223',
    # 'docker-5-224',
    # 'docker-5-225',
    # 'docker-5-226',
    # 'docker-5-227',
    # 'docker-5-228',
    # 'docker-5-229',
    # 'docker-5-230',
    # 'docker-5-231',
    # 'docker-5-232',
    # 'docker-5-233',
    # 'docker-5-234',
    # 'docker-5-235',
    # 'docker-5-236',
    # 'docker-5-237', # down
    # 'docker-5-238',
    # 'docker-5-239',
    # 'docker-5-240', # down
    # 'docker-5-241',
    # 'docker-5-242',
    # 'docker-5-243',
    # 'docker-5-244',
    # 'docker-5-245',
    # 'docker-5-246',
    # 'docker-5-247',
    # 'docker-5-248',
    # 'docker-5-249',
    # 'docker-5-251',
    # 'docker-5-252',
    # 'docker-5-253',
    # 'docker-5-254'
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
    # 'docker4-int',
    # 'docker5-int',
    # 'docker6-int'
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
  # sudo('npm install n -g')
  # sudo('n 0.10.18')
  # sudo('npm install pm2 -g')
  sudo('rm -rf /home/ubuntu/tmp')
  with cd('docklet'):
    sudo('rm -rf node_modules')
    run('npm install')
    run('make')

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
  require('settings', provided_by=[production, integration])
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
  require('settings', provided_by=[production, integration])
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
  require('settings', provided_by=[production, integration])
  require('branch', provided_by=[stable, master, branch])
  clone_repo()
  pm2_restartAll()

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
