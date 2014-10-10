#! /usr/local/bin/ruby

require 'fiber'

reader=Fiber::new do
  File::open(__FILE__) do |f|
    f.each_line { |l| Fiber.yield(l) unless l.strip.empty? }
  end
end

puts "Let's get a line: #{reader.resume}"
puts "Let's get anothe line: #{reader.resume}"
puts "And the rest:"
puts reader.resume while reader.alive?
