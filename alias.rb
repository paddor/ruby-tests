#! /usr/local/bin/ruby

puts "with alias:"
def foo
  puts "i'm foo!"
end

alias bar foo

foo
bar

def foo
  puts "i'm the new foo!"
end

foo
bar


puts
puts "with alias_method:"

module Bla

  def bla
    puts "i'm bla!"
  end

  alias_method :bli, :bla
end

include Bla

bla
bli

module Bla
  def bla
    puts "i'm the new bla!"
  end
end

include Bla

bla
bli
