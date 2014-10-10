# coding: utf-8

module Kernel
   alias λ proc

   def ∑(*args)
      sum = 0
      args.each{ |e| sum += e }
      sum
   end

   def √(root)
      Math.sqrt(root)
   end
end

# A real lambda
λ { puts'Hello' }.call

# Sigma - sum of all elements
puts ∑(1,2,3) 

# Square root
puts √ 49
