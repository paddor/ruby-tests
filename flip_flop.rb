#! /opt/local/bin/ruby

STDIN.lines.each do |l|
  puts l if (/drei/ =~ l)...(/fuenf/ =~ l)
end
