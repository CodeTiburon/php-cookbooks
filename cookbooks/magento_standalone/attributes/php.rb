# Author::  Konstantin Pogrebnoy (<konstantin@codetiburon.com>)
# Cookbook Name:: magento_standalone
# Attributes:: php
# Requires cookbook 'php', '~> 1.5.0'
# 
# Copyright (C) 2015

if node['platform_version'].to_f <= 14.04
  default['php']['ext_conf_dir']  = '/etc/php5/cli/conf.d'
else
  default['php']['ext_conf_dir']  = '/etc/php5/conf.d'
end

case node['platform_family'] 
when 'rhel'
  if node.['platform_version'].to_f == 2013.09 # amazon 2013.09 has php55 packages
    default['php']['packages'] = %w(
      php55
      php55-devel 
      php55-mcrypt
      php55-mbstring
      php55-gd
      php55-pear
      php55-pecl-memcache
      php55-gmp
      php55-mysqlnd
      php55-pdo
      php55-xml
      )
  else
    default['php']['packages'] = %w(
      php55u
      php55u-devel
      php55u-mcrypt
      php55u-mbstring
      php55u-gd
      php55u-pear
      php55u-pecl-memcache
      php55u-gmp
      php55u-mysqlnd
      php55u-xml )
  end
  default['php']['ext_conf_dir']  = '/etc/php.d'
when 'debian'
  # the php5-common, php5-cgi, php5 ordering is needed to not install apache
  default['php']['packages'] = %w(
    php5-common
    php5-cgi
    php5
    php5-dev
    php5-mcrypt
    php5-gd
    php5-gmp
    php5-mysqlnd
    php5-curl
    php-pear )
end