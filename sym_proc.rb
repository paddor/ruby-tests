#! /usr/bin/env ruby
# vim: ts=2 sw=2 et

class Symbol
  def to_proc
    Proc.new { |obj, *args| obj.send(self, *args) }
  end
end

# a shortform for:  array.map {|i| i.next }
# could be:         array.map(&:next)

# ok, let's try this...

puts [1, 3, 4].map {|i| i.next}.inspect
puts [1, 3, 4].map(&:next).inspect

# yeehaaa!

# same for strings ...

class String
  def to_proc
    Proc.new { |obj, *args| obj.send(self, *args) }
  end
end

puts [1, 3, 4].map {|i| i.next}.inspect
puts [1, 3, 4].map(&"next").inspect

# yeehaaa!
