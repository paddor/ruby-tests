#! /opt/local/bin/ruby

print "\e[2J"
100.times do |p|
  print "\e[0;0H" # move to 0:0
  print "\e[K" # clear rest of line

  color = case p
          when 0..30 then "0;31"
          when 31..60 then "0;33"
          when 61..90 then "0;32"
          when 91..100 then "1;32"
          end

  print "\e[%sm" % color # color
  print "[ "
  progress = p+1
  print "=" * progress
  print " " * (100 - progress)
  print " | %3d%% ]" % progress
  sleep 0.03
end

sleep 1

(0..99).to_a.reverse.each do |p|
  print "\e[0;0H" # move to 0:0
  print "\e[K" # clear rest of line
  color = case p
          when 0..30 then "0;31"
          when 31..60 then "0;33"
          when 61..90 then "0;32"
          when 91..100 then "1;32"
          end
  print "\e[%sm" % color # color

  print "[ "
  progress = p+1
  print "=" * progress
  print " " * (100 - progress)
  print " | %3d%% ]" % progress
  sleep 0.03
end

print "\e[0;0H" # move to 0:0
print "\e[K" # clear rest of line
print "\e[0m" # clear color

puts "finished"
