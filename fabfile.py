TODO: Turn this into a fab file

def prep_for_docker:
  

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
  sudo('apt-get install -y git')
  run('git clone https://github.com/coreos/etcd')
  with cd('etcd'):
    run('git checkout v0.1.1')
    run('gvm use go1.1.2 && ./build')

def start_etcd:
  run('killall etcd')
  run('cd etcd && nohup ./etcd -s {LOCAL_IP}:7001 -c {LOCAL_IP}:4001 -C 10.0.1.226:7001 -d nodes/node1 -n docklet{DOCKLET_INDEX}')

def install_node:
  sudo('apt-get update')
  sudo('apt-get install -y python-software-properties python g++ make')
  sudo('sudo add-apt-repository ppa:chris-lea/node.js')
  sudo('apt-get update')
  sudo('apt-get install nodejs')

wget https://go.googlecode.com/files/go1.1.2.linux-amd64.tar.gz
tar -xvf go1.1.2.linux-amd64.tar.gz
echo "export GOROOT=\$HOME/go" >> ~/.bash_profile
echo "export PATH=\$PATH:\$GOROOT/bin" >> ~/.bash_profile
source ~/.bash_profile
sudo apt-get update
sudo apt-get install -y git
git clone https://github.com/coreos/etcd
cd etcd
git checkout v0.1.1
./build
tmux new -s etcd
./etcd -s {LOCAL_IP}:7001 -c {LOCAL_IP}:4001 -C 10.0.1.226:7001 -d nodes/node1 -n docklet{DOCKLET_INDEX}
<escape tmux> (ctrl-b)
sudo apt-get install -y linux-image-extra-`uname -r`
sudo sh -c "curl http://get.docker.io/gpg | apt-key add -"
sudo sh -c "echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list"
sudo apt-get update
sudo apt-get install -y lxc-docker
sudo apt-get install -y build-essential
wget http://nodejs.org/dist/v0.10.18/node-v0.10.18.tar.gz
tar -xvf node-v0.10.18.tar.gz
cd node-v0.10.18
./configure
make
sudo make install

######################### BASE IMAGE ENDS HERE ##############################

git clone https://github.com/CodeNow/docklet
<github credentials? should we install ssh keys somehow? make docklet public?>
cd docklet
npm install
make
tmux new -s docklet
node ./lib/index.js {DOCKLET_INDEX} {DOCKLET_HOST}
git clone https://github.com/Runnable/dockworker
cd ../dockworker
npm install
make
rm -rf node_modules
docker -H {LOCAL_IP}:4243 run -v /home/ubuntu/dockworker/:/dockworker runnable/node /bin/bash -c "cd dockworker && npm install"
sudo sh -c 'echo "54.241.154.140 registry.runnable.com" >> /etc/hosts'
sudo /etc/init.d/dns-clean start