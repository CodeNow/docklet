require 'minitest/spec'

describe_recipe 'runnable_docklet::default' do

  include MiniTest::Chef::Assertions
  include Minitest::Chef::Context
  include Minitest::Chef::Resources
  include Chef::Mixin::ShellOut

  it 'creates a hostsfile entry for registry' do
    unless node['runnable_docklet']['registry'].nil?
      file('/etc/hosts').must_match /^#{node['runnable_docklet']['registry']}\s*registry.runnable.com$/
    end
  end

  it 'installs nodejs v0.10.22' do
    node_version = shell_out('node --version')
    assert_equal("v0.10.22\n", node_version.stdout, "Incorrect node version present: #{node_version.stdout}")
  end

  it 'installs pm2@0.7.7' do
    assert shell_out('npm list -g pm2').exitstatus == 0
  end

  it 'creates github ssh deploy key files' do
    file('/root/.ssh/runnable_docklet').must_exist
    file('/root/.ssh/runnable_docklet.pub').must_exist
  end

  it 'generates json configuration' do
    node['runnable_docklet']['config'].each do |k,v|
      file("#{node['runnable_docklet']['deploy_path']}/current/configs/#{node.chef_environment}.json").must_include k
    end
  end

  it 'starts the docklet service' do
    r = Chef::Resource::Service.new("docklet", @run_context)
    r.provider Chef::Provider::Service::Upstart
    current_resource = r.provider_for_action(:start).load_current_resource
    current_resource.running.must_equal true
  end

  it 'starts the bouncer service' do
    r = Chef::Resource::Service.new("bouncer", @run_context)
    r.provider Chef::Provider::Service::Upstart
    current_resource = r.provider_for_action(:start).load_current_resource
    current_resource.running.must_equal true
  end

  it 'starts the containerGauge service' do
    r = Chef::Resource::Service.new("containerGauge", @run_context)
    r.provider Chef::Provider::Service::Upstart
    current_resource = r.provider_for_action(:start).load_current_resource
    current_resource.running.must_equal true
  end

  it 'listens on port 4243' do
    assert shell_out('lsof -n -i :4243').exitstatus == 0
  end

end
