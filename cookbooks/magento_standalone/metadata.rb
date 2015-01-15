name             'magento_standalone'
maintainer       'CodeTiburon LLC'
maintainer_email 'contact@codetiburon.com'
license          'Proprietary - All Rights Reserved'
description      'Installs and configures magento CE.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
supports         'ubuntu', ">= 12.04"
supports         'centos', ">= 6.4"
supports         'amazon', ">= 2013.09"
version          '0.1.0'

depends 'apt', '~> 2.6.1'
depends 'yum', '~> 3.5.2'
depends 'unattended-upgrades', '~> 0.1.2'
depends 'build-essential', '~> 2.1.3'
depends 'fail2ban', '~> 2.2.1'
depends 'git', '~> 4.0.2'
depends 'hostsfile', '~> 2.4.5'
depends 'logrotate', '~> 1.7.0'
depends 'ntp', '~> 1.6.2'
depends 'vim', '~> 1.1.2'
depends 'chef-sugar'
depends 'openssl'

depends 'nginx', '~> 2.7.4'
depends 'apache2', '~> 3.0.0'
depends 'rackspace_iptables', '~> 1.7.2'
depends 'php', '~> 1.5.0'
depends 'php-fpm', '~> 0.7.0'
