#! /opt/local/bin/ruby

class Foo
  def bar
    "baz"
  end
end


f = Foo.new.bar
puts f

$SAFE=1


#class Foo
  #def baz
    #"bar"
  #end
#end

#g = Foo.new.baz
#puts g

#require 'fileutils'
#FileUtils.touch '/tmp/foobar'

#STDERR.puts f
#
eval 'puts "evaled"'

i = STDIN.gets
#puts i.tainted?
puts i

Dir.chdir i
