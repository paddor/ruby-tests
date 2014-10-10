#! /usr/local/bin/ruby
# Burrows–Wheeler transform
# (used in bzip2)

def bwt(s)
  last_rotation = s.chars.to_a
  rotations = [last_rotation.join]
  (s.length - 1).times do
    last_rotation = last_rotation.rotate
    rotations << last_rotation.join
  end

  # debug output
  puts "rotations:"
  rotations.each do |rotation|
    puts rotation
  end

  sorted = rotations.sort

  # debug output
  puts "sorted rotations:"
  rotations.each do |rotation|
    puts rotation
  end
  sorted.map{|r| r[-1] }.join
end

def inversebwt(s)
  out = Array.new(s.length, "")
  s.length.times do
    s.chars.each_with_index do |c,i|
      out[i] = c + out[i]
    end
    out.sort!
  end
  out.find { |r| r.end_with? "@" }
end

input = "^BANANA@"
output = bwt(input)
puts
puts output

puts
output = inversebwt("ANNB^AA@")
puts output

puts "\n\n\n\n"

input = "^ZZZZZZZZZZZZZZZZZZZZZZZZZZZZAAAAAAA@"
output = bwt(input)
puts
puts output

input = "^Patrik Wenger rechnet@"
output = bwt(input)
puts
puts output
output = inversebwt(output)
puts output


#puts
#output = inversebwt("ANNB^AA@")
#puts output
