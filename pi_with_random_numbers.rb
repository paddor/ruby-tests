#! /usr/bin/env ruby
require 'bigdecimal'
require 'bigdecimal/math'

# Pi berechnen mit zufaelligen Zahlen.

A = BigDecimal 1103515245
C = BigDecimal 12345
M = BigDecimal 4294967296
Four = BigDecimal 4

def zufallsregen(n)
  z = BigDecimal "1.0"
  treffer = BigDecimal "0"
  1.upto(n) do
    z = (A*z+C) % M
    x = z/(M-1)
    z = (A*z+C) % M
    y = z/(M-1)
    treffer += BigDecimal 1 if in_einheitskreis?(x,y)
  end
  puts "treffer = #{treffer.to_i}/#{n}"
  return (treffer/n) * Four
end

def in_einheitskreis?(x,y)
  (x**2 + y**2) <= 1
end

puts "Math::PI = #{Math::PI}"
puts "BigMath::PI(50) = #{BigMath::PI(50)}"
[3, 10, 50, 100, 500, 1_000, 10_000, 100_000, 1_000_000].each do |n|
  pi = zufallsregen(n)
  puts "#{n} => #{pi.to_f}"
end
