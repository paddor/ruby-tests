divisors = 1.upto(20).to_a.reverse
i = 20
while true
#  if divisors.all? {|d| i % d == 0}
#    puts i
#    exit
#  end

  dividable_by_all = true
  j = 20
  while j >= 1
    if i % j != 0
      dividable_by_all = false
      break
    end
    j -= 1
  end
  if dividable_by_all
    puts i
    exit
  end

  i+=20
end
