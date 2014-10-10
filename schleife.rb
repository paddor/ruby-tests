#! /usr/local/bin/ruby

#while line = gets
#  next if line =~ /skip/i
#  puts "line: #{line}"
#end

h = {}
DATA.read.scan(/0 (\S+) (\S+)/) do |vorname,nachname|
  h[vorname] = nachname
  puts "#{vorname} => #{nachname}"
end
#p h
puts h.inspect
__END__
0 John Smith
0 Patrik Wenger
0 Matthias Mueller
