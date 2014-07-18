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
  before_migrate do
    file 'docklet_config' do
      path "#{node['runnable_docklet']['deploy_path']}/current/configs/#{node.chef_environment}.json"
      content JSON.pretty_generate node['runnable_docklet']['config']
      action :create
    end
    
    execute 'npm install' do
      cwd "#{release_path}"
      action :run
    end
  end
  before_restart do
    template '/etc/init/docklet.conf' do
      source 'upstart.conf.erb'
      variables({
        :name     => 'docklet',
        :deploy_path  => "#{release_path}",
        :log_file   => '/var/log/docklet.log',
        :node_env     => node.chef_environment
      })
      action :create
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
    end
  end
  restart_command do
    %w{docklet bouncer containerGauge}.each do |s|
      service s do
        provider Chef::Provider::Service::Upstart
        action [:start, :enable]
      end
    end
  end
  create_dirs_before_symlink []
  purge_before_symlink []
  symlink_before_migrate({})
  symlinks({})
  rollback_on_error true
  action :deploy
end
