#
# Cookbook Name:: runnable_docklet
# Recipe:: dependencies
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