#
# Cookbook Name:: runnable_docklet
# Recipe:: default
#
# Copyright 2014, Runnable.com
#
# All rights reserved - Do Not Redistribute
#

package 'git'

node.set['runnable_nodejs']['version'] = '0.10.22'
include_recipe 'runnable_nodejs'

hostsfile_entry node['runnable_docklet']['registry'] do
	hostname 'registry.runnable.com'
	action :create
	unique true
end

execute 'npm install pm2@0.7.7 -g' do
  action :run
  not_if 'npm list -g pm2'
end

file '/tmp/git_sshwrapper.sh' do
  content "#!/usr/bin/env bash\n/usr/bin/env ssh -o 'StrictHostKeyChecking=no' -i '/root/.ssh/runnable_docklet-id_rsa' $1 $2\n"
  owner 'root'
  group 'root'
  mode 0755
  action :create
end

directory '/root/.ssh' do
  owner 'root'
  group 'root'
  mode 0700
  action :create
  notifies :create, 'cookbook_file[/root/.ssh/runnable_docklet-id_rsa]', :immediately
  notifies :create, 'cookbook_file[/root/.ssh/runnable_docklet-id_rsa.pub]', :immediately
end

cookbook_file '/root/.ssh/runnable_docklet-id_rsa' do
  source 'runnable_docklet-id_rsa'
  owner 'root'
  group 'root'
  mode 0600
  action :create
  notifies :deploy, "deploy[#{node['runnable_docklet']['deploy_path']}]", :delayed
  notifies :create, 'cookbook_file[/root/.ssh/runnable_docklet-id_rsa.pub]', :immediately
end

cookbook_file '/root/.ssh/runnable_docklet-id_rsa.pub' do
  source 'runnable_docklet-id_rsa.pub'
  owner 'root'
  group 'root'
  mode 0600
  action :create
  notifies :deploy, "deploy[#{node['runnable_docklet']['deploy_path']}]", :delayed
end

deploy node['runnable_docklet']['deploy_path'] do
  repo 'git@github.com:CodeNow/docklet.git'
  git_ssh_wrapper '/tmp/git_sshwrapper.sh'
  branch 'master'
  deploy_to node['runnable_docklet']['deploy_path']
  migrate false
  create_dirs_before_symlink []
  purge_before_symlink []
  symlink_before_migrate({})
  symlinks({})
  action :deploy
  notifies :run, 'execute[npm install]', :immediately
  notifies :restart, 'service[docklet]', :delayed
  notifies :restart, 'service[bouncer]', :delayed
  notifies :restart, 'service[containerGauge]', :delayed
end

file 'docklet_config' do
  path "#{node['runnable_docklet']['deploy']['deploy_path']}/current/configs/#{node.chef_environment}.json"
  content JSON.pretty_generate node['runnable_docklet']['config']
  action :nothing
  notifies :run, 'execute[npm install]', :immediately
  notifies :restart, 'service[docklet]', :delayed 
end

execute 'npm install' do
  cwd "#{node['runnable_docklet']['deploy_path']}/current"
  action :nothing
  notifies :restart, 'service[docklet]', :delayed
end

service 'docklet' do
  action :start
  stop_command 'pm2 stop docklet'
  start_command "bash -c 'NODE_ENV=#{node.chef_environment} pm2 start #{node['runnable_docklet']['deploy_path']}/current/lib/index.js -n docklet'"
  status_command 'pm2 status | grep docklet | grep online'
  restart_command 'pm2 restart docklet'
  supports :start => true, :stop => true, :status => true, :restart => true
end

service 'bouncer' do
	action :start
	stop_command 'pm2 stop bouncer'
	start_command "bash -c 'NODE_ENV=#{node.chef_environment} pm2 start #{node['runnable_docklet']['deploy_path']}/current/bouncer/index.js -n bouncer -i 10'"
	status_command 'pm2 status | grep bouncer | grep online'
	restart_command 'pm2 restart bouncer'
	supports :start => true, :stop => true, :status => true, :restart => true
end

service 'containerGauge' do
	action :start
	stop_command 'pm2 stop containerGauge'
	start_command "bash -c 'NODE_ENV=#{node.chef_environment} pm2 start #{node['runnable_docklet']['deploy_path']}/current/containerGauge/index.js -n containerGauge'"
	status_command 'pm2 status | grep containerGauge | grep online'
	restart_command 'pm2 restart containerGauge'
	supports :start => true, :stop => true, :status => true, :restart => true
end