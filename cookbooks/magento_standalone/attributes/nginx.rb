# Author::  Konstantin Pogrebnoy (<konstantin@codetiburon.com>)
# Cookbook Name:: magento_standalone
# Attributes:: nginx
#
# Copyright (C) 2015

# Disable default website
default['nginx']['default_site_enabled'] = false

# needs setting because by default it is set to runit
if platform?('ubuntu')
  set['nginx']['init_style'] = 'upstart'
end

default['nginx']['listen_ports'] = %w(80)

default['nginx']['default_root'] = '/var/www'