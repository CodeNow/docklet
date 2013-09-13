#TODO: Turn this into a fab file

def install_docker:
  sudo('apt-get install -y linux-image-extra-`uname -r` curl')
  sudo('curl https://get.docker.io/ubuntu/info | sh -x')

def install_gvm:
  sudo('apt-get install -y git mercurial bison')
  run('bash < <(curl -s https://raw.github.com/moovweb/gvm/master/binscripts/gvm-installer)')

def install_go:
  install_gvm()
  run('gvm install go1.1.2')

def install_etcd:
  install_go()
  sudo('apt-get install -y git')
  run('git clone https://github.com/coreos/etcd')
  with cd('etcd'):
    run('git checkout v0.1.1')
    with prefix('gvm use go1.1.2')
      run('./build')

def start_etcd:
  run('killall etcd')
  with cd('etcd'):
    run('nohup ./etcd -s {LOCAL_IP}:7001 -c {LOCAL_IP}:4001 -C 10.0.1.226:7001 -d nodes/node1 -n docklet{DOCKLET_INDEX}')

def install_node:
  sudo('apt-get update')
  sudo('apt-get install -y python-software-properties python g++ make')
  sudo('sudo add-apt-repository ppa:chris-lea/node.js')
  sudo('apt-get update')
  sudo('apt-get install nodejs')
  sudo('npm install pm2 -g')

def install_docklet:
  run('git clone https://github.com/CodeNow/docklet')


######################### BASE IMAGE ENDS HERE ##############################

git clone https://github.com/CodeNow/docklet
<github credentials? should we install ssh keys somehow? make docklet public?>
cd docklet
npm install
make
tmux new -s docklet
node ./lib/index.js {DOCKLET_INDEX} {DOCKLET_HOST}

sudo sh -c 'echo "54.241.154.140 registry.runnable.com" >> /etc/hosts'
sudo /etc/init.d/dns-clean start