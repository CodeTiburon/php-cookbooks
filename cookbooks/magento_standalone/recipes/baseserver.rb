# Author::  Konstantin Pogrebnoy (<konstantin@codetiburon.com>)
# Cookbook Name:: magento_standalone
# Recipe:: basserver
#
# Copyright (C) 2015
#
# Base server setup

if platform_family?('debian')
  include_recipe 'apt'
  include_recipe 'unattended-upgrades'
end

if platform_family?('rhel')
  include_recipe 'yum'
  include_recipe 'yum-epel'
  include_recipe 'yum-ius'
end

include_recipe 'build-essential'
include_recipe 'vim'
include_recipe 'ntp'
include_recipe 'git'
include_recipe 'logrotate'
include_recipe 'fail2ban'
