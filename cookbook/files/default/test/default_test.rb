require 'minitest/spec'

describe_recipe 'runnable_docklet::default' do

  include MiniTest::Chef::Assertions
  include Minitest::Chef::Context
  include Minitest::Chef::Resources
  include Chef::Mixin::ShellOut

  it 'creates a hostsfile entry for registry' do
    file('/etc/hosts').must_match /^#{node['runnable_docklet']['registry']}\s*registry.runnable.com$/
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

  it 'listens on port 4243' do
    assert shell_out('lsof -n -i :4243').exitstatus == 0
  end

end
