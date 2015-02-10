# Author::  Konstantin Pogrebnoy (<konstantin@codetiburon.com>)
# Cookbook Name:: magento_standalone
# Recipe:: default
#
# Copyright (C) 2015

# Set up server
include_recipe "#{cookbook_name}::baseserver"

# Set up MySQL
include_recipe "#{cookbook_name}::mysql-base"

# Set up php & php-fpm
include_recipe 'php'
include_recipe 'php::ini'

# Set up webserver
include_recipe "#{cookbook_name}::nginx"

# Deploy magento
include_recipe "#{cookbook_name}::install"