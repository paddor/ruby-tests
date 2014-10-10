#! /usr/local/bin/ruby
#require 'thread'

#m = Mutex.new

20.times do
  @array = []
  10_000.times do
    Thread.new do
      #m.synchronize do
        @array << "bla"
      #end
    end
  end
  sleep 0.1 until Thread.list.size == 1
  puts @array.size
end

