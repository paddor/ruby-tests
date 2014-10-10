#! /usr/bin/env ruby
# vim: 

def say_hello
  puts "hello!"
end

alias :again :say_hello

say_hello
again

def say_hello
  puts "hello! #2"
end

say_hello
again
