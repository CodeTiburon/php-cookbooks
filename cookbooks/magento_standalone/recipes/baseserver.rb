# Author::  Konstantin Pogrebnoy (<konstantin@codetiburon.com>)
# Cookbook Name:: magento_standalone
# Recipe:: basserver
#
# Copyright (C) 2015
#
# Base server setup
# - Ubuntu >=12.04
# - CentOS >=6.4

# start packages

if platform_family?("debian") # debian, linux mint, ubuntu
  include_recipe 'apt'
  include_recipe 'unattended-upgrades'
end

if platform_family?("rhel") # Amazon Linux, CentOS, Oracle Linux, Scientific Linux, Red Hat Enterprise Linux
	include_recipe 'yum'
end

include_recipe 'build-essential'

include_recipe 'vim'

include_recipe 'ntp'

include_recipe 'git'

include_recipe 'logrotate'

include_recipe 'fail2ban'

