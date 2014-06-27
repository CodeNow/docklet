name             'runnable_docklet'
maintainer       'Runnable.com'
maintainer_email 'ben@runnable.com'
license          'All rights reserved'
description      'Runnable.com docklet cookbook'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.1'

supports 'ubuntu'

%w{
  hostsfile
  runnable_nodejs
  }.each do |cb|
  depends cb
end

recipe "runnable_docklet::default", "Installs and configures docklet"