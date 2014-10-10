#! /usr/local/bin/ruby


class String
  def === other
    puts "comparing ==="
    self == other
  end
end

a, b = "bla", "bla"

case a
#when b
#  puts "it's b!"
when "bla"
  puts "it's bla!"
else
  puts "nothing matched"
end
