# Author::  Konstantin Pogrebnoy (<konstantin@codetiburon.com>)
# Cookbook Name:: magento_standalone
# Recipe:: nginx
#
# Copyright (C) 2015

php_appstack = node.default['php_appstack']

include_recipe 'chef-sugar'

# Pid is different on Ubuntu 14, causing nginx service to fail https://github.com/miketheman/nginx/issues/248
node.default['nginx']['pid'] = '/run/nginx.pid' if ubuntu_trusty?

# Create document_root if not exists
directory node.default['nginx']['default_root'] do
  owner node.default['nginx']['user']
  group node.default['nginx']['group']
  mode "0755"
  action :create
end

# Install Nginx
include_recipe 'nginx'

# Properly disable default vhost on Rhel (https://github.com/miketheman/nginx/pull/230/files)
# FIXME: should be removed once the PR has been merged
if !node.default['nginx']['default_site_enabled'] && platform_family?('rhel', 'fedora')
  %w(default.conf example_ssl.conf).each do |config|
    file "/etc/nginx/conf.d/#{config}" do
      action :delete
    end
  end
end

# Rackspace cookbook is much better than Opscode iptables
include_recipe 'rackspace_iptables'

listen_ports = []
# Create the sites.
node.default[php_appstack]['sites'].each do |site_name, site_opts|
  listen_ports |= [site_opts['http_port'], site_opts['https_port']]

  # Nginx set up
  template site_name do
    source site_opts['template']
    path "#{node['nginx']['dir']}/sites-available/#{site_name}.conf"
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      http_port: site_opts['http_port'],
      https_port: site_opts['https_port'],
      server_name: site_opts['server_name'],
      server_alias: site_opts['server_alias'],
      docroot: site_opts['docroot'],
      errorlog: site_opts['errorlog'],
      customlog: site_opts['customlog'],
      run_type: site_opts['run_type'],
      run_code: site_opts['run_code'],
      send_timeout: site_opts['send_timeout'],
      proxy_read_timeout: site_opts['proxy_read_timeout'],
      php_fpm_listen: node.default['php-fpm']['pools']['www']['listen']
    )
    notifies :reload, 'service[nginx]'
  end
  nginx_site "#{site_name}.conf" do
    enable true
    notifies :reload, 'service[nginx]'
  end
end

node.default['nginx']['listen_ports'] = listen_ports
# Allow access
listen_ports.each do |port|
  add_iptables_rule('INPUT', "-m tcp -p tcp --dport #{port} -j ACCEPT", 100, 'Allow access to nginx') unless port.nil? || port.empty?
end
