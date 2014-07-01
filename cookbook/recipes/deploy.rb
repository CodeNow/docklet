#
# Cookbook Name:: runnable_docklet
# Recipe:: deploy
#
# Copyright 2014, Runnable.com
#
# All rights reserved - Do Not Redistribute
#

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
end

file 'docklet_config' do
  path "#{node['runnable_docklet']['deploy_path']}/current/configs/#{node.chef_environment}.json"
  content JSON.pretty_generate node['runnable_docklet']['config']
  action :nothing
  notifies :run, 'execute[npm install]', :immediately
end

template '/etc/init/docklet.conf' do
  source 'docklet.conf.erb'
  variables({
    :name     => 'docklet',
    :deploy_path  => "#{node['runnable_docklet']['deploy_path']}/current",
    :log_file   => '/var/log/docklet.log',
    :node_env     => node.chef_environment
  })
  action :create
  notifies :restart, 'service[docklet]', :delayed
  notifies :run, 'execute[npm install]', :immediately
end

execute 'npm install' do
  cwd "#{node['runnable_docklet']['deploy_path']}/current"
  action :nothing
  notifies :restart, 'service[docklet]', :immediately
  notifies :restart, 'service[bouncer]', :immediately
  notifies :restart, 'service[containerGauge]', :immediately
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