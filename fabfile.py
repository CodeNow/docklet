#TODO: Turn this into a fab file

def install_docker:
  sudo('apt-get install -y linux-image-extra-`uname -r` curl')
  sudo('curl https://get.docker.io/ubuntu/info | sh -x')

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
node ./lib/index.js

sudo sh -c 'echo "54.241.154.140 registry.runnable.com" >> /etc/hosts'
sudo /etc/init.d/dns-clean start