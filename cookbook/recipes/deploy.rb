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
  notifies :create, 'file[docklet_config]', :immediately
  notifies :create, 'template[/etc/init/docklet.conf]', :immediately
  notifies :create, 'template[/etc/init/bouncer.conf]', :immediately
  notifies :create, 'template[/etc/init/containerGauge.conf]', :immediately
  notifies :run, 'execute[npm install]', :delayed
end

file 'docklet_config' do
  path "#{node['runnable_docklet']['deploy_path']}/current/configs/#{node.chef_environment}.json"
  content JSON.pretty_generate node['runnable_docklet']['config']
  action :nothing
end

template '/etc/init/docklet.conf' do
  source 'upstart.conf.erb'
  variables({
    :name     => 'docklet',
    :deploy_path  => "#{node['runnable_docklet']['deploy_path']}/current",
    :log_file   => '/var/log/docklet.log',
    :node_env     => node.chef_environment
  })
  action :create
  notifies :restart, 'service[docklet]', :delayed
end

template '/etc/init/bouncer.conf' do
  source 'upstart.conf.erb'
  variables({
    :name     => 'bouncer',
    :deploy_path  => "#{node['runnable_docklet']['deploy_path']}/current",
    :log_file   => '/var/log/bouncer.log',
    :start_command => 'npm run bouncer',
    :node_env     => node.chef_environment
  })
  action :create
  notifies :restart, 'service[bouncer]', :delayed
end

template '/etc/init/containerGauge.conf' do
  source 'upstart.conf.erb'
  variables({
    :name     => 'containerGauge',
    :deploy_path  => "#{node['runnable_docklet']['deploy_path']}/current",
    :log_file   => '/var/log/containerGauge.log',
    :start_command => 'npm run containerGauge',
    :node_env     => node.chef_environment
  })
  action :create
  notifies :restart, 'service[containerGauge]', :delayed
end

execute 'npm install' do
  cwd "#{node['runnable_docklet']['deploy_path']}/current"
  action :nothing
  notifies :restart, 'service[docklet]', :immediately
  notifies :restart, 'service[bouncer]', :immediately
  notifies :restart, 'service[containerGauge]', :immediately
end


%w{docklet bouncer containerGauge}.each do |s|
  service s do
    provider Chef::Provider::Service::Upstart
    action :nothing
  end
end
