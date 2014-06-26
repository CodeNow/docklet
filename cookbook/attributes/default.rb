default['runnable_docklet']['deploy_path'] = '/opt/docklet'
default['runnable_docklet']['registry'] = case node.chef_environment
	when 'integration'
		'54.215.162.19'
	when 'staging'
		'54.241.167.140'
	when 'production'
		'10.0.0.60'
	end

