#
# Cookbook Name:: runnable_docklet
# Recipe:: default
#
# Copyright 2014, Runnable.com
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'runnable_docklet::dependencies'
include_recipe 'runnable_docklet::deploy_ssh'
include_recipe 'runnable_docklet::deploy'