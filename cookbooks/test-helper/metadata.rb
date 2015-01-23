name 'test-helper'
maintainer 'CodeTiburon LLC'
maintainer_email 'contact@codetiburon.com'
license 'Proprietary - All Rights Reserved'
description 'Dumps chef node data to json file'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
supports 'ubuntu', '>= 12.04'
supports 'centos', '>= 6.4'
supports 'amazon', '>= 2013.09'
version '0.1.0'

recipe 'export-attributes', 'Dumps chef node attributes to json file'
recipe 'export-node', 'Dumps chef node to json file'
