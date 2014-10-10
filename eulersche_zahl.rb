require 'bigdecimal'
require 'bigdecimal/math'

# Calculus. How precisely can I calculate Euler's number?

class Integer
  def fact
    return self * (self-1).fact if self > 1
    return 1
  end
end


Positions = 40
Precision = 1 * 10 ** -Positions

puts "precision positions: #{Positions}"

puts "\n##### Math::E ######"
puts "e = #{Math::E}"

##
# with simple Float
#
puts "\n##### calculated with simple Float ######"
e = 0
i = 0
while true
  add = 1.0/i.fact
#  puts "#{i}: add = #{add}"
  e += add
  break if add <= Precision
  i += 1
end
puts "e = #{e.round(Positions)}"

##
# with BigDecimal
#
puts "\n##### calculated with BigDecimal ######"
e = BigDecimal.new('0')
i = 0
one = BigDecimal.new('1')
while true
  add = one/i.fact
#  puts "#{i}: add = #{add}"
  e += add
  break if add <= Precision
  i += 1
end
puts "e = #{e.round(Positions).to_s('F')}"

##
# with BigMath::E()
#
puts "\n##### calculated with BigMath::E() ######"
e = BigMath::E(Positions)
puts "e = #{e.round(Positions).to_s('F')}"
