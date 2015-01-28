# Author::  Konstantin Pogrebnoy (<konstantin@codetiburon.com>)
# Cookbook Name:: magento_standalone
# Recipe:: mysql
#
# Copyright (C) 2015

$php_appstack = node.default['php_appstack']

# Include the #secure_password method from the openssl cookbook
Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

# Install Encrypted Attributes gem
include_recipe 'encrypted_attributes'

# Include the Encrypted Attributes cookbook helpers
Chef::Recipe.send(:include, Chef::EncryptedAttributesHelpers)

# We can use an attribute to enable or disable encryption (recommended for tests)
# self.encrypted_attributes_enabled = node[$php_appstack]['encrypt_attributes']

# Encrypted Attributes will be generated randomly and saved in in the
# node[$php_appstack]['mysql'] attribute encrypted.
def generate_mysql_password(user)
  key = "server_#{user}_password"
  encrypted_attribute_write([$php_appstack, 'mysql', key]) { secure_password }
end

# Generate the encrypted passwords
mysql_root_password = generate_mysql_password('root')

# Set MySQL service resource name
service_name = 'default'

# Install MySQL server
mysql_service service_name do
  mysql_user 'root'
  port '3306'
  bind_address '127.0.0.1'
  version '5.7'
  mysql_password mysql_root_password
  action [:create, :start]
end

# Pass the root credentials to the mysql_tuning resource
mysql_tuning service_name do
  mysql_user 'root'
  mysql_password mysql_root_password
end

# Install MySQL client
mysql_client 'default' do
  action :create
end
