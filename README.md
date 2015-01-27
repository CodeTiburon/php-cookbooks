php-coookbooks
===============

Overview
-------------------

*Chef* is a systems and cloud infrastructure automation framework that makes it easy to deploy servers and applications to any physical, virtual, or cloud location, no matter the size of the infrastructure. Each organization is comprised of one (or more) workstations, a single server, and every node that will be configured and maintained by the chef-client. Cookbooks (and recipes) are used to tell the chef-client how each node in your organization should be configured. The chef-client (which is installed on every node) does the actual configuration.

[What is Chef](https://www.chef.io/chef/)

This repository is a place where cookbooks, roles, environments, data bags, and chef-repo configuration files are stored and managed.

Introduction
-------------------

Exists two types of Chef: Chef Solo and Chef Server. In order to just configure single server you need to use Chef Solo.

This is list of terminology, which is used in this doc:

 - *Node* - A host where the Chef client will run (web server, database server or another server). Chef Client always working on server, which it configure. [Read more](http://docs.chef.io/nodes.html)
 - *Chef Client* - a command line tool that configures servers.
 - *Chef Solo* - a version of the chef-client that allows using cookbooks with nodes without requiring access to a Chef server.
 - *Berkshelf* - a tool to manage a cpplication's cookbook dependencies.
 - *Recipes* - a single file of Ruby code that contains description of a node configuration (nginx ssl module, apache php module).
 - *Cookbook* - a collection of Chef recipes (nginx cookbook, php cookbook).
 - *Run list* - an ordered list of roles and/or recipes that are run in an exact order on node.
 - *Role* - reusable configuration for multiple nodes (web role, database role, etc). [Read more](http://docs.chef.io/client/roles.html)
 - *Resources* - a node's resources include files, directories, users and services.
 - *Attribute* - variables that are passed through Chef and used in recipes and templates (the version number of nginx to install).
 - *Template* - a file with placeholders for attributes, used to create configuration files (simple Erb file).


## Chef Solo

[Read more about Chef Solo](https://docs.chef.io/chef_solo.html)


Server configuration with Chef Solo 
-------------------

## Pre-installation steps

First of all you need to update package manager on server and install Git.

For Ubuntu:

```
# sudo apt-get update
# sudo apt-get install git
```

For CentOS, Amazon, Red Hat:

```
# sudo yum install git
```

## Installation of Chef Client

 - Type this command to download and run the client installation script from the Chef website:

  ```
  # curl -L https://www.opscode.com/chef/install.sh | sudo bash
  ```
 - Confirm Chef has successfully installed.

 ```
 # sudo chef-solo -v
 ...
 Chef: 12.0.3
 ```
 Of course, your version number may be different.

 - Chef will be installed to /opt/chef/. Chef bundled with different tools such as ruby, Berkshelf, knife, etc. In order to use it you should add `/opt/chef/embedded/bin` to PATH.

 ```
 echo 'export PATH="/opt/chef/embedded/bin:$PATH"' >> ~/.bash_profile && source ~/.bash_profile
 ```
 - Confirm that the Chef's gem and ruby are used by default
 ```
 # which gem
 /opt/chef/embedded/bin/gem
 ```
 - Our cookbooks depend on opensource cookbooks which are written by Chef and community. Berkshelf can resolve all dependencies and download cookbooks to local server. That's why it's necessary to install Berkshelf first.
 ```
 gem install berkshelf
 ```

## Downloading cookbooks

It's simple.

```
# cd ~
# git clone https://github.com/CodeTiburon/php-cookbooks/
```

Also, you can upload archive to server from your local computer.

We downloaded all cookbooks from git repo to target server but since chef solo runs locally and requires that a cookbook (and any of its dependencies) be on the same physical disk as the node we need to resolve and download all dependencies.
```
# cd php-cookbooks/cookbooks/magento_standalone
# berks install
```
Berkshelf stores every version of a cookbook that you have ever installed into `~/.berkshelf/cookbooks/`

## Run recipes to cook a server

```
chef-solo -c solo.rb -j nodes/magento.json
```

If you need to use only specific recipes you can edit `nodes/magento.json`
