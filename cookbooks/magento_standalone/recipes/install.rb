# Author::  Konstantin Pogrebnoy (<konstantin@codetiburon.com>)
# Cookbook Name:: magento_standalone
# Recipe:: install
#
# Copyright (C) 2015

require 'time'

php_appstack = node.default['php_appstack']

mysql_connection_info = {'host': "127.0.0.1",
                       'username': 'root',
                       'password': node['mysql']['server_root_password']}

node.default[php_appstack]['sites'].each do |site_name, site_opts|
  unless File.exist?(File.join(site_opts['docroot'], '.installed'))
    inst_date = Time.new.rfc2822
    app_user = node[node[php_appstack]['webserver']]['user']
    app_group = node[node[php_appstack]['webserver']]['group'] 

    # Fetch magento release
    if site_opts['source'] == 'archive' 
      remote_file "#{Chef::Config['file_cache_path']}/magento.tar.gz" do
        source site_opts['url']
        mode 0644
        notifies :run, 'execute[untar-magento]', :immediately
      end
      execute 'untar-magento' do
        cwd site_opts['docroot']
        command <<-EOH
        tar --strip-components 1 -xzf \
        #{Chef::Config['file_cache_path']}/magento.tar.gz
        EOH
        notifies :run, 'bash[permissions]', :immediately
        action :nothing        
      end      
    elsif site_opts['source'] == 'git'
      git site_opts['docroot'] do
        repository site_opts['url']
        revision site_opts['revision']
        user app_user
        group app_group
        action :sync        
      end
    end

    bash 'permissions' do
      cwd site_opts['docroot']
      code <<-EOH
      chown -R #{app_user}:#{app_group} #{site_opts['docroot']}
      chmod -R o+w media
      chmod -R o+w var
      EOH
      action :run
    end

    site_opts['databases'].each do |db_name, db_opts|
      # Create a mysql database
      mysql_database db_name do
        connection mysql_connection_info
        action :create
      end
      # Create a mysql user
      mysql_database_user 'disenfranchised' do
       connection mysql_connection_info
       password   db_opts['pass']
       action     :create
      end
      # Grant all privileges on all tables in foo db
      mysql_database_user db_opts['user'] do
       connection    mysql_connection_info
       database_name db_name
       privileges    [:all]
       action        :grant
      end
    end
   
    bash 'installed' do
      cwd site_opts['docroot']
      code <<-EOH
      echo '#{inst_date}' > #{site_opts['docroot']}/.installed
      EOH
      action :run
    end
  end  
end


  # # Generate local.xml file
  # if enc_key
  #   template File.join(node[:magento][:dir], 'app', 'etc', 'local.xml') do
  #     source 'local.xml.erb'
  #     mode 0600
  #     owner node[:magento][:user]
  #     variables(
  #       db_config: db_config,
  #       enc_key: enc_key,
  #       session: node[:magento][:session],
  #       inst_date: inst_date
  #     )
  #   end
  # end

  