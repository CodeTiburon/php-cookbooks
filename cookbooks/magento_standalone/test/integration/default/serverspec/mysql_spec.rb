require 'spec_helper'

puts "os: #{os}"

def mysql_bin
  return '/opt/mysql57/bin/mysql' if os[:family] =~ /solaris/
  return '/opt/local/bin/mysql' if os[:family] =~ /smartos/
  '/usr/bin/mysql'
end

def mysqld_bin
  return '/opt/mysql51/bin/mysqld' if os[:family] =~ /solaris/
  return '/opt/local/bin/mysqld' if os[:family] =~ /smartos/
  '/usr/sbin/mysqld'
end

def mysql_cmd
  <<-EOF
  #{mysql_bin} \
  -h 127.0.0.1 \
  -P 3306 \
  -u root \
  -pilikerandompasswords \
  -e "SELECT Host,User,Password FROM mysql.user WHERE User='root' AND Host='%';" \
  --skip-column-names
  EOF
end

def mysqld_cmd
  "#{mysqld_bin} --version"
end

describe command(mysql_cmd) do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/| % | root | *4C45527A2EBB585B4F5BAC0C29F4A20FB268C591 |/) }
end

describe command(mysqld_cmd) do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/Ver 5.7/) }
end
