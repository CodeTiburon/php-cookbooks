# Author::  Konstantin Pogrebnoy (<konstantin@codetiburon.com>)
# Cookbook Name:: magento_standalone
# Recipe:: magento
#
# Copyright (C) 2015

php_appstack = node.default['php_appstack']

node.default[php_appstack]['sites'].each do |site_name, site_opts|
  application "#{site_name}" do
        path site_opts['docroot']
        owner node[node[php_appstack]['webserver']]['user']
        group node[node[php_appstack]['webserver']]['group']
        deploy_key site_opts['deploy_key']
        repository site_opts['repository']
        revision site_opts['revision']

        symlink_before_migrate       nil
        create_dirs_before_symlink   []
        purge_before_symlink         []
        symlinks                     nil

        # run the deployment script only if it's defined
        # if node.deep_fetch(php_appstack, node[php_appstack]['webserver'], site_name, 'deployment', 'before_symlink_script_name')
        #   before_migrate do
        #     # create a deployment script if it's defined
        #     template "before symlink deployment script for #{site_name}" do
        #       path "#{release_path}/#{site_opts['deployment']['before_symlink_script_name']}"
        #       cookbook site_opts['deployment']['before_symlink_script_cookbook']
        #       source site_opts['deployment']['before_symlink_script_template']
        #       owner node[node[php_appstack]['webserver']]['user']
        #       group node[node[php_appstack]['webserver']]['group']
        #       mode '0744'
        #       variables(
        #         site_opts: site_opts,
        #         templates_options: site_opts['deployment']['template_options']
        #       )
        #     end
        #   end
        #   before_symlink site_opts['deployment']['before_symlink_script_name']
        # end
        # add in all of the other application resource attributes that aren't being defined
        # %w(packages keep_releases strategy scm_provider rollback_on_error environment purge_before_symlink
        #    create_dirs_before_symlink symlinks symlink_before_migrate migrate migration_command restart_command
        #    environment_name enable_submodules).each do |method_name|
        #   send(method_name, site_opts[method_name]) if site_opts.include?(method_name)
        # end
  end
end