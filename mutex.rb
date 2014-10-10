#! /usr/local/bin/ruby

@i = 0

def inc(num) num + 1 end
m = Mutex.new

threads = []
10.times do
  t = Thread.new do
    1_000_000.times do
      m.synchronize { @i = inc(@i) }
      #@i = @i + 1
    end
  end
  threads << t
end

threads.each { |t| t.join }

puts @i
