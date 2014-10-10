#! /usr/local/bin/ruby

trap(:USR1) {}

fork_pid = fork do
  loop do
    sleep 2
    Process.kill :USR1, Process.ppid
  end
end

at_exit { Process.kill :KILL, fork_pid }


puts "trap set"
sleep 5
puts "sleeped"
sleep 3
puts "end"
