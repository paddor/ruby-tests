#! /usr/local/bin/ruby

IO.popen "-" do  |io|
  puts io.class.to_s
  puts "child: " + io.read if io
  sleep 1
end
