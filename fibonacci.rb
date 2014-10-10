#require 'curses'

a = nil
fib = Fiber.new do
  a, b = 0, 1
  while true
    Fiber.yield(a) # blocks and returns a
    a, b = b, a+b
  end
end

m = Mutex.new
trap :QUIT do
  m.synchronize{puts fib.resume} if !m.locked?
end

20.times { puts fib.resume }
#  Curses.crmode
#while true
#  #STDIN.gets
#  Curses.getch
#  puts fib.resume
#  Curses.refresh
#end
#sleep



# fib.resume #=> 0
# fib.resume #=> 1
# fib.resume #=> 1
# fib.resume #=> 2
# fib.resume #=> 3
# fib.resume #=> 5
# fib.resume #=> 8
# fib.resume #=> 13
# fib.resume #=> 21
# fib.resume #=> 34
# fib.resume #=> 55
