# Author::  Konstantin Pogrebnoy (<konstantin@codetiburon.com>)
# Cookbook Name:: magento_standalone
# Attributes:: default
# Requires cookbook  'mysql', 'mysql_tunning'
#
# Copyright (C) 2015


if platform_family?('rhel')
  default['mysql']['version'] = '5.7'
elsif platform_family?('debian')
    
  default['mysql']['version'] = '5.5'

  if node['platform_version'].to_i == 14
    default['mysql']['version'] = '5.6'
  elsif node['platform_version'].to_i == 10
      default['mysql']['version'] = '5.1'
  end
end

default['mysql_tuning']['system_percentage'] = 50
