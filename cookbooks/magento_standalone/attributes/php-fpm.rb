# Author::  Konstantin Pogrebnoy (<konstantin@codetiburon.com>)
# Cookbook Name:: magento_standalone
# Attributes:: php-fpm
# Requires cookbook 'php-fpm', '~> 0.7.0'
#
# Copyright (C) 2015

if platform_family?('rhel')
  default['php-fpm']['package_name'] = value_for_platform(
    'amazon'  => { '>= 2013.09' => 'php55-fpm' },
    'default' => 'php55u-fpm'
  )
  default['php-fpm']['service_name'] = 'php-fpm'
end
