require 'spec_helper'

port = $node['php-fpm']['pools']['www']['listen'].split(':').fetch(1)

describe port(port) do
  it { should be_listening }
end

describe command('php -v') do
  its(:exit_status) { should eq 0 }
end
