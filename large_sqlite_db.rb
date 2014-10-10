#! /opt/local/bin/ruby
require 'sequel'

DB = Sequel.sqlite "large.db"

DB.create_table? :items do
  primary_key :id
  String :name
  String :server
  String :ip
  String :subscriber
  String :chaddr
  String :ciaddr
  String :yiaddr
  String :giaddr
  String :type
  String :message
  String :messagetype
  String :log
  String :dhcpserver
  String :dhcpserver_id
end

table = DB[:items]
values = {
    :name => "my name",
    :server => "ipc-zbir-bla-bli-02",
    :ip => "2.34.56.223",
    :subscriber => "1447003040",
    :chaddr => "87.2.54.1",
    :ciaddr => "",
    :yiaddr => nil,
    :giaddr => "12.55.76.123",
    :type => "NAK",
    :message => "this is a message. there are many messages, but this is
    mine.",
    :messagetype => "Accounting",
    :log => "this is a log. it lives in a logfile",
    :dhcpserver => "ipc-bei640-a-dh-02",
    :dhcpserver_id => "my not so unique ID",
}

#1_000_000.times { table.insert values }
begin
  100_000.times { table.insert values }
rescue Exception
  puts $!.inspect
end
#puts table.insert_sql(values)



#sql = %q[INSERT INTO `items` (`name`, `server`, `ip`, `subscriber`, `chaddr`, `ciaddr`, `yiaddr`, `giaddr`, `type`, `message`, `messagetype`, `log`, `dhcpserver`, `dhcpserver_id`) VALUES ('my name', 'ipc-zbir-bla-bli-02', '2.34.56.223', '1447003040', '87.2.54.1', '', NULL, '12.55.76.123', 'NAK', 'this is a message. there are many messages, but this is
#    mine.', 'Accounting', 'this is a log. it lives in a logfile', 'ipc-bei640-a-dh-02', 'my not so unique ID');]
#
#1_000_000.times { puts sql }
