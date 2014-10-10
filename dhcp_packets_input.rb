#! /usr/local/bin/ruby
require 'rubygems'
#require 'pp'
#require 'sequel'
#require 'ruby-prof'

# DHCP message types
Types = %w( discover offer request ack nack )

# mappings like "255.255.255.0" => 24
#PrefixLengths = {
#  "255.255.255.255" => 32,
#  "255.255.255.254" => 31,
#  "255.255.255.252" => 30,
#  "255.255.255.248" => 29,
#  "255.255.255.240" => 28,
#  "255.255.255.224" => 27,
#  "255.255.255.192" => 26,
#  "255.255.255.128" => 25,
#  "255.255.255.0" =>   24,
#  "255.255.254.0" =>   23,
#  "255.255.252.0" =>   22,
#  "255.255.248.0" =>   21,
#  "255.255.240.0" =>   20,
#  "255.255.224.0" =>   19,
#  "255.255.192.0" =>   18,
#  "255.255.128.0" =>   17,
#  "255.255.0.0" =>     16,
#  "255.254.0.0" =>     15,
#  "255.252.0.0" =>     14,
#  "255.248.0.0" =>     13,
#  "255.240.0.0" =>     12,
#  "255.224.0.0" =>     11,
#  "255.192.0.0" =>     10,
#  "255.128.0.0" =>     9,
#  "255.0.0.0" =>       8,
#  "254.0.0.0" =>       7,
#  "252.0.0.0" =>       6,
#  "248.0.0.0" =>       5,
#  "240.0.0.0" =>       4,
#  "224.0.0.0" =>       3,
#  "192.0.0.0" =>       2,
#  "129.0.0.0" =>       1,
#  "0.0.0.0" =>         0,
#}
#SubnetMasks = PrefixLengths.keys

# returns a random IP address
def an_ip_address
  (0..3).map { rand(255) }.join(".")
end

warn "Building 10'000 sample IP addresses ..."
IPAddresses = (0..10_000).map { an_ip_address }

# returns a random pseudo circuit ID
def a_circuitid
  chars =
    #%{abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ23456789\\?!@#^&%~`'-_+=*(){}]|/$\t\n\r"}
    %{abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ23456789\\?!@#^&%~`'-_+=*(){}]|/$\t"}
  clen = chars.length
  len = rand(100)
  #len = 30
  (0..len).map { i=rand(clen); chars[ i..i ] }.join
end

class Array
  def sample
    index = rand(size - 1)
    self[index]
  end
end unless Array.instance_methods.include?(:sample)

warn "Building 10'000 sample circuit IDs ..."
CircuitIDs = (0..20_000).map { a_circuitid }

warn "Building 10'000 sample remote IDs ..."
RemoteIDs = (0..10_000).map { 1_000_000_000 + rand(999_999_999) }

# returns a random DHCP packet as Hash
def a_packet
  data = {
    # between 25th and 27th of September 2010
    :sent_at => Time.at(1285365600 + rand(259199)),
    :message_type => (type=Types.sample.to_sym),
    :received_from => nil,
    :transmitted_to => nil,
    :remoteid => RemoteIDs.sample,
    :circuitid => CircuitIDs.sample,
  }

  case type
  when :request
    # could be the first request of a session,
    # then we don't want a received_from IP addr
    if rand() > 0.2
      data[:received_from] = IPAddresses.sample
    end
  when :ack, :nack
    data[:transmitted_to] = IPAddresses.sample
    #data[:subnet_mask] = SubnetMasks.sample
    data[:subnet_mask] = "255.255.255.0"
  end

  return data
end

# build a list of DHCP packets (Array of Hashes)
num = ARGV.first.to_i
warn "Building #{num} DHCP packets ..."
packets = []
#num.times { packets << a_packet }

require 'benchmark'
Benchmark.bmbm do |bm|
  bm.report "generation of packets" do
    num.times { a_packet }
  end
end
#pp packets
exit

# build COPY command and data
warn "Building COPY command and its data ..."
copy_command = "COPY dhcp_packets (message_type, received_from, \
transmitted_to, circuitid, remoteid, sent_at) FROM stdin;"
copy_data = nil
#result = RubyProf.profile do
  copy_rows = []
  while packet = packets.pop
    fields = []
    fields << packet[:message_type]
    fields << (packet[:received_from] || '\N')

    transmitted_to = if t_to = packet[:transmitted_to]
      #"#{t_to}/#{PrefixLengths[ packet[:subnet_mask] ]}"
      "#{t_to}/24"
    else
      '\N'
    end
    fields << transmitted_to

    # escape: backlash, LF, CR and tab
    circuitid = packet[:circuitid].gsub(/([\\\n\r\t])/, '\\\\\1')
    fcircuitid = packet[:circuitid].
      gsub("\\") { "\\\\" }.
      gsub("\n", "\\\n").
      gsub("\r", "\\\r").
      gsub("\t", "\\\t")
    if circuitid != fcircuitid
      warn "input      = #{packet[:circuitid]}"
      warn "circuitid  = #{circuitid}"
      warn "fcircuitid = #{fcircuitid}"
      raise "not the same!"
    end
    fields << circuitid

    fields << packet[:remoteid]
    fields << packet[:sent_at].strftime("%F %H:%M:%S")

    copy_rows << fields.join("\t")
  end
  copy_data = copy_rows.join("\n")
#end
#puts copy_data

File.open "dhcp_packets_copy_data.txt", "w" do |f|
  f.puts copy_command
  f.puts copy_data
  f.puts"\\."
end

warn "Opening database connection ..."
DB = Sequel.postgres(:host=>'localhost', :user=>'logs', :database=>'logs')
warn "Running COPY command with data ..."
DB.run copy_command
DB.synchronize do |conn|
  ret = conn.put_copy_data(copy_data) # or raise "could not send COPY data"
  warn "Sent COPY data: #{ret}"
  ret = conn.put_copy_end # or raise "could not send COPY end"
  warn "Sent COPY end: #{ret}"

  while result = conn.get_result
    warn "Result of COPY is: %s" % result.res_status(result.result_status) 
  end
end
DB.disconnect

#printer = RubyProf::FlatPrinter.new(result)
#printer.print(STDOUT, min_percent: 1)
