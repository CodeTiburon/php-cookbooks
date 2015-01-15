# Author::  Konstantin Pogrebnoy (<konstantin@codetiburon.com>)
# Cookbook Name:: magento_standalone
# Attributes:: default
# Requires cookbook  'nginx', '~> 2.7.4'
#
# Copyright (C) 2015

php_appstack = 'magento';

default[php_appstack]['version'] = '1.9.0.1'
default[php_appstack]['url'] = 'http://www.magentocommerce.com/downloads/assets/1.9.0.1/magento-1.9.0.1.tar.gz'
default[php_appstack]['repository'] = 'https://github.com/codetiburon/magento'
default[php_appstack]['deploy_key'] =  '/root/.ssh/id_rsa'
default[php_appstack]['installation_sources'] = 'repository' # repository, composer
default[php_appstack]['sample_data_url'] = ''


default[php_appstack]['webserver'] = 'nginx' # or apache

log_dir = node[default[php_appstack]['webserver']]['log_dir']
site1 = 'magentostore'

default[php_appstack]['sites'][site1] = 
  {
	:template     => "#{default[php_appstack]['webserver']}/sites/#{site1}.erb"
	:cookbook     => 'magento_standalone'
	:server_name  => node['fqdn']
	:server_alias => ["test.#{node['fqdn']}", "www.#{node['fqdn']}"]
	:http_port	  => '80'
	:https_port	  => '443' # set nil if you do not need to set up secure connection
	:docroot      => "/var/www/#{site1}"
	:errorlog     => "#{log_dir}/#{site1}-error.log info"
	:customlog    => "#{log_dir}/#{site1}-access.log combined"
	:server_admin => 'admin@codetiburon.com'
	:revision     => "v#{default[php_appstack]['version']}"
	:repository   => default[php_appstack]['repository']
	:deploy_key   => default[php_appstack]['deploy_key']
	:run_type	  => 'store'
	:run_code 	  => 'default'
	:session      => { save: 'file' }
  }

=begin

default['php-fpm']['pools'] = [
  {
    name: 'magento',
    listen: '127.0.0.1:9001',
    allowed_clients: ['127.0.0.1'],
    user: node[:magento][:user],
    group: node[node[:magento][:webserver]][:group],
    process_manager: 'dynamic',
    max_children: 50,
    start_servers: 5,
    min_spare_servers: 5,
    max_spare_servers: 35,
    max_requests: 500
  }
]


default[php_appstack]['mysql']['databases'] = {}
default[php_appstack]['varnish']['backend_nodes'] = {}
default[php_appstack]['webserver_deployment']['enabled'] = true
default[php_appstack]['app_deployment']['enabled'] = true
default[php_appstack]['varnish']['multi'] = true

=end






