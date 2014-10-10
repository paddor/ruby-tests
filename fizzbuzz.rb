a=b=c=nil
(1..13).each do |num|
  puts "num = #{num.inspect}"
  puts "[a,b,c] = #{[a,b,c].inspect}"
  print num, ?\r,
    ("Fizz" unless (a = !a) .. (a = !a)),
    ("Buzz" unless (b = !b) ... !((c = !c) .. (c = !c))),
    ?\n
end
