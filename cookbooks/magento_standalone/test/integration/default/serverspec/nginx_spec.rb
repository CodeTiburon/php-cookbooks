require 'spec_helper'

describe service('nginx') do
  it { should be_enabled }
  it { should be_running }
end

describe port(80) do
  it { should be_listening }
end

describe command('nginx -t') do
  its(:stdout) { should_not match /test failed/ }
end
