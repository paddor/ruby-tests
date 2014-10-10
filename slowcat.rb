#!/usr/bin/env ruby
# slowcat - emulate a   s l o w   line printer
# usage: slowcat [-DELAY] [files ...]
# the following line with "&&" works because all strings are true
delay = ARGV[0] =~ /^-([.\d]+)/ ? ARGV.shift && $1.to_i : 1
$stdout.sync = true
input = $stdin
input = ARGF if input.tty?
while input.gets
    for b in split('')
        print b
        #sleep(0.005 * rand(delay)) # funny with -100 :P
        sleep(0.005 * delay)
    end
end
