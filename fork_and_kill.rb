#! /usr/local/bin/ruby

fork do
  #Process.setsid
  puts "child"
  sleep 1
  puts "child still alive"
  sleep 1
  puts "child still alive"
  sleep 1
  puts "child still alive"
end
Process.waitall
